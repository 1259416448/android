//
//  ArvixARConfiguration.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ArvixARViewController.h"
#import "ArvixARAnnotation.h"
#import "ArvixARAnnotationView.h"
#import <CoreLocation/CoreLocation.h>

@class ArvixARViewController;
@class Platform;
@class ArvixARRadar;

#define LAT_LON_FACTOR 1.33975031663  // Used in azimuzh calculation, don't change
#define MAX_VISIBLE_ANNOTATIONS 500   // Do not change, can affect performance

#define max(x,y) (x > y ? x : y)
#define min(x,y) (x < y ? x : y)

#define HORIZ_SENS   14 // Counterpart of the VERTICAL_SENS --> How fast they move left & right with the accelerometer data

@interface ArvixARConfiguration : NSObject

double radiansToDegrees(double radians);

double degreesToRadians(double degrees);

double normalizeDegree(double degree);

double deltaAngle(double angle1, double angle2);

@end

@protocol ArvixARDataSource <NSObject>

- (ArvixARAnnotationView*)ar:(ArvixARViewController*)arViewController viewForAnnotation:(ArvixARAnnotation*)annotation;

@optional

- (NSArray<ArvixARAnnotation*>*)ar:(ArvixARViewController*)arViewController shouldReloadWithLocation:(CLLocation*)location;
- (ArvixARRadar*)ar:(ArvixARRadar*)arRadar viewForRadar:(ArvixARRadar*)radar;

@end

@interface ArvixARStatus: NSObject

/// Horizontal field of view od device. Changes when device rotates(hFov becomes vFov).
@property (nonatomic, assign) double hFov;
/// Vertical field of view od device. Changes when device rotates(vFov becomes hFov).
@property (nonatomic, assign) double vFov;
/// How much pixels(logical) on screen is 1 degree, horizontally.
@property (nonatomic, assign) double hPixelsPerDegree;
/// How much pixels(logical) on screen is 1 degree, vertically.
@property (nonatomic, assign) double vPixelsPerDegree;
/// Heading of the device, 0-360.
@property (nonatomic, assign) double heading;
/// Pitch of the device, device pointing straight = 0, up(upper edge tilted toward user) = 90, down = -90.
@property (nonatomic, assign) double pitch;
/// Last known location of the user.
@property (nonatomic, assign) CLLocation *userLocation;

/// True if all properties have been set.
@property (nonatomic, assign) BOOL ready;

@end

@interface Platform : NSObject

+ (BOOL)isSimulator;

@end
