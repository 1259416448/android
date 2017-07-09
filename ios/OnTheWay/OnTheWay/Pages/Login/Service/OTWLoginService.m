//
//  OTWLoginService.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/8.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWLoginService.h"
#import "HmacUtils.h"
#import "CommonContact.h"

static NSString *kLoginParams = @"/api/v1/login/sms"; // 登录
static NSString *kSentLoginCodeParams = @"/api/v1/login/sms/sent/{mobile}";

@implementation OTWLoginService

+ (void)loginRquest:(NSString*)username password:(NSString*)password completion:(requestCompletionBlock)block
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         username, @"",
                         password, @"", nil];
    
    [OTWNetworkManager doPOST:kLoginParams parameters:dic success:^(id responseObject) {
        DLog(@"登录成功:%@", responseObject);
    } failure:^(NSError *error) {
        DLog(@"登录失败:%@", error);
    }];
    
}

+ (void)sentLoginCode:(NSString *)username completion:(requestCompletionBlock)block
{
   //构建后端请求消息摘要
    NSString *digest = [HmacUtils hmac:[@"mobile:" stringByAppendingString:username]  withKey:[CommonContact getDigestKey]];
    DLog(@"digest:%@",digest);
    
    NSDictionary *params = @{@"digest":digest};
    
    [OTWNetworkManager doGET:[kSentLoginCodeParams stringByReplacingOccurrencesOfString:@"{mobile}" withString:username] parameters:params success:^(id responseObject) {
        //打印返回的数据
        DLog(@"执行结果:%@", responseObject);

    } failure:^(NSError *error) {
        
    }];
    
}

@end
