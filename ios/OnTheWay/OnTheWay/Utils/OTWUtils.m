//
//  OTWUtils.m
//  OnTheWay
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWUtils.h"

@implementation OTWUtils

#pragma mark 判断系统版本是否大于某个版本
+(BOOL)system_version_greater_than_or_equal_to:(float)version
{
    float currentVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (currentVersion < version) {
        return NO;
    }
    return YES;
}

#pragma mark 判断系统版本是否在某两个值之间
+(BOOL)system_version_gerater_between:(float)version1 and:(float)version2
{
    float currentVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (currentVersion >= version1  && currentVersion < version2) {
        return YES;
    }
    return NO;
}

#pragma mark 判断系统版本是否小于某个值
+(BOOL)system_version_greater_less_than:(float)version
{
    float currentVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (currentVersion < version) {
        return YES;
    }
    return NO;
}

@end
