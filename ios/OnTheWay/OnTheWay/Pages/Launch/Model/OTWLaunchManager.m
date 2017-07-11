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

@interface OTWLaunchManager ()

@property (nonatomic, strong) UINavigationController *loginViewController;
@property (nonatomic, strong) UINavigationController *personalEditNicknameController;
@property (nonatomic, strong) OTWRootViewController *mainTabViewController;
@property (nonatomic,strong) UINavigationController *personalInfoController;
@property (nonatomic,strong) UINavigationController *personalSiteController;
@property (nonatomic,strong) UINavigationController *personalMyController;

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
        self.mainTabViewController = nil;
    });
}

- (void)showPersonalEditNicknameView
{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.personalEditNicknameController];
        self.mainTabViewController = nil;
    });
}
- (void)showPersonalInfoView{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.personalInfoController];
        self.mainTabViewController = nil;
    })
}
- (void)showPersonalSiteView{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.personalSiteController];
        self.mainTabViewController = nil;
    })
}

- (void)showPersonalMyView{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.personalMyController];
        self.mainTabViewController = nil;
    })
}
- (void)showMainTabView
{
    GCDMain(^{
        [[UIApplication sharedApplication].keyWindow setRootViewController:self.mainTabViewController];
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

- (OTWRootViewController*)mainTabViewController
{
    if (!_mainTabViewController) {
        _mainTabViewController = [[OTWRootViewController alloc] init];
    }
    
    return _mainTabViewController;
}

@end
