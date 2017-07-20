//
//  OTWCommentModel.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewsCommentModel.h"
#import "MJExtension.h"

@implementation OTWNewsCommentModel

+ (id) commentModelWithDictionary:(NSDictionary *)dict
{
    return [OTWNewsCommentModel mj_objectWithKeyValues:dict];
}

@end
