//
//  OTWBusinessARAnnotation.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ArvixARAnnotation.h"
#import "OTWBusinessARAnnotationFrame.h"

@interface OTWBusinessARAnnotation : ArvixARAnnotation

@property (nonatomic,strong) OTWBusinessARAnnotationFrame *businessFrame;

- (instancetype)initWithIdentifier:(NSString*)identifier businessFrame:(OTWBusinessARAnnotationFrame*)businessFrame location:(CLLocation*)location;

@end
