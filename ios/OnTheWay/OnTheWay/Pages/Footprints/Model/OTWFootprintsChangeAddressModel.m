//
//  OTWFootprintsChangeAddressModel.m
//  OnTheWay
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintsChangeAddressModel.h"
#import <MJExtension.h>

@implementation OTWFootprintsChangeAddressModel

+ (instancetype) initWithDict:(NSDictionary *) dict{
    return [OTWFootprintsChangeAddressModel mj_objectWithKeyValues:dict];
}

+ (NSDictionary *) objectClassInArray{
    return @{
             @"addressArray" : @"OTWFootprintChangeAddressArrayModel"
             };
}

@end
