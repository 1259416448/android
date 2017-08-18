//
//  OTWNewsSearchParams.m
//  OnTheWay
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewsSearchParams.h"
#import <MJExtension.h>

@implementation OTWNewsSearchParams

+ (id) initWithDict:(NSDictionary *)dict
{
    return [OTWNewsSearchParams mj_objectWithKeyValues:dict];
}

@end
