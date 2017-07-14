//
//  OTWFindBusinessmenModel.m
//  OnTheWay
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFindBusinessmenModel.h"

@implementation FindBusinessmenModel

#pragma mark 根据字典初始化对象
-(FindBusinessmenModel *)initWithDictionary:(NSDictionary *)dic{
    if(self=[super init]){
        self.BusinessmenName=dic[@"BusinessmenName"] ;
        self.BusinessmenNeedTime=dic[@"BusinessmenNeedTime"];
        self.BusinessmenDistance=dic[@"BusinessmenDistance"];
        self.BusinessmenAddress=dic[@"BusinessmenAddress"];
        self.coupons=dic[@"coupons"];
    }
    return self;
}

#pragma mark 初始化对象（静态方法）
+(FindBusinessmenModel *)statusWithDictionary:(NSDictionary *)dic{
    FindBusinessmenModel *status=[[FindBusinessmenModel alloc]initWithDictionary:dic];
    return status;
}

@end
