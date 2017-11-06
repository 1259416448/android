//
//  OTWLoginService.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/8.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestCompletionBlock)(id result, NSError *error);

@interface OTWLoginService : NSObject

//登陆
#pragma mark login
+ (void)loginRquest:(NSString*)username password:(NSString*)password completion:(requestCompletionBlock)block;

//发送短信验证码
#pragma mark sent message code
+ (void)sentLoginCode:(NSString*)username completion:(requestCompletionBlock)block;

@end
