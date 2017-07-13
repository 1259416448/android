//
//  OTWLaunchManager.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/7.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWTabBarController.h"

@interface OTWLaunchManager : NSObject

@property (nonatomic, strong) OTWTabBarController *mainTabController;

+ (instancetype)sharedManager;

- (void)showMainTabView;
- (void)showLoginView;
- (void)showPersonalEditNicknameView;
- (void)showPersonalInfoView;
- (void)showPersonalSiteView;
- (void)showPersonalMyView;
- (void)showFootprintView;

- (void)showLoginViewWithController:(UIViewController*)viewController;

@end
