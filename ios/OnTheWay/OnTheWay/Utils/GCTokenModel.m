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

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super self];
    if(self){
        self.xAuthToken = [coder decodeObjectForKey:@"xAuthToken"];
        self.rememberMe = [coder decodeObjectForKey:@"rememberMe"];
        self.rememberMeTime = [coder decodeObjectForKey:@"rememberMeTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:_xAuthToken forKey:@"xAuthToken"];
    [coder encodeObject:_rememberMe forKey:@"rememberMe"];
    [coder encodeObject:_rememberMeTime forKey:@"rememberMeTime"];
}


@end
