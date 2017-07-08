//
//  OTWLoginService.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/8.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWLoginService.h"

static NSString *kLoginParams = @"/api/v1/login"; // 登录

@implementation OTWLoginService

+ (void)loginRquest:(NSString*)username password:(NSString*)password completion:(requestCompletionBlock)block
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         username, @"",
                         password, @"", nil];
    
    [OTWNetworkManager POST:kLoginParams parameters:dic success:^(id responseObject) {
        DLog(@"登录成功:%@", responseObject);
    } failure:^(NSError *error) {
        DLog(@"登录失败:%@", error);
    }];
    
}

@end
