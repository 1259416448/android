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
#import "OTWFootprintsViewController.h"
#import "OTWPlaneMapViewController.h"
#import "OTWFindBusinessmenController.h"
#import "OTWBusinessARViewController.h"


typedef enum : NSUInteger {
    OTWTabBarSelectedIndexFind = 0,   // 发现
    OTWTabBarSelectedIndexFootprints, // 足迹
    OTWTabBarSelectedIndexAR,         // AR
    OTWTabBarSelectedIndexNews,       // 消息
    OTWTabBarSelectedIndexPersonal,   // 我的
    OTWTabBarSelectedIndexFootprintList, //足迹列表
} OTWTabBarSelectedIndex;

@interface OTWLaunchManager : NSObject

@property (nonatomic, strong) OTWTabBarController * _Nullable mainTabController;
@property (nonatomic,strong) OTWFootprintsViewController * _Nullable footprintVC;
@property (nonatomic,strong) OTWPlaneMapViewController * _Nullable footprintPlaneMapVC;
@property (nonatomic,strong) OTWFindBusinessmenViewController * _Nullable FindBusinessmenVC;
@property (nonatomic,strong) OTWBusinessARViewController * _Nullable BusinessARVC;


+ (instancetype _Nullable )sharedManager;

- (void)showMainTabView;

- (BOOL)showLoginViewWithController:(UIViewController*_Nullable)viewController completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);
- (void)showCompleteViewController:(UIViewController *_Nullable)viewController;
/**
 * 展示TabBar选中的视图 和tab的didSelectedItemByIndex等效
 * @param selectIndex 选中的Index
 */
- (void)showSelectedControllerByIndex:(OTWTabBarSelectedIndex)selectIndex;

- (void)showInViewController:(UIViewController *_Nullable)vc;


@end
