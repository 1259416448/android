//
//  OTWNewsSearchParams.h
//  OnTheWay
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWNewsSearchParams : NSObject

//当前页数
@property (nonatomic,assign) int number;
//每页大小
@property (nonatomic,assign)  int size;
//是否清空提醒数据
@property (nonatomic,assign) BOOL clear;
//是否是最后一页
@property (nonatomic,assign) BOOL isLastPage;
//是否是第一页
@property (nonatomic,assign) BOOL isFirstPage;
//当前查询时间点
@property (nonatomic,strong) NSNumber *currentTime;

+ (instancetype) initWithDict:(NSDictionary *) dict;


@end
