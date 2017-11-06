//
//  OTWFindBusinessmenModel.h
//  OnTheWay
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

  #import <Foundation/Foundation.h>

 @interface FindBusinessmenModel : NSObject
 @property (nonatomic, copy) NSString *BusinessmenName; // 名称
 @property (nonatomic, copy) NSString *BusinessmenNeedTime; // 所需时间
 @property (nonatomic, copy) NSNumber *BusinessmenDistance; // 距离
@property (nonatomic, copy) NSNumber *businessId; // 商家id
 @property (nonatomic, copy) NSString *BusinessmenAddress; // 地址
 @property (nonatomic, copy) NSMutableArray *coupons;//优惠券列表


-(FindBusinessmenModel *)initWithDictionary:(NSDictionary *)dic;

#pragma mark 初始化模块对象（静态方法）
+(FindBusinessmenModel *)statusWithDictionary:(NSDictionary *)dic;

 @end
