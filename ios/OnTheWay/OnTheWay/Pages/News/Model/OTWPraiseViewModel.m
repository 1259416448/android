//
//  OTWPraiseViewModel.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPraiseViewModel.h"
#import "MJExtension.h"

@implementation OTWPraiseViewModel

+ (id) statusWithDictionary:(NSDictionary *)dict
{
    return [OTWPraiseViewModel mj_objectWithKeyValues:dict];
}

@end
