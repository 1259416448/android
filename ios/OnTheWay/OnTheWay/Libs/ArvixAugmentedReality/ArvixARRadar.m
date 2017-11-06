//
//  ArvixARRadar.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ArvixARRadar.h"
#import <CoreGraphics/CoreGraphics.h>
#import "ArvixARAnnotation.h"
#import "ArvixARConfiguration.h"

@interface ArvixSpotView : UIView

@end

@implementation ArvixSpotView

@end

@interface ArvixARRadar ()

@property (nonatomic, strong) UIImageView *radarImageView;
@property (nonatomic, strong) NSMutableDictionary *theSpots;
@property (nonatomic, strong) NSMutableArray<ArvixSpotView*> *spots; // 雷达上的点 保存的view

@end

@implementation ArvixARRadar

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

#define Radius self.bounds.size.width/2         // 雷达半径
#define pointWidth 2                            // 小圆点的宽度

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
    // note1 计算出的pointX和pointY是对应的屏幕坐标系。 即X轴向右伸展，Y轴向下伸展
    // note2 所有的点都必须包含在雷达圆内， 则需要计算出point点到中心原点(40,40)的距离. screenDistanceFromOrigin = distanceFromUser*Radius/maxDistance
    // note3 如果point点到原点的距离大于半径(即超出maxDistance)，则不予显示。
    // note4 根据三角函数计算出每个点对应的pointX和pointY sin(a)=对边/斜边 注意: 在iOS系统中，a代表的是弧度，不是角度。  因此需要先把角度转换为弧度。
    
    // 对annotation排序
    NSArray *sortedAnnotationViews = [annotations sortedArrayUsingComparator:^(id obj1, id obj2){
        
        ArvixARAnnotation *anno1 = obj1;
        ArvixARAnnotation *anno2 = obj2;
        
        if (anno1.distanceFromUser > anno2.distanceFromUser) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (anno1.distanceFromUser < anno2.distanceFromUser) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // 先移除雷达上的数据后在添加
    for (ArvixSpotView *spotview in self.spots) {
        [spotview removeFromSuperview];
    }
    [self.spots removeAllObjects];
    
    // 比较两点是否相交， 相交的话，x，y分别+1
    CGRect rect2 = CGRectZero;
    
    for (ArvixARAnnotation *annotation in sortedAnnotationViews) {
        
        double pointDistance = Radius * annotation.distanceFromUser/self.maxDistance;
        
        // 计算 x, y的坐标。 sin(a) a在iOS中代表的是弧度， 不是角度。
        double pointX = sin(degreesToRadians(annotation.azimuth))*pointDistance + Radius;
        double pointY = Radius - cos(degreesToRadians(annotation.azimuth))*pointDistance;
        
        /*
         1. 如下代码等同以上两行代码。 可以通过以下代码获取思路。
         2. sin(a) = 对边 / 斜边   cos(a) = 邻边 / 斜边  a代表的弧度(这点很重要)
         3. 以中心原点划分x和y坐标。 得到四个区域。  角度的取值范围是0-90. 超过90度的区域，需要减去对应的角度(90/180/270)。
         
         double azimuth = annotation.azimuth;
         if (azimuth > 0 && azimuth <= 90) {
         
         pointX = sin(degreesToRadians(azimuth))*pointDistance + Radius;
         pointY = Radius - cos(degreesToRadians(azimuth))*pointDistance;
         } else if (azimuth > 90 && azimuth <= 180) {
         
         pointX = cos(degreesToRadians(azimuth-90))*pointDistance + Radius;
         pointY = sin(degreesToRadians(azimuth-90))*pointDistance + Radius;
         } else if (azimuth > 180 && azimuth <= 270){
         
         pointX = Radius - sin(degreesToRadians(azimuth-180))*pointDistance;
         pointY = Radius + cos(degreesToRadians(azimuth-180))*pointDistance;
         } else if (azimuth > 270 && azimuth <= 360) {
         
         pointX = Radius - cos(degreesToRadians(azimuth-270))*pointDistance;
         pointY = Radius - sin(degreesToRadians(azimuth-270))*pointDistance;
         }*/
        
        CGRect rect1 = CGRectMake(pointX, pointY, pointWidth, pointWidth);
        
        BOOL hasCollision =  CGRectIntersectsRect(rect1, rect2);
        if (hasCollision) {
            rect1 = CGRectMake(pointX + 1, pointY + 1, pointWidth, pointWidth);
        }
        rect2 = rect1;

        ArvixSpotView *spotview = [[ArvixSpotView alloc] initWithFrame:rect1];
        if (annotation.colorCode && ![annotation.colorCode isEqualToString:@""]) {
            spotview.backgroundColor = [UIColor colorWithHexString:annotation.colorCode];
        } else {
            spotview.backgroundColor = [UIColor redColor];
        }
        spotview.layer.cornerRadius = pointWidth/2;
        if (pointDistance > 40) {
            spotview.hidden = YES;
        }else{
            [self addSubview:spotview];
            [self.spots addObject:spotview];
        }

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
