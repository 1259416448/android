//
//  ImprovePersonInfoViewController.m
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/10/9.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ImprovePersonInfoViewController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWAlbumSelectHelper.h"
#import "QiniuUploadService.h"
#import "OTWUserModel.h"

static NSString *userImageUrl = @"/app/user/update/image";
static NSString *nickNameUrl = @"/app/user/update/name";

@interface ImprovePersonInfoViewController ()

@property (nonatomic,strong) UIButton *headImageBtn;
@property (nonatomic,strong) UILabel *headImageLable;
@property (nonatomic,strong) UITextField *nameTF;
@property (nonatomic,strong) UIView *underLineRightView;

@property (nonatomic,strong) UIButton *sureButton;
@property (nonatomic,strong) UIView *sureBtnView;
@property (nonatomic,strong) UIButton *skipBtn;

@property (nonatomic,strong) UIImageView *sureBtnImg;

@end

@implementation ImprovePersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"完善信息";
    [self buildUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.customNavigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.customNavigationBar.hidden = NO;
}
- (void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCustomNavigationRightView:self.skipBtn];
    [self.view addSubview:self.headImageBtn];
    [self.view addSubview:self.headImageLable];
    [self.view addSubview:self.nameTF];
    [self.view addSubview:self.sureBtnView];
    [self.sureBtnView addSubview:self.sureBtnImg];
    [self.sureBtnView addSubview:self.sureButton];
}
- (void)changeHeadImage
{
    [[OTWAlbumSelectHelper shared] showInViewController:self imageBlock:^(UIImage *image) {
        if (image) {
            [self uploadImageToServer:image];
        }
    }];
}
- (void)sureButtonClick
{
    NSString *name = self.nameTF.text;
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (name.length == 0) {
        [self errorTips:@"请输入名称" userInteractionEnabled:NO];
        return;
    }
    NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.label.text = @"正在保存";
    [self sendNickNameRequest:userDict completion:^(id result, NSError *error) {
        if (result) {
            [hud hideAnimated:YES];
            if ([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]) {
                [self errorTips:@"修改成功" userInteractionEnabled:NO];
                //保存用户信息
                [OTWUserModel shared].name = name;
                [[OTWUserModel shared] dump];
                //推送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userEdit" object:self];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),2.0*NSEC_PER_SEC, 0); //2秒后执行
                dispatch_source_set_event_handler(_timer, ^{
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self skipBtnClick];
                    });
                });
                dispatch_resume(_timer);
            } else {
                [self netWorkErrorTips:error];
            }
        }
    }];
}
- (void)skipBtnClick
{
    [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexPersonal];
    UIViewController * presentingViewController = self.presentingViewController;
    while (presentingViewController.presentingViewController) {
        presentingViewController = presentingViewController.presentingViewController;
    }
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)uploadImageToServer:(UIImage *)image
{
    //上传图片到七牛
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.label.text = @"正在上传头像";
    [QiniuUploadService uploadImage:image progress:^(NSString *key, float progress) {
        DLog(@"已成功上传了 progress %f",progress);
    } success:^(OTWDocument *document) {
        NSDictionary *documentDict = document.mj_keyValues;
        [self sendHeadImageUrlRequest:documentDict completion:^(id result, NSError *error) {
            if (result) {
                [hud hideAnimated:YES];
                if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
                    //保存用户信息
                    [OTWUserModel shared].headImg = result[@"body"][@"headImg"];
                    [[OTWUserModel shared] dump];
                    //推送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userEdit" object:self];
//                    personalHeadImageView.image = image;
                    [self.headImageBtn setImage:image forState:UIControlStateNormal];
                    [self errorTips:@"上传成功" userInteractionEnabled:NO];
                }else{
                    DLog(@"message - %@  messageCode - %@",result[@"message"],result[@"messageCode"]);
                    [self errorTips:@"上传失败，请检查您的网络是否连接" userInteractionEnabled:YES];
                }
            }
        }];
    } failure:^{
        [hud hideAnimated:YES];
        [self errorTips:@"头像失败，请检查您的网络是否连接" userInteractionEnabled:YES];
    }];
}
-(void)sendHeadImageUrlRequest:(NSDictionary *)params completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doPOST:userImageUrl parameters:params success:^(id responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}
-(void)sendNickNameRequest:(NSDictionary *)params completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doPOST:nickNameUrl parameters:params success:^(id responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}
- (UIButton *)headImageBtn
{
    if (!_headImageBtn) {
        _headImageBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, 65 + 64, 100, 100)];
        [_headImageBtn setImage:[UIImage imageNamed:@"dl_touxiang"] forState:UIControlStateNormal];
        [_headImageBtn addTarget:self action:@selector(changeHeadImage) forControlEvents:UIControlEventTouchUpInside];
        _headImageBtn.layer.masksToBounds = YES;
        _headImageBtn.layer.cornerRadius = 50;
    }
    return _headImageBtn;
}
- (UILabel *)headImageLable
{
    if (!_headImageLable) {
        _headImageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 165 + 64, SCREEN_WIDTH, 41)];
        _headImageLable.font = [UIFont systemFontOfSize:15];
        _headImageLable.textColor = [UIColor color_202020];
        _headImageLable.textAlignment = NSTextAlignmentCenter;
        _headImageLable.text = @"头像";
    }
    return _headImageLable;
}
- (UITextField *)nameTF
{
    if (!_nameTF) {
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 226 + 64, SCREEN_WIDTH - 60, 44)];
        _nameTF.placeholder = @"请设置您的昵称";
        _nameTF.font = [UIFont systemFontOfSize:16];
        _nameTF.textAlignment = NSTextAlignmentCenter;
        _nameTF.layer.masksToBounds = YES;
        _nameTF.layer.cornerRadius = 20;
        _nameTF.layer.borderWidth = 0.5;
        _nameTF.layer.borderColor = [UIColor color_d5d5d5].CGColor;
    }
    return _nameTF;
}
-(UIView*)sureBtnView{
    if(!_sureBtnView){
        _sureBtnView=[[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.nameTF.frame) + 50, SCREEN_WIDTH - 60, 75)];
        _sureBtnView.userInteractionEnabled = YES;
    }
    return _sureBtnView;
}

-(UIImageView*)sureBtnImg{
    if(!_sureBtnImg){
        _sureBtnImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 75)];
        _sureBtnImg.image=[UIImage imageNamed:@"dl_button"];
        _sureBtnImg.userInteractionEnabled = YES;
    }
    return _sureBtnImg;
}

-(UIButton*)sureButton
{
    if(!_sureButton){
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(0, 0, SCREEN_WIDTH - 60, 44);
        _sureButton.backgroundColor = [UIColor clearColor];
        [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.userInteractionEnabled = NO;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _sureButton.layer.cornerRadius = 20;
    }
    return _sureButton;
}
- (UIButton *)skipBtn
{
    if (!_skipBtn) {
        _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 22, 60, 40)];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor color_c4c4c4] forState:UIControlStateNormal];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
