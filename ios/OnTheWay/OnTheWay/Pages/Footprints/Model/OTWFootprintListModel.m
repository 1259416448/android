//
//  OTWFindListModel.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintListModel.h"
#import <MJExtension.h>

@implementation OTWFootprintListModel

+ (id) initWithDict:(NSDictionary *)dict
{
    return [OTWFootprintListModel mj_objectWithKeyValues:dict];
}

@end

