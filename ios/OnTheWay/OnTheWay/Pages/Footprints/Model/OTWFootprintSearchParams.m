//
//  OTWFootprintSearchParams.m
//  OnTheWay
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintSearchParams.h"
#import <MJExtension.h>

@implementation OTWFootprintSearchParams

+ (instancetype) initWithDict:(NSDictionary *)dict
{
    return [OTWFootprintSearchParams mj_objectWithKeyValues:dict];
}

@end
