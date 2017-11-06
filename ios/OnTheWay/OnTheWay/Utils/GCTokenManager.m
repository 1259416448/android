//
//  GCTokenManager.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/9.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "GCTokenManager.h"

NSString *const TOKEN_KEY = @"x-auth-token";

@implementation GCTokenManager

// 存储token
+(void)saveToken:(GCTokenModel *)token
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSData *tokenData = [NSKeyedArchiver archivedDataWithRootObject:token];
    [userDefaults setObject:tokenData forKey:TOKEN_KEY];
    [userDefaults synchronize];
}

// 读取token
+(GCTokenModel *)getToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *tokenData = [userDefaults objectForKey:TOKEN_KEY];
    GCTokenModel *token = [NSKeyedUnarchiver unarchiveObjectWithData:tokenData];
    //[userDefaults synchronize];
    return token;
}

// 清空token
+(void)cleanToken
{
    NSUserDefaults *UserLoginState = [NSUserDefaults standardUserDefaults];
    [UserLoginState removeObjectForKey:TOKEN_KEY];
    [UserLoginState synchronize];
}


// 更新token
+(GCTokenModel *)refreshToken:(GCTokenModel *)token
{
    
    [self cleanToken];
    [self saveToken:token];
    return token;
}

@end
