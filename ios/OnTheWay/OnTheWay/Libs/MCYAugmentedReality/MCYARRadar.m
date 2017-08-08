//
//  MCYARRadar.m
//  MCY_AR
//
//  Created by machunyan on 2017/7/22.
//  Copyright © 2017年 machunyan. All rights reserved.
//

#import "MCYARRadar.h"
#import <CoreGraphics/CoreGraphics.h>
#import "MCYARAnnotation.h"

@interface SpotView : UIView

@end

@implementation SpotView

@end


@interface MCYARRadar ()

@property (nonatomic, strong) UIImageView *radarImageView;
@property (nonatomic, strong) NSMutableDictionary *theSpots;
@property (nonatomic, strong) NSMutableArray<SpotView*> *spots; // 雷达上的点 保存的view

@end

@implementation MCYARRadar

#pragma mark - Drawing Ovverride

/*
 * This is to draw on the places on the Radar
 *
 * It is done for each spot, in the following steps:
 *
 * 1. Get & check the heading angle (position over 360 degrees)
 *
 * 2. Get a ratio of the angle over 90 degrees
 *    (ex:72 is 0.8 of 90 and 27 is 30% of 90)
 *
 * 3. Get a ration of the distance compared to the rest
 *    (how far is it compared to the others, where 1 is the maximum
 *    distance and 0 is the minimum)
 *
 * 4. Depending on which section of the axis it is, do the math
 *    (Could be 0 < x < 90
 *              90 < x < 180
 *              180 < x < 270
 *              270 < x < 360
 *    The math involves adding a number to the minimum x or y value for
 *    that particular quadrant of the axis.
 *    That number is based on the angle ration over 90 degrees (step 2.)
 *
 * 5. Add/subtract the x/y value depending on the distance ratio (step 3.)
 *
 */

// Those are the N-E-S-W points (highs and lows) of the axis of the radar
#define Nx  49
#define Ny  10
#define Ex  85
#define Ey  48
#define Sx  49
#define Sy  85
#define Wx  10
#define Wy  48

#define Radius 40         // 雷达半径
#define pointWidth 3      // 小圆点的宽度
//#define distanceScale 100 // 两点间的实际距离缩放比例尺

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.theSpots = [NSMutableDictionary dictionary];
        self.spots = [NSMutableArray array];
        
        [self setupRadarImages];
        //[self turnRadar];
        
    }
    
    return self;
}

#pragma mark - Seting up the radar

- (void)setupRadarImages
{
    [self addSubview:self.radarImageView];
}

- (void)setupAnnotations:(NSArray *)annotations
{
    // 对annotation排序
    NSArray *sortedAnnotationViews = [annotations sortedArrayUsingComparator:^(id obj1, id obj2){
        
        MCYARAnnotation *anno1 = obj1;
        MCYARAnnotation *anno2 = obj2;
        
        if (anno1.distanceFromUser > anno2.distanceFromUser) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (anno1.distanceFromUser < anno2.distanceFromUser) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // 先移除雷达上的数据后在添加
    for (SpotView *spotview in self.spots) {
        [spotview removeFromSuperview];
    }
    [self.spots removeAllObjects];
    
    // 比较两点是否相交， 相交的话，x，y分别+1
    //CGRect rect2 = CGRectZero;
    for (MCYARAnnotation *annotation in sortedAnnotationViews) {
        // 获取x，y
        double pointX = sin(annotation.azimuth)*annotation.distanceFromUser;
        double pointY =  cos(annotation.azimuth)*annotation.distanceFromUser;
        
        double azimuth = annotation.azimuth / 180.0 * M_PI;
      //  double screenDistance = annotation.distanceFromUser / 100;
        
        double screenDistance = Radius * annotation.distanceFromUser/self.maxDistance;
        
        if (azimuth <= 90 && azimuth > 0) {
            pointX = (cos(azimuth)*screenDistance + Radius);
            pointY = (Radius - sin(azimuth)*screenDistance);
        } else if (azimuth > 90 && azimuth <= 180) {
            //azimuth -= 90;
            pointX = cos(azimuth)*screenDistance + Radius;
            pointY = Radius - sin(azimuth)*screenDistance;
        } else if (azimuth > 180 && azimuth <= 270){
            //azimuth -= 180;
            pointX = Radius + cos(azimuth)*screenDistance;
            pointY = Radius - sin(azimuth)*screenDistance;
        } else if (azimuth > 270 && azimuth <= 360) {
            //azimuth -= 270;
            pointX = Radius + cos(azimuth)*screenDistance;
            pointY = Radius - sin(azimuth)*screenDistance;
        }
        
        CGRect rect1 = CGRectMake(pointX, pointY, pointWidth, pointWidth);
        
        //暂时不考虑点重合问题
//        BOOL hasCollision =  CGRectIntersectsRect(rect1, rect2);
//        if (hasCollision) {
//            rect1 = CGRectMake(pointX + 1, pointY + 1, pointWidth, pointWidth);
//        }
//        rect2 = CGRectMake(pointX, pointY, pointWidth, pointWidth);
        
        SpotView *spotview = [[SpotView alloc] initWithFrame:rect1];
        spotview.backgroundColor = [UIColor redColor];
        spotview.layer.cornerRadius = 3;
        
        NSLog(@"实际距离：%f  屏幕宽度:%f  (实际x:%f, y:%f) 方位角 %f 雷达距离 %f 地址:", annotation.distanceFromUser, self.frame.size.width, pointX, pointY,azimuth,screenDistance);
        
        [self addSubview:spotview];
        [self.spots addObject:spotview];
    }
}

- (void)clearDots
{
    for (UIView *subview in self.subviews) {
        if (![subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark - Getter

- (UIImageView*)radarImageView
{
    if (!_radarImageView) {
        _radarImageView = [[UIImageView alloc] init];
        _radarImageView.frame = CGRectMake(0, 0, 80, 80);
        _radarImageView.image = [UIImage imageNamed:@"ar_leida"];
    }
    
    return _radarImageView;
}



#pragma mark - OO Methods

- (NSString*)description
{
    return [NSString stringWithFormat: @"ARRadar with %lu dots", (unsigned long)self.theSpots.count];
}

#pragma mark - 暂未使用

- (instancetype)initWithFrame:(CGRect)frame withSpots:(NSArray<NSDictionary *> *)spots
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.theSpots = [NSMutableDictionary dictionary];
        
        [self setupRadarImages];
        
        //[self turnRadar];
        
    }
    
    return self;
}

- (void)addPointToView
{
    int max = [[[self.theSpots allValues] valueForKeyPath:@"@max.intValue"] intValue];
    int min = [[[self.theSpots allValues] valueForKeyPath:@"@min.intValue"] intValue];
    
    int x = 0;
    int y = 0;
    
    for (NSNumber *angle in self.theSpots.allValues) {
        
        // Angle modifier //
        int angleI = angle.intValue;
        float angleModifier = fmod(angleI, 90)/90.0;
        
        // Distance modifier //
        float distModifier = 0;
        if ([[self.theSpots objectForKey:angle] intValue] != min) {
            distModifier = 1 - (([[self.theSpots objectForKey:angle] floatValue] - min) / (max - min));
        }
        
        // Positioning on axis //
        if (angleI < 90) {
            float xWidth = Ex-Nx;
            x = Nx+(xWidth*angleModifier);
            x-=(xWidth*distModifier)*((x-Nx)/xWidth);
            
            float yWidth = Ey-Ny;
            y = Ey-(yWidth*angleModifier);
            y+=(yWidth*distModifier)*((y-Ny)/yWidth);
        }
        else if (angleI < 180) {
            float xWidth = Ex-Sx;
            x = Ex-(xWidth*angleModifier);
            x+=(xWidth*distModifier)*(1-((x-Sx)/xWidth));
            
            float yWidth = Sy-Ey;
            y = Ey+(yWidth*angleModifier);
            y-=(yWidth*distModifier)*((y-Ey)/yWidth);
        }
        
        else if (angleI < 270) {
            float xWidth = Sx-Wx;
            x = Sx-(xWidth*angleModifier);
            x+=(xWidth*distModifier)*(1-((x-Wx)/xWidth));
            
            float yWidth = Sy-Wy;
            y = Wy+(yWidth*angleModifier);
            y-=(yWidth*distModifier)*(1-((y-Wy)/yWidth));
        }
        
        else {
            float xWidth = Nx-Wx;
            x = Wx+(xWidth*angleModifier);
            x-=(xWidth*distModifier)*((x-Wx)/xWidth);
            
            float yWidth = Wy-Ny;
            y = Wy-(yWidth*angleModifier);
            y+=(yWidth*distModifier)*(1-((y-Ny)/yWidth));
        }
        
        //NSLog(@"point(x:%d y:%d)", x, y);
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 4, 4)];
        tempView.backgroundColor = [UIColor redColor];
        tempView.layer.cornerRadius = 2;
        [self addSubview:tempView];
    }
}

- (void)setupSpots:(NSArray*)spots
{
    return;
    for (NSDictionary *spot in spots) {
        //NSLog(@"----spot:%@", spot);
        int angle = [[spot objectForKey:@"angle"] intValue];
        while (angle < 0) {angle += 360;}
        
        angle += 16; // +16 degrees offset for the non-symetrical positioning (tip is the center)
        angle = (int)fmod(angle, 360);
        
        int dist = [[spot objectForKey:@"distance"] intValue];
        if (dist < 0) {dist = 0;}
        
        NSNumber *distNum = [NSNumber numberWithInt:dist];
        NSNumber *angleNum = [NSNumber numberWithInt:angle];
        
        //NSLog(@"disNumber:%@  angleNum:%@", distNum, angleNum);
        if (distNum && angleNum && self.theSpots) {
            [self.theSpots setObject:[NSNumber numberWithInt:dist]
                              forKey:[NSNumber numberWithInt:angle]];
        }
    }
    
    [self addPointToView];
}

#pragma mark Moving the radar scanner

#define RADIANS( degrees )      ((degrees)*(M_PI/180))

- (void)turnRadar
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(RADIANS(360))];
    rotation.duration = 3;
    rotation.repeatCount = HUGE_VALF;
    [self.radarImageView.layer addAnimation:rotation forKey:@"Spin"];
}

- (void)moveDots:(int)angle
{
    self.transform = CGAffineTransformMakeRotation(-RADIANS(angle));
    self.radarImageView.transform = CGAffineTransformMakeRotation(RADIANS(angle));
}

@end
