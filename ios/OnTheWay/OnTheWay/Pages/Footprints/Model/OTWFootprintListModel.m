//
//  OTWFindListModel.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintListModel.h"
#import <MJExtension.h>

@implementation OTWFootprintListModel

+ (id) initWithDict:(NSDictionary *)dict
{
    return [OTWFootprintListModel mj_objectWithKeyValues:dict];
}

#pragma mark 根据字典初始化对象
-(OTWFootprintListModel *)initWithDictionary:(NSDictionary *)dic{
    if(self=[super init]){
        self.userHeadImg=dic[@"userHeadImg"];
        self.userNickname=dic[@"userNickname"];
        self.footprintContent=dic[@"footprintContent"];
        self.footprintPhotoArray=dic[@"footprintPhotoArray"];
        self.dateCreatedStr=dic[@"dateCreatedStr"];
        self.footprintAddress=dic[@"footprintAddress"];
    }
    return self;
}

#pragma mark 初始化对象（静态方法）
+(OTWFootprintListModel *)statusWithDictionary:(NSDictionary *)dic{
    OTWFootprintListModel *status=[[OTWFootprintListModel alloc]initWithDictionary:dic];
    return status;
}
@end

