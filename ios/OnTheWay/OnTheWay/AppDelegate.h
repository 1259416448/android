//
//  AppDelegate.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/5.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <IQKeyboardManager.h>
#import <UMessage.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BMKMapManager *_mapManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *userInfo;


@end

