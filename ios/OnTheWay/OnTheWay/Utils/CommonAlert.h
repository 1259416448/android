//
//  CommonAlert.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface CommonAlert : NSObject<UIAlertViewDelegate>

@property (strong, nonatomic) NSString *title;

typedef void (^CallBack)(void);

#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

+(void) alertWithContent: (NSString *)content viewController: (UIViewController *)vc;

+(void) alertWithContent: (NSString *)content viewController: (UIViewController *)vc confirmStr: (NSString *)confirmStr confirmCb: (CallBack)confirmCb cancelStr: (NSString *)cancelStr cancelCb: (CallBack)cancelCb;

+(void) alertWithContent: (NSString *)content viewController: (UIViewController *)vc confirmStr: (NSString *)confirmStr confirmCb: (CallBack)confirmCb;

+(void) alertWithCancel: (NSString *)msg viewController: (UIViewController *)vc;

+(void) setTitle: (NSString *)title;


@end
