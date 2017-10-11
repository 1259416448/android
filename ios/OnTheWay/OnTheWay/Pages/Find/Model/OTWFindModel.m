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
        self.typeId = dic[@"typeId"];
        self.FindTpyeBackgroundImageUrl=dic[@"iconStr"];
        self.FindTpyeName=dic[@"name"];
        self.FindTpyeContentList=dic[@"children"];
    }
    return self;
}

#pragma mark 初始化对象（静态方法）
+(OTWFindStatus *)statusWithDictionary:(NSDictionary *)dic{
    OTWFindStatus *status=[[OTWFindStatus alloc]initWithDictionary:dic];
    return status;
}
@end
