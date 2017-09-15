//
//  OTWBusinessARAnnotation.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessARAnnotation.h"

@implementation OTWBusinessARAnnotation

-(instancetype)initWithIdentifier:(NSString *)identifier businessFrame:(OTWBusinessARAnnotationFrame *)businessFrame location:(CLLocation *)location
{
    self = [super init];
    if (self) {
        self.businessFrame = businessFrame;
        self.location = location;
    }
    return self;
}

@end
