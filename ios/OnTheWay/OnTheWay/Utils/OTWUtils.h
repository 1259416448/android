//
//  OTWUtils.h
//  OnTheWay
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWUtils : NSObject

#pragma mark 判断系统版本是否大于等于某个值
+ (BOOL)system_version_greater_than_or_equal_to:(float)version;
#pragma mark 判断系统版本是否在某两个值之间
+ (BOOL)system_version_gerater_between:(float)version1 and:(float)version2;
#pragma mark 判断系统版本是否小于某个值
+ (BOOL)system_version_greater_less_than:(float)version;


@end
