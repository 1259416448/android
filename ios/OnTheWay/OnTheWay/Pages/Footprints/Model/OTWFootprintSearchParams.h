//
//  OTWFootprintSearchParams.h
//  OnTheWay
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWFootprintSearchParams : NSObject

//查询类型
@property (nonatomic,strong) NSString *type;
//当前页数
@property (nonatomic,assign) int number;
//每页大小
@property (nonatomic,assign)  int size;
//纬度
@property (nonatomic,assign) double latitude;
//经度
@property (nonatomic,assign) double longitude;
//范围
@property (nonatomic,copy) NSString *distance;
//时间
@property (nonatomic,copy) NSString *time;

@property (nonatomic,strong) NSNumber *currentTime;

+ (instancetype) initWithDict:(NSDictionary *) dict;

@end
