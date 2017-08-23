//
//  ArvixARAnnotationView.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ArvixARAnnotationView.h"

@implementation ArvixARAnnotationView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initializeInternal];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeInternal];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeInternal];
    }
    
    return self;
}

- (void)initializeInternal
{
    if (self.initialized) return;
    
    self.initialized = true;
    [self initialize];
}

// Will always be called once, no need to call super
- (void)initialize
{
    _centerOffset = CGPointMake(0.5, 0.5);
    
    _arStackOffset = CGPointMake(0, 0);
    _arStackAlternateFrame = CGRectZero;
    _arStackAlternateFrameExists = false;
    _arZeroPoint = CGPointMake(0, 0);
    _initialized = false;
    
}

// Called when distance/azimuth changes, intended to be used in subclasses
- (void)bindUi
{
    
}

/**
 * 加载UI时调用，一般提供子类访问
 */
- (void)drawRect:(CGRect)rect
{
    [self bindUi];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self bindUi];
}

@end
