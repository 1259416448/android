//
//  HmacUtils.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/8.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

@interface HmacUtils : NSObject

+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key;

@end
