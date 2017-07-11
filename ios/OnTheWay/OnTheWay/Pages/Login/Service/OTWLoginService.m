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
static NSString *currentUser = @"/api/v1/login/current/user";

@implementation OTWLoginService

+ (void)loginRquest:(NSString*)username password:(NSString*)password completion:(requestCompletionBlock)block
{
    NSDictionary *dic = @{@"username":username,@"password":password,@"rememberMe":@"true"};
    [OTWNetworkManager doPOST:kLoginParams parameters:dic success:^(id responseObject) {
        //登陆成功，保存用户信息
        if(block){
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if(block){
            block(nil,error);
        }
    }];
}

+ (void)sentLoginCode:(NSString *)username completion:(requestCompletionBlock)block
{
   //构建后端请求消息摘要
    NSString *digest = [HmacUtils hmac:[@"mobile:" stringByAppendingString:username]  withKey:[CommonContact getDigestKey]];
    DLog(@"digest:%@",digest);
    NSDictionary *params = @{@"digest":digest};
    [OTWNetworkManager doGET:[kSentLoginCodeParams stringByReplacingOccurrencesOfString:@"{mobile}" withString:username] parameters:params success:^(id responseObject) {
        if(block){
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if(block){
            block(nil,error);
        }
    }];
    
}

@end
