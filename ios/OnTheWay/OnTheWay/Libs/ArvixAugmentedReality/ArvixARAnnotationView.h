//
//  ArvixARAnnotationView.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArvixARAnnotation.h"

@class ArvixARAnnotation;

/**
 * Responsible for presenting annotations visually. Analogue to ArvixARAnnotationView.
 * It is usually subclassed to provide custom look.
 
 * Annotation views should be lightweight, try to avoid xibs and autolayout.
 * 
 * 负责在View中展示，自定义视图请 extend ArvixARAnnotationView ，Annotation views 应该使用轻量级的，避免使用xibs 和 autolayout
 */
@interface ArvixARAnnotationView : UIView
/**
 * Normally, center of annotationView points to real location of POI, but this property can be used to alter that.
 * E.g. if bottom-left edge of annotationView should point to real location, centerOffset should be (0, 1)
 
 * 通常情况，annotationView的中心点指向POI的真实位置，这个属性可用于改变指向的中心点
 * E.g. 例如annotationView的左下角指向实际位置，centerOffset = (0,1)
 */
@property (nonatomic, assign) CGPoint centerOffset;

@property (nonatomic, strong) ArvixARAnnotation *annotaion;

/**
 * Used internally for stacking
 * 内部用于stacking布局
 */
@property (nonatomic, assign) CGPoint arStackOffset;
@property (nonatomic, assign) CGRect arStackAlternateFrame;
@property (nonatomic, assign) BOOL arStackAlternateFrameExists;
//Position of annotation view without heading, pitch, stack offsets.
@property (nonatomic, assign) CGPoint arZeroPoint;

@property (nonatomic, assign) BOOL initialized;

- (void)bindUi;
- (void)initialize;

@end
