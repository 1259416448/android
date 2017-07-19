//
//  OTWPersonalFootprintsListModel.m
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalFootprintsListModel.h"
#import <MJExtension.h>

@implementation OTWPersonalFootprintsListModel

+ (instancetype) initWithDict:(NSDictionary *) dict{
    return [OTWPersonalFootprintsListModel mj_objectWithKeyValues:dict];
}

+ (NSDictionary *) objectClassInArray{
    return @{
             @"monthData" : @"OTWPersonalFootprintMonthDataModel"
             };
}

@end
