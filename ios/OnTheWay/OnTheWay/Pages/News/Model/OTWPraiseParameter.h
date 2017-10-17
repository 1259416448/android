//
//  OTWPraiseParameter.h
//  OnTheWay
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWPraiseParameter : NSObject

//当前页数
@property (nonatomic,assign) int number;
//每页大小
@property (nonatomic,assign)  int size;
//当前查询时间点
@property (nonatomic,strong) NSNumber *currentTime;
//清除
@property (nonatomic,assign)  BOOL clear;


@end
