//
//  ArvixARAnnotation.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ArvixARAnnotationView.h"

@class ArvixARAnnotationView;

@interface ArvixARAnnotation : NSObject

/**
 * Identifier of annotation, not used by HDAugmentedReality internally.
 */
@property (nonatomic, strong) NSString *identifier;

/**
 * Title of annotation, can be used in ARAnnotationView
 */
@property (nonatomic, strong) NSString *title;

/**
 * Location of the annotation, it is guaranteed to be valid location(coordinate). It is set in init or by validateAndSetLocation.
 */
@property (nonatomic, strong) CLLocation *location;

//@property (nonatomic, strong) OTWFootprintListModel *footprint;

/**
 * View for annotation. It is set inside ARPresenter after fetching view from dataSource.
 */
@property (nonatomic, strong) ArvixARAnnotationView *annotationView;

/**
 * Internal use only, do not set this properties
 */

//用户定位地址与poi的距离
@property (nonatomic) double distanceFromUser;
//雷达标点颜色值
@property (nonatomic,strong) NSString *colorCode;
//方向角
@property (nonatomic) double azimuth;
@property (nonatomic) BOOL active;

/**
 *  Returns annotation if location(coordinate) is valid.
 */
- (instancetype)initWithIdentifier:(NSString*)identifier title:(NSString*)title location:(CLLocation*)location;

/**
 *  Validates location.coordinate and sets it.
 */
- (BOOL)validateAndSetLocation:(CLLocation*)location;


@end
