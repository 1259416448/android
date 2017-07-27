//
//  OTWBaseViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"
#import "OTWCustomNavigationBar.h"
#import <MBProgressHUD.h>

@interface OTWBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation OTWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    WeakSelf(self);
    _customNavigationBar = [[OTWCustomNavigationBar alloc] init];
    //_customNavigationBar.leftImage = [UIImage imageNamed:@"back_2"];
    _customNavigationBar.leftButtonClicked = ^{
        [weakself leftNavigaionButtonClicked];
    };
    _customNavigationBar.rightButtonClicked = ^{
        [weakself rightNavigaionButtonClicked];
    };
    _customNavigationBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_customNavigationBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setHiddenCustomNavigation:(BOOL)hiddenCustomNavigation {
    _hiddenCustomNavigation = hiddenCustomNavigation;
    self.customNavigationBar.hidden = hiddenCustomNavigation;
}

- (CGFloat)navigationHeight {
    return 64.0;
}

- (void)setCustomNavigationLeftView:(UIView*)view {
    [self.customNavigationBar setLeftView:view];
}
- (void)setCustomNavigationRightView:(UIView*)view {
    [self.customNavigationBar setRightView:view];
}
- (void)setCustomNavigationCenterView:(UIView*)view {
    [self.customNavigationBar setTitleView:view];
}

- (void)setTitle:(NSString *)title {
    self.customNavigationBar.title = title;
}

- (void)setNavigationColor:(UIColor *)navigationColor {
    self.customNavigationBar.backgroundColor = navigationColor;
}

- (void)setNavigationImage:(UIImage *)navigationImage {
    [self.customNavigationBar setBackgroundImage:navigationImage];
}

- (void)setRightNavigationTitle:(NSString *)rightNavigationTitle {
    _rightNavigationTitle = rightNavigationTitle;
    self.customNavigationBar.rightTitle = rightNavigationTitle;
}

- (void)setLeftNavigationTitle:(NSString *)leftNavigationTitle {
    _leftNavigationTitle = leftNavigationTitle;
    self.customNavigationBar.leftTitle = leftNavigationTitle;
}

- (void)setLeftNavigationImage:(UIImage *)leftNavigationImage {
    self.customNavigationBar.leftImage = leftNavigationImage;
}

- (void)setRightNavigationImage:(UIImage *)rightNavigationImage {
    self.customNavigationBar.rightImage = rightNavigationImage;
}

- (void)leftNavigaionButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigaionButtonClicked {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)netWorkErrorTips:(NSError*)error{
    DLog(@"请求失败>>>>：%@",error);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    if(error.code == -1004){
        hud.label.text =@"服务端繁忙，请稍后";
    }else if(error.code == -1001){
        hud.label.text =@"请求超时";
    }else if(error.code== -1009){
        hud.label.text =@"网络访问错误";
    }else{
        hud.label.text =@"服务端繁忙，请稍后";
    }
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    [hud hideAnimated:YES afterDelay:2];
}

- (void) errorTips:(NSString *)tips userInteractionEnabled:(BOOL)userInteractionEnabled
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tips;
    hud.label.numberOfLines = 0;
    hud.userInteractionEnabled = userInteractionEnabled;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    [hud hideAnimated:YES afterDelay:2];
}

@end
