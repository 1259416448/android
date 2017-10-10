//
//  ImprovePersonInfoViewController.m
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/10/9.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ImprovePersonInfoViewController.h"

@interface ImprovePersonInfoViewController ()

@property (nonatomic,strong) UIButton *headImageBtn;
@property (nonatomic,strong) UILabel *headImageLable;
@property (nonatomic,strong) UITextField *nameTF;
@property (nonatomic,strong) UIView *underLineRightView;

@property (nonatomic,strong) UIButton *sureButton;
@property (nonatomic,strong) UIView *sureBtnView;
@property (nonatomic,strong) UIImageView *sureBtnImg;

@end

@implementation ImprovePersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"完善信息";
    [self buildUI];
}
- (void)buildUI
{
    [self.view addSubview:self.headImageBtn];
    [self.view addSubview:self.headImageLable];
    [self.view addSubview:self.nameTF];
    [self.view addSubview:self.sureBtnView];
    [self.sureBtnView addSubview:self.sureBtnImg];
    [self.sureBtnView addSubview:self.sureButton];
}
- (void)changeHeadImage
{
    
}
- (void)sureButtonClick
{
    
}
- (UIButton *)headImageBtn
{
    if (!_headImageBtn) {
        _headImageBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, 65, 100, 100)];
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
        _headImageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, SCREEN_WIDTH, 41)];
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
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 226, SCREEN_WIDTH - 60, 44)];
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
        _sureBtnView=[[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.nameTF.frame) + 50, SCREEN_WIDTH - 60, 44)];
    }
    return _sureBtnView;
}

-(UIImageView*)sureBtnImg{
    if(!_sureBtnImg){
        _sureBtnImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 44)];
        _sureBtnImg.image=[UIImage imageNamed:@"dl_button"];
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
