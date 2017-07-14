//
//  OTWCommentModel.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWCommentModel.h"
#import <MJExtension.h>

@implementation OTWCommentModel

+ (id) initWithDict:(NSDictionary *)dict
{
    return [OTWCommentModel mj_objectWithKeyValues:dict];
}

@end
