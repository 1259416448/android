//
//  OTWLaunchManager.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/7.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWLaunchManager.h"
#import "OTWLoginViewController.h"

#import "OTWFindViewController.h"
#import "OTWFootprintsViewController.h"
#import "OTWARViewController.h"
#import "OTWNewsViewController.h"
#import "OTWPersonalViewController.h"
#import "OTWPrintARViewController.h"
#import "OTWPlaneMapViewController.h"


#import "OTWUserModel.h"

@interface OTWLaunchManager ()

@property (nonatomic, strong) OTWLoginViewController *loginViewController;

@end

@implementation OTWLaunchManager

+ (instancetype)sharedManager
{
    static OTWLaunchManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OTWLaunchManager alloc] init];
    });
    return manager;
}

#pragma mark - Public methods

- (BOOL)showLoginViewWithController:(UIViewController*)viewController completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0)
{
    if (!viewController) return NO;
    //判断用户信息
    [[OTWUserModel shared] load];
    //检查是否存在用户信息
    if(![OTWUserModel shared].username
       ||[[OTWUserModel shared].username isEqualToString:@""]){
       [viewController presentViewController:[[OTWLoginViewController alloc] init] animated:YES completion:completion];
        return YES;
    }
    return NO;
}

- (void)showLoginView
{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.loginViewController];
        self.mainTabController = nil;
    });
}

- (void)showMainTabView
{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.mainTabController];
        self.loginViewController = nil;
    });
}

- (void)showSelectedControllerByIndex:(OTWTabBarSelectedIndex)selectIndex
{
    [self.mainTabController didSelectedItemByIndex:selectIndex];
}

#pragma mark - Getter & Setter

- (OTWLoginViewController*)loginViewController
{
    if (!_loginViewController) {
        _loginViewController = [[OTWLoginViewController alloc] init];
        //_loginViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    }
    
    return _loginViewController;
}

- (OTWTabBarController*)mainTabController
{
    if (!_mainTabController) {
        _mainTabController = [OTWTabBarController createTabBarController:^OTWTabBarConfig *(OTWTabBarConfig *config) {
            
            OTWFindViewController *findVC = [[OTWFindViewController alloc] init];
            UINavigationController * findNav = [[UINavigationController alloc] initWithRootViewController:findVC]; // 发现
            
            OTWPrintARViewController *footprintArVC = [[OTWPrintARViewController alloc] init];
            
            UINavigationController * footprintsNav = [[UINavigationController alloc] initWithRootViewController:footprintArVC]; // 足迹Ar
            
            OTWARViewController * arVC = [[OTWARViewController alloc] init];
            UINavigationController * arNav = [[UINavigationController alloc] initWithRootViewController:arVC]; // AR
            
            OTWNewsViewController *newsVC = [[OTWNewsViewController alloc] init];
            UINavigationController * newsNav = [[UINavigationController alloc] initWithRootViewController:newsVC]; // 消息
            
            OTWPersonalViewController *personalVC = [[OTWPersonalViewController alloc] init];
            UINavigationController * personalNav = [[UINavigationController alloc] initWithRootViewController:personalVC]; // 我的
            
            OTWFootprintsViewController *footprintsVC = [[OTWFootprintsViewController alloc] init]; //足迹列表
            UINavigationController *footprintsList = [[UINavigationController alloc] initWithRootViewController:footprintsVC];
            
            OTWPlaneMapViewController *footprintPlaneMapVC = [[OTWPlaneMapViewController alloc] init]; //足迹地图
            UINavigationController *footprintsMap = [[UINavigationController alloc] initWithRootViewController:footprintPlaneMapVC];
            
            config.viewControllers = @[findNav, footprintsNav, arNav, newsNav, personalNav,footprintsList,footprintsMap];
            
            config.normalImages = @[@"fx_faxian", @"fx_zuji", @"fx_AR", @"fx_xiaoxi", @"fx_wode",@"fx_zuji",@"fx_zuji"];
            config.selectedImages = @[@"fx_faxian_click", @"fx_zuji", @"fx_AR", @"fx_xiaoxi_click", @"fx_wode_click",@"fx_zuji",@"fx_zuji"];
            config.titles = @[@"发现", @"足迹", @"AR", @"消息", @"我的",@"足迹列表",@"足迹地图"];
            config.selectedColor = [UIColor colorWithHexString:@"262626"];
            config.normalColor = [UIColor colorWithHexString:@"9b9b9b"];
            return config;
        }];
    }
    return _mainTabController;
}

@end
