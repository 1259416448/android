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
//查询参数
@property (nonatomic,strong) NSString *q;
//搜索雷达半径
@property (nonatomic,strong) NSString *searchDistance;
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
//查询类型
@property (nonatomic,copy) NSString *typeIds;
//当前查询时间点
@property (nonatomic,strong) NSNumber *currentTime;
//是否是最后一页
@property (nonatomic,assign) BOOL isLastPage;
//是否是第一页
@property (nonatomic,assign) BOOL isFirstPage;

+ (instancetype) initWithDict:(NSDictionary *) dict;

@end
