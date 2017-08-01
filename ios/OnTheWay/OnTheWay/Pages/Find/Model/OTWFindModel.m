//
//  OTWFindModel.m
//  OnTheWay
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import "OTWFindModel.h"

@implementation OTWFindStatus

#pragma mark 根据字典初始化对象
-(OTWFindStatus *)initWithDictionary:(NSDictionary *)dic{
    if(self=[super init]){
        self.Id=[dic[@"Id"] longLongValue];
        self.FindTpyeBackgroundImageUrl=dic[@"FindTpyeBackgroundImageUrl"];
        self.FindTpyeName=dic[@"FindTpyeName"];
        self.FindTpyeContentList=dic[@"FindTpyeContentList"];
    }
    return self;
}

#pragma mark 初始化对象（静态方法）
+(OTWFindStatus *)statusWithDictionary:(NSDictionary *)dic{
    OTWFindStatus *status=[[OTWFindStatus alloc]initWithDictionary:dic];
    return status;
}
@end
