//
//  OTWNewsModel.m
//  OnTheWay
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewsModel.h"
#import <MJExtension.h>

@implementation OTWNewsModel

+ (id) initWithDict:(NSDictionary *)dict
{
    return [OTWNewsModel mj_objectWithKeyValues:dict];
}

@end
