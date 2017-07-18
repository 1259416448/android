//
//  OTWLaunchManager.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/7.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWTabBarController.h"
#import "OTWFootprintDetailController.h"

@interface OTWLaunchManager : NSObject

@property (nonatomic, strong) OTWTabBarController * _Nullable mainTabController;

+ (instancetype _Nullable )sharedManager;

- (void)showMainTabView;
- (void)showLoginView;
- (void)showPersonalEditNicknameView;
- (void)showPersonalInfoView;
- (void)showPersonalSiteView;
- (void)showPersonalMyView;
- (void)showFootprintView;
- (void)deallocLoginViewController;

- (BOOL)showLoginViewWithController:(UIViewController*_Nullable)viewController completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);
- (OTWFootprintDetailController *_Nullable) footprintDetailController:(BOOL) newFootprint;

@end
