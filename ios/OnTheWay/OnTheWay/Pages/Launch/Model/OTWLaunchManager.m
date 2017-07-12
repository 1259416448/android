//
//  OTWLaunchManager.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/7.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWLaunchManager.h"
#import "OTWLoginViewController.h"
#import "OTWRootViewController.h"
#import "OTWPersonalInfoController.h"
#import "OTWPersonalEditNicknameController.h"
#import "OTWPersonalSiteController.h"
#import "OTWFootprintsViewController.h"

#import "OTWTabBarController.h"
#import "OTWFindViewController.h"
#import "OTWFootprintsViewController.h"
#import "OTWARViewController.h"
#import "OTWNewsViewController.h"
#import "OTWPersonalViewController.h"

@interface OTWLaunchManager ()

@property (nonatomic, strong) UINavigationController *loginViewController;
@property (nonatomic, strong) UINavigationController *personalEditNicknameController;
@property (nonatomic, strong) OTWRootViewController *mainTabViewController;
@property (nonatomic,strong) UINavigationController *personalInfoController;
@property (nonatomic,strong) UINavigationController *personalSiteController;
@property (nonatomic,strong) UINavigationController *personalMyController;
@property (nonatomic,strong) UINavigationController *footprintsViewController;

@property (nonatomic, strong) OTWTabBarController *mainTabController;

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

#pragma mark - Private methods

- (void)showLoginView
{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.loginViewController];
        self.mainTabController = nil;
    });
}

- (void)showPersonalEditNicknameView
{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.personalEditNicknameController];
        self.mainTabController = nil;
    });
}
- (void)showPersonalInfoView{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.personalInfoController];
        self.mainTabController = nil;
    })
}
- (void)showPersonalSiteView{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.personalSiteController];
        self.mainTabController = nil;
    })
}

- (void)showPersonalMyView{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.personalMyController];
        self.mainTabController = nil;
    })
}
- (void)showMainTabView
{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.mainTabController];
        self.loginViewController = nil;
    });
}

- (void)showFootprintView
{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.footprintsViewController];
        self.loginViewController = nil;
    });
}

#pragma mark - Getter & Setter

- (UINavigationController*)loginViewController
{
    if (!_loginViewController) {
        OTWLoginViewController *loginVC = [[OTWLoginViewController alloc] init];
        _loginViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    }
    
    return _loginViewController;
}

- (UINavigationController*)personalEditNicknameController
{
    if(!_personalEditNicknameController){
        OTWPersonalEditNicknameController *personalEditNicknameVC = [[OTWPersonalEditNicknameController alloc] init];
        _personalEditNicknameController = [[UINavigationController alloc] initWithRootViewController:personalEditNicknameVC];
    }
    return _personalEditNicknameController;
}


- (UINavigationController*)personalInfoController{
    if(!_personalInfoController){
        OTWPersonalInfoController *personalInfoVC = [[OTWPersonalInfoController alloc] init];
        _personalInfoController = [[UINavigationController alloc] initWithRootViewController:personalInfoVC];
    }
    return _personalInfoController;
}

- (UINavigationController*)personalSiteController{
    if(!_personalSiteController){
        OTWPersonalSiteController *personaSiteVC = [[OTWPersonalSiteController alloc] init];
        _personalSiteController = [[UINavigationController alloc] initWithRootViewController:personaSiteVC];
    }
    return _personalSiteController;
}

-(UINavigationController*)footprintsViewController{
    if(!_footprintsViewController){
        OTWFootprintsViewController *footprintsVC = [[OTWFootprintsViewController alloc] init];
        _footprintsViewController = [[UINavigationController alloc] initWithRootViewController:footprintsVC];
    }
    return _footprintsViewController;
}


- (OTWRootViewController*)mainTabViewController
{
    if (!_mainTabViewController) {
        _mainTabViewController = [[OTWRootViewController alloc] init];
    }
    
    return _mainTabViewController;
}

- (OTWTabBarController*)mainTabController
{
    if (!_mainTabController) {
        _mainTabController = [OTWTabBarController createTabBarController:^OTWTabBarConfig *(OTWTabBarConfig *config) {
            
            OTWFindViewController *findVC = [[OTWFindViewController alloc] init];
            UINavigationController * findNav = [[UINavigationController alloc] initWithRootViewController:findVC]; // 发现
            
            OTWFootprintsViewController *footprintsVC = [[OTWFootprintsViewController alloc] init];
            UINavigationController * footprintsNav = [[UINavigationController alloc] initWithRootViewController:footprintsVC]; // 足迹
            
            OTWARViewController * arVC = [[OTWARViewController alloc] init];
            UINavigationController * arNav = [[UINavigationController alloc] initWithRootViewController:arVC]; // AR
            
            OTWFootprintsViewController *newsVC = [[OTWFootprintsViewController alloc] init];
            UINavigationController * newsNav = [[UINavigationController alloc] initWithRootViewController:newsVC]; // 消息
            
            OTWPersonalViewController *personalVC = [[OTWPersonalViewController alloc] init];
            UINavigationController * personalNav = [[UINavigationController alloc] initWithRootViewController:personalVC]; // 我的
            
            config.viewControllers = @[findNav, footprintsNav, arNav, newsNav, personalNav];
            config.normalImages = @[@"tab_faxian", @"tab_zuji", @"tab_AR", @"tab_xiaoxi", @"tab_wode"];
            config.selectedImages = @[@"tab_faxian_click", @"tab_zuji", @"tab_AR", @"tab_xiaoxi_click", @"tab_wode_click"];
            config.titles = @[@"发现", @"足迹", @"AR", @"消息", @"我的"];
            config.selectedColor = [UIColor colorWithHexString:@"262626"];
            config.normalColor = [UIColor colorWithHexString:@"9b9b9b"];
            
            return config;
        }];
    }
    
    return _mainTabController;
}

@end
