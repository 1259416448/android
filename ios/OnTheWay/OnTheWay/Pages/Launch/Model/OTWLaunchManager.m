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
#import "OTWBusinessARViewController.h"
#import "OTWNewsViewController.h"
#import "OTWPersonalViewController.h"
#import "OTWPrintARViewController.h"
#import "OTWPlaneMapViewController.h"
#import "OTWBusinessARPoiViewController.h"
#import "ImprovePersonInfoViewController.h"

#import "OTWUserModel.h"

@interface OTWLaunchManager ()

@property (nonatomic, strong) OTWLoginViewController *loginViewController;

@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, strong) UIAlertController *actionSheet;

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
- (void)showCompleteViewController:(UIViewController *_Nullable)viewController
{
    [viewController presentViewController:[[ImprovePersonInfoViewController alloc] init] animated:YES completion:nil];
}
- (void)showInViewController:(UIViewController *_Nullable)vc
{
    if (nil == vc) return;
    self.vc = vc;
    [self.vc presentViewController:self.actionSheet animated:YES completion:nil];
}
- (UIAlertController *)actionSheet
{
    if (!_actionSheet) {
        
        _actionSheet = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"完善信息会让更多的小伙伴发现你哦~快去完善你的个人资料吧~" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"稍后完善" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexPersonal];
            
            [self.vc dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"立即完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[OTWLaunchManager sharedManager] showCompleteViewController:self.vc];
            
        }];
        
        [_actionSheet addAction:action1];
        [_actionSheet addAction:action2];
        
    }
    
    return _actionSheet;
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
            
            OTWBusinessARViewController * arBusinessVC = [[OTWBusinessARViewController alloc] init];
            //POI获取的数据
//            OTWBusinessARPoiViewController * arBusinessPoiVC = [[OTWBusinessARPoiViewController alloc] init];
            UINavigationController * arNav = [[UINavigationController alloc] initWithRootViewController:arBusinessVC]; // AR
            
            OTWNewsViewController *newsVC = [[OTWNewsViewController alloc] init];
            UINavigationController * newsNav = [[UINavigationController alloc] initWithRootViewController:newsVC]; // 消息
            
            OTWPersonalViewController *personalVC = [[OTWPersonalViewController alloc] init];
            UINavigationController * personalNav = [[UINavigationController alloc] initWithRootViewController:personalVC]; // 我的
            
            config.viewControllers = @[findNav, footprintsNav, arNav, newsNav, personalNav];
            
            config.normalImages = @[@"fx_faxian", @"fx_zuji", @"fx_AR", @"fx_xiaoxi", @"fx_wode"];
            config.selectedImages = @[@"fx_faxian_click", @"fx_zuji", @"fx_AR", @"fx_xiaoxi_click", @"fx_wode_click"];
            config.titles = @[@"发现", @"足迹", @"AR", @"消息", @"我的"];
            config.selectedColor = [UIColor colorWithHexString:@"262626"];
            config.normalColor = [UIColor colorWithHexString:@"9b9b9b"];
            return config;
        }];
    }
    return _mainTabController;
}

- (OTWFootprintsViewController *) footprintVC
{
    if(!_footprintVC){
        _footprintVC = [[OTWFootprintsViewController alloc] init];
    }
    return _footprintVC;
}
- (OTWFindBusinessmenViewController *)FindBusinessmenVC
{
    if (!_FindBusinessmenVC) {
        _FindBusinessmenVC = [[OTWFindBusinessmenViewController alloc] init];
    }
    return _FindBusinessmenVC;
}


- (OTWPlaneMapViewController *) footprintPlaneMapVC
{
    if(!_footprintPlaneMapVC){
        _footprintPlaneMapVC = [[OTWPlaneMapViewController alloc] init];
    }
    return _footprintPlaneMapVC;
}
- (OTWBusinessARViewController *)BusinessARVC
{
    if (!_BusinessARVC) {
        _BusinessARVC = [[OTWBusinessARViewController alloc] init];
    }
    return _BusinessARVC;
}

@end
