//
//  OTWPersonalClaimModel.h
//  OnTheWay
//
//  Created by UI002 on 2017/8/16.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWPersonalClaimModel.h"

@interface OTWPersonalClaimModel : NSObject
@property (nonatomic,copy) NSString *claimShopOtherInfoIcon;//图标
@property (nonatomic,copy) NSString *claimShopOtherInfoName;//名称

#pragma mark 根据字典初始化模块对象
-(OTWPersonalClaimModel *)initWithDictionary:(NSDictionary *)dic;

#pragma mark 初始化模块对象（静态方法）
+(OTWPersonalClaimModel *)statusWithDictionary:(NSDictionary *)dic;
@end
