//
//  ArvixARPresenter+Stacking.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ArvixARPresenter.h"

@interface ArvixARPresenter (Stacking)

/**
 Stacks annotationViews vertically if they are overlapping. This works by comparing frames of annotationViews.
 
 This must be called if parameters that affect relative x,y of annotations changed.
 - if azimuths on annotations are calculated(This can change relative horizontal positions of annotations)
 - when adjustVerticalOffsetParameters is called because that can affect relative vertical positions of annotations
 
 Pitch/heading of the device doesn't affect relative positions of annotationViews.
 
 解决视图碰撞，如果位置相同，会垂直展示
 
 */
- (void)resetStackParameters;

/**
 * Resets temporary stacking fields. This must be called before stacking and before layout.
 */
- (void)stackAnnotationViews;


@end
