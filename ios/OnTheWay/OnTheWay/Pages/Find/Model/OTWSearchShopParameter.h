//
//  OTWSearchShopParameter.h
//  OnTheWay
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWSearchShopParameter : NSObject

//查询参数
@property (nonatomic,strong) NSString *q;
//当前页数
@property (nonatomic,assign) int number;
//每页大小
@property (nonatomic,assign)  int size;
//纬度
@property (nonatomic,assign) double latitude;
//经度
@property (nonatomic,assign) double longitude;
//当前查询时间点
@property (nonatomic,strong) NSNumber *currentTime;

@end
