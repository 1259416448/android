//
//  OTWARCustomAnnotation.m
//  OnTheWay
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWARCustomAnnotation.h"

@implementation OTWARCustomAnnotation

-(instancetype)initWithIdentifier:(NSString *)identifier footprint:(OTWFootprintListModel *)footprint location:(CLLocation*)location
{
    self = [super init];
    if (self) {
        self.footprint = footprint;
        self.location = location;
    }

    return self;
}

@end
