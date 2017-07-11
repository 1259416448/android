//
//  OTWLaunchViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWLaunchViewController.h"
#import "OTWLaunchManager.h"

@interface OTWLaunchViewController ()

@end

@implementation OTWLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - UI
- (void)buildUI
{
    // 根据登录状态显示 登录页还是主页
    //[[OTWLaunchManager sharedManager] showPersonalEditNicknameView];
    [[OTWLaunchManager sharedManager] showLoginView];
    //[[OTWLaunchManager sharedManager] showMainTabView];
    //[[OTWLaunchManager sharedManager] showPersonalInfoView];
    [[OTWLaunchManager sharedManager] showPersonalSiteView];
    //[[OTWLaunchManager sharedManager] showPersonalMyView];
}

@end
