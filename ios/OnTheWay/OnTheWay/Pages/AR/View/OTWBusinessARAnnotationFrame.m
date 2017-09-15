//
//  OTWBusinessARAnnotationFrame.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/15.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessARAnnotationFrame.h"

#define businessNameFont [UIFont fontWithName:@"PingFangSC-Regular" size:14]

@implementation OTWBusinessARAnnotationFrame

+ (instancetype) initWithBusinessDetail:(OTWBusinessModel *)businessDetail
{
    return [[self alloc] initWithBusinessDetail:businessDetail];
}

- (id) initWithBusinessDetail:(OTWBusinessModel *)businessDetail
{
    self = [super init];
    if(self){
        self.businessDetail = businessDetail;
        [self buildFrame];
    }
    return self;
}

/**
 * 异步计算出必要的Frame信息
 */
- (void) buildFrame
{
    CGFloat titleMaxW = SCREEN_WIDTH * 0.6;
    
    CGSize titleSize = [OTWUtils sizeWithString:self.businessDetail.name font:businessNameFont maxSize:CGSizeMake(titleMaxW, 15)];
    
    self.contentW = titleSize.width;
    
    self.annotationW = self.contentW + 10 * 2 + 58;
   
    self.colorAlpha = 0.85;
    
    self.distanceAlpha = 1;
}

@end
