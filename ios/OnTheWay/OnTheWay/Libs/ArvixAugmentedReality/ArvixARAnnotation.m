//
//  ArvixARAnnotation.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ArvixARAnnotation.h"

@interface ArvixARAnnotation ()
{
    ArvixARAnnotationView *_annotationView;
}
@end

@implementation ArvixARAnnotation

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Init
        _distanceFromUser = 0;
        _azimuth = 0;
        _active = false;
    }
    return self;
}

/**
 *  Returns annotation if location(coordinate) is valid.
 */
- (instancetype)initWithIdentifier:(NSString*)identifier title:(NSString*)title location:(CLLocation*)location
{
    if (CLLocationCoordinate2DIsValid(location.coordinate)) {
        self.identifier = identifier;
        self.title = title;
        self.location = location;
    }
    return [self init];
}

/**
 *  Validates location.coordinate and sets it.
 */
- (BOOL)validateAndSetLocation:(CLLocation*)location
{
    if (!CLLocationCoordinate2DIsValid(location.coordinate)) return false;
    
    self.location = location;
    return true;
}

@end
