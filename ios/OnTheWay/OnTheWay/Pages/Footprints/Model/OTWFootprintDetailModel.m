//
//  OTWFootprintDetailModel.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintDetailModel.h"
#import <MJExtension.h>

@implementation OTWFootprintDetailModel

+ (id) initWithDict:(NSDictionary *)dict
{
    return [OTWFootprintDetailModel mj_objectWithKeyValues:dict];
}

+ (NSDictionary *) objectClassInArray{
    return @{
             @"comments" : @"OTWCommentModel"
           };
}

@end
