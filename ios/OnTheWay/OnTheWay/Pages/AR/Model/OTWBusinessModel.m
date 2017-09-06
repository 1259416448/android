//
//  OTWBusinessModel.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/3.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessModel.h"

@implementation OTWBusinessModel

+ (NSDictionary *) mj_setupObjectClassInArray
{
    return @{
             @"footprints":@"OTWFootprintDetailModel",
             @"activitys":@"OTWBusinessActivityModel"
             };
}

@end
