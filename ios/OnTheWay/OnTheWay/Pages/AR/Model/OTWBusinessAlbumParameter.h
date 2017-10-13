//
//  OTWBusinessAlbumParameter.h
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/10/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWBusinessAlbumParameter : NSObject

//当前页数
@property (nonatomic,assign) int number;
//每页大小
@property (nonatomic,assign)  int size;
//当前查询时间点
@property (nonatomic,strong) NSNumber *currentTime;
//商家id
@property (nonatomic,strong) NSNumber * shopId;

@end
