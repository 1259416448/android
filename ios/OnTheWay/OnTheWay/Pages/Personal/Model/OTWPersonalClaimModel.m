//
//  OTWPersonalClaimModel.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/16.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalClaimModel.h"
#import <MJExtension.h>


@implementation OTWPersonalClaimModel

#pragma mark 根据字典初始化对象
-(OTWPersonalClaimModel *)initWithDictionary:(NSDictionary *)dic{
    if(self=[super init]){
        self.claimShopOtherInfoIcon=dic[@"claimShopOtherInfoIcon"] ;
        self.claimShopOtherInfoName=dic[@"claimShopOtherInfoName"];
    }
    return self;
}

#pragma mark 初始化对象（静态方法）
+(OTWPersonalClaimModel *)statusWithDictionary:(NSDictionary *)dic{
    OTWPersonalClaimModel *status=[[OTWPersonalClaimModel alloc]initWithDictionary:dic];
    return status;
}

@end
