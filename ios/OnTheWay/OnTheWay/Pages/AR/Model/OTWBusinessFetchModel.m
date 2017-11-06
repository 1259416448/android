//
//  OTWBusinessFetchModel.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessFetchModel.h"
#import <MJExtension.h>

@implementation OTWBusinessFetchModel

+ (id) initWithDict:(NSDictionary *)dict
{
    return [OTWFootprintListModel mj_objectWithKeyValues:dict];
}

@end
