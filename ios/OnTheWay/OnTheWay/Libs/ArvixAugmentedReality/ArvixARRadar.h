//
//  ArvixARRadar.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 雷达
 */
@interface ArvixARRadar : UIView

//加载的数据最大半径 单位 m
@property (nonatomic,assign) double maxDistance;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setupAnnotations:(NSArray*)annotations;

- (void)clearDots;

- (void)moveDots:(int)angle;

#pragma mark - 暂未使用

/**
 * 初始化
 * params spots 数组,存的NSDictionary对象，dictionary中保存的 angle(int)、distance(float)
 */
- (instancetype)initWithFrame:(CGRect)frame withSpots:(NSArray<NSDictionary*>*)spots;

@end
