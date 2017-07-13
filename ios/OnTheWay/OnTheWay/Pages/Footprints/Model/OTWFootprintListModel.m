//
//  OTWFindListModel.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintListModel.h"

@implementation OTWFootprintListModel

- (id) initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (id) footprintWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end

