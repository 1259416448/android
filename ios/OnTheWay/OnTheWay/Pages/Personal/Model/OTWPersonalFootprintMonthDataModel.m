//
//  OTWPersonalFootprintMonthDataModel.m
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalFootprintMonthDataModel.h"
#import <MJExtension.h>

@implementation OTWPersonalFootprintMonthDataModel

+ (instancetype) initWithDict:(NSDictionary *) dict
{
    return [OTWPersonalFootprintMonthDataModel mj_objectWithKeyValues:dict];
}

+ (NSDictionary *) objectClassInArray{
    return @{
             @"dayData" : @"OTWFootprintListModel"
             };
}

@end
