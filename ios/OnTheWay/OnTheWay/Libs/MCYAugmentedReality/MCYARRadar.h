//
//  MCYARRadar.h
//  MCY_AR
//
//  Created by machunyan on 2017/7/22.
//  Copyright © 2017年 machunyan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 雷达
 */
@interface MCYARRadar : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setupAnnotations:(NSArray*)annotations;

- (void)clearDots;

#pragma mark - 暂未使用

/**
 * 初始化
 * params spots 数组,存的NSDictionary对象，dictionary中保存的 angle(int)、distance(float)
 */
- (instancetype)initWithFrame:(CGRect)frame withSpots:(NSArray<NSDictionary*>*)spots;

- (void)moveDots:(int)angle;

- (void)setupSpots:(NSArray*)spots;

@end
