//
//  GCTokenModel.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/9.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCTokenModel.h"

@implementation GCTokenModel

- (instancetype) initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
