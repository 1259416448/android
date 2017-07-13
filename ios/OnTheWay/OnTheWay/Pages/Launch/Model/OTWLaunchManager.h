//
//  OTWLaunchManager.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/7.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWLaunchManager : NSObject

+ (instancetype)sharedManager;

- (void)showMainTabView;
- (void)showLoginView;
- (void)showPersonalEditNicknameView;
- (void)showPersonalInfoView;
- (void)showPersonalSiteView;
- (void)showPersonalMyView;

- (void)showLoginViewWithController:(UIViewController*)viewController;

@end
