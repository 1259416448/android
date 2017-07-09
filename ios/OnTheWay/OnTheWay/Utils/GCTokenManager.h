//
//  GCTokenManager.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/9.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "GCTokenModel.h"

@interface GCTokenManager : NSObject

+(void)saveToken:(GCTokenModel *)token;

+(GCTokenModel *)getToken;

+(void)cleanToken;

+(GCTokenModel *)refreshToken:(GCTokenModel *)token;

@end
