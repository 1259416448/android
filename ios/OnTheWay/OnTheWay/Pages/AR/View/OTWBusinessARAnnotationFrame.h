//
//  OTWBusinessARAnnotationFrame.h
//  OnTheWay
//  提前计算出当前annotation的宽度，防止闪屏问题
//  Created by 周扬扬 on 2017/9/15.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWBusinessModel.h"

@interface OTWBusinessARAnnotationFrame : NSObject

//后台返回的商家详情
@property (nonatomic,strong) OTWBusinessModel *businessDetail;

//内容宽
@property (nonatomic,assign) CGFloat contentW;

//总宽
@property (nonatomic,assign) CGFloat annotationW;

//距离显示宽
@property (nonatomic,assign) CGFloat distanceW;

//地址背景透明度 默认 1
@property (nonatomic,assign) CGFloat distanceAlpha;

//内容显示透明度 默认 0.85
@property (nonatomic,assign) CGFloat colorAlpha;

+ (instancetype) initWithBusinessDetail:(OTWBusinessModel *)businessDetail;

@end
