//
//  OTWSystemNewsModel.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWSystemNewsModel.h"
#import <MJExtension.h>

@implementation OTWSystemNewsModel

+ (id) initWithDict:(NSDictionary *)dict
{
    return [OTWSystemNewsModel mj_objectWithKeyValues:dict];
}
@end
