//
//  OTWPersonalEditNickname.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/9.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalEditNicknameController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWUserModel.h"
#import "MBProgressHUD+PYExtension.h"


static NSString *nickNameUrl = @"/app/user/update/name";

@interface OTWPersonalEditNicknameController()

@property (nonatomic,strong) UITextField *nicknameTextField;


@end

@implementation OTWPersonalEditNicknameController

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(self);
    self.customNavigationBar.rightButtonClicked=^{
        [weakself saveNickname];
    };
    [self buildUI];
}

#pragma mark - UI
- (void)buildUI
{
    //设置头部信息
    self.title = @"修改名称";
    
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    [self setRightNavigationTitle:@"保存"];
    //设置背景色
    self.view.backgroundColor = [UIColor color_f4f4f4];
    
    //第一条线
    UIView *underLineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 73.5, SCREEN_WIDTH, 0.5)];
    underLineTopView.backgroundColor = [UIColor color_d5d5d5];
    [self.view addSubview:underLineTopView];
    
    //设置nickname修改背景
    UIView *nicknameEditView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 50)];
    nicknameEditView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nicknameEditView];
    
    //nickname输入框
    [nicknameEditView addSubview:self.nicknameTextField];
    
    //第二条线
    UIView *underLineButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 74+0.5+50, SCREEN_WIDTH, 0.5)];
    underLineButtonView.backgroundColor = [UIColor color_d5d5d5];
    [self.view addSubview:underLineButtonView];
    
}

-(void) saveNickname
{
    NSString *name = self.nicknameTextField.text;
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
    [self sendRequest:userDict completion:^(id result, NSError *error) {
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
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                });
                dispatch_resume(_timer);
            } else {
                [self netWorkErrorTips:error];
            }
        }
    }];
}

-(void)sendRequest:(NSDictionary *)params completion:(requestCompletionBlock)block
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nicknameTextField resignFirstResponder];
}

#pragma mark - Setter Getter

-(UITextField*)nicknameTextField{
    if(!_nicknameTextField){
        _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-15*2, 20)];
        _nicknameTextField.font = [UIFont systemFontOfSize:16];
        _nicknameTextField.textColor = [UIColor color_202020];
        _nicknameTextField.text = [OTWUserModel shared].name;
    }
    return _nicknameTextField;
}


@end




