//
//  OTWBusinessSortModel.m
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/9/22.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessSortModel.h"

@implementation OTWBusinessSortModel

+ (NSDictionary *) objectClassInArray
{
    return @{
             @"children":@"OTWBusinessDetailSortModel"
             };
}

@end
