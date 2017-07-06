//
//  OTWBaseViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"
#import "OTWCustomNavigationBar.h"

@interface OTWBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation OTWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor color_eff1ee];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    WeakSelf(self);
    _customNavigationBar = [[OTWCustomNavigationBar alloc] init];
    _customNavigationBar.leftImage = [UIImage imageNamed:@"back"];
    _customNavigationBar.leftButtonClicked = ^{
        [weakself leftNavigaionButtonClicked];
    };
    _customNavigationBar.rightButtonClicked = ^{
        [weakself rightNavigaionButtonClicked];
    };
    
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
    return 75.0;
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

@end
