//
//  ArvixARPresenter.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ArvixARPresenter.h"
#import "ArvixARPresenter+Stacking.h"
#import "ArvixARRadar.h"

@implementation ArvixARPresenter

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithARViewController:(ArvixARViewController*)arViewController
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.arViewController = arViewController;
        [self initializeInternal];
    }
    
    return self;
}

- (void)initializeInternal
{
    _verticalStackingEnabled = false;
    _distanceOffsetMinThreshold = 0;
    _distanceOffsetMode = DistanceOffsetModeAutomatic;
    _bottomBorder = 0.7;
    _maxVisibleAnnotations = 100;
    _maxDistance = 0;
}

- (NSInteger)maxVisibleAnnotations
{
    if (_maxVisibleAnnotations > MAX_VISIBLE_ANNOTATIONS) {
        _maxVisibleAnnotations = MAX_VISIBLE_ANNOTATIONS;
    }
    
    return _maxVisibleAnnotations;
}

#pragma mark - Reload - main logic

/**
 * This is called from ARViewController, it handles main logic, what is called and when.
 */
- (void)reload:(NSArray<ArvixARAnnotation*>*)annotations reloadType:(PresenterReloadType)reloadType
{
    if (!self.arViewController.arStatus.ready) return;
    
    BOOL relayoutIsNeed = false;
    
    //===== Filtering annotations and creating annotation views, only done on new reload location or when annotations changed.
    if (reloadType == PresenterReloadTypeAnnotationsChanged
        || reloadType == PresenterReloadTypeReloadLocationChanged
        || self.annotations.count == 0) {
        self.annotations = annotations;
        self.activeAnnotations = [self activeAnnotationsFromAnnotations:annotations];
        [self createAnnotationViews];
        
        relayoutIsNeed = true;
    }
    
    //===== Here we do stuff that must be done even on .userLocationChanged
    if (relayoutIsNeed || reloadType == PresenterReloadTypeUserLocationChanged) {
        [self adjustDistanceOffsetParameters];
        
        for (ArvixARAnnotationView *annotationView in self.annotationViews) {
            [annotationView bindUi];
        }
        
        relayoutIsNeed = true;
    }
    
    BOOL stackIsNeeded = relayoutIsNeed && self.verticalStackingEnabled;
    if (stackIsNeeded) {
        // This must be done before layout
        [self resetStackParameters];
    }
    
    [self addRemoveAnnotationViews:self.arViewController.arStatus];
    [self layoutAnnotationViews:self.arViewController.arStatus relayoutAll:relayoutIsNeed];
    
    if (stackIsNeeded) {
        // This must be done after layout.
        [self stackAnnotationViews];
    }
}

#pragma mark - Filtering(Active annotations)

/**
 * Gives opportunity to the presenter to filter annotations and reduce number of items it is working with.
 
 * Default implementation filters by maxVisibleAnnotations and maxDistance.
 */
- (NSArray<ArvixARAnnotation*>*)activeAnnotationsFromAnnotations:(NSArray<ArvixARAnnotation*>*)annotations
{
    NSMutableArray *activeAnnotations = [NSMutableArray array];
    
    for (ArvixARAnnotation *annotation in annotations) {
        
        // maxVisibleAnnotations filter
        if (activeAnnotations.count >= self.maxVisibleAnnotations) {
            annotation.active = false;
            continue;
        }
        
        // maxDistance filter
        if (self.maxDistance != 0 && annotation.distanceFromUser > self.maxDistance) {
            annotation.active = false;
            continue;
        }
        
        annotation.active = true;
        [activeAnnotations addObject:annotation];
    }
    
    return activeAnnotations;
}

#pragma mark - Creating annotation Views

/**
 * Creates views for active annotations and removes views from inactive annotations.
 * @IMPROVEMENT: Add reuse logic
 */
- (void)createAnnotationViews
{
    NSMutableArray *annotationViews = [NSMutableArray array];
    NSArray *activeAnnotations = self.activeAnnotations;
    
    // Removing existing annotation views and reseting some properties
    for (ArvixARAnnotationView *annotationView in self.annotationViews) {
        [annotationView removeFromSuperview];
    }
    
    // Destroy views for inactive anntotations
    for (ArvixARAnnotation *annotation in self.annotations) {
        if (!annotation.active) {
            annotation.annotationView = nil;
        }
    }
    
    // Crete views for active annotations
    for (ArvixARAnnotation *tempAnnotation in activeAnnotations) {
        ArvixARAnnotationView *annotationView = nil;
        if (tempAnnotation.annotationView != nil) {
            annotationView = tempAnnotation.annotationView;
        } else {
            if (self.arViewController.dataSource) {
                annotationView = [self.arViewController.dataSource ar:self.arViewController viewForAnnotation:tempAnnotation];
            }
            
        }
        
        tempAnnotation.annotationView = annotationView;
        if (annotationView != nil) {
            annotationView.annotaion = tempAnnotation;
            [annotationViews addObject:annotationView];
        }
    }
    
    self.annotationViews = annotationViews;
    
}

/**
 * Removes all annotation views from screen and resets annotations
 */
- (void)clear
{
    for (ArvixARAnnotation *annotation in self.annotations) {
        annotation.active = false;
        annotation.annotationView = nil;
    }
    
    for (ArvixARAnnotationView *annotationView in self.annotationViews) {
        [annotationView removeFromSuperview];
    }
    
    self.annotations = nil;
    self.activeAnnotations = nil;
    self.annotationViews = nil;
    self.visibleAnnotationViews = nil;
}

#pragma mark - Add/Remove

/**
 * Adds/removes annotation views to/from superview depending if view is on visible part of the screen.
 * Also, if annotation view is on visible part, it is added to visibleAnnotationViews.
 */
- (void)addRemoveAnnotationViews:(ArvixARStatus*)arStatus
{
    double degreesDeltaH = arStatus.hFov;
    double heading = arStatus.heading;
    
    NSMutableArray *tempVisibleAnnotationViews = [NSMutableArray arrayWithArray:self.visibleAnnotationViews];
    [tempVisibleAnnotationViews removeAllObjects];
    
    for (ArvixARAnnotation *annotation in self.activeAnnotations) {
        if (!annotation.annotationView) continue;
        
        ArvixARAnnotationView *annotationView = annotation.annotationView;
        
        // This is distance of center of annotation to the center of screen, measured in degrees
        double delta = deltaAngle(heading, annotation.azimuth);
        if (fabs(delta) < degreesDeltaH) {
            if (annotationView.superview == nil) {
                [self addSubview:annotationView];
            }
            [tempVisibleAnnotationViews addObject:annotationView];
        } else {
            if (annotationView.superview != nil) {
                [annotationView removeFromSuperview];
            }
        }
    }
    
    self.visibleAnnotationViews = tempVisibleAnnotationViews;
}

#pragma mark - Layout

/**
 * Layouts annotation views.
 * - Parameter relayoutAll: If true it will call xPositionForAnnotationView/yPositionForAnnotationView for each annotation view, else
 * it will only take previously calculated x/y positions and add heading/pitch offsets to visible annotation views.
 */
- (void)layoutAnnotationViews:(ArvixARStatus*)arStatus relayoutAll:(BOOL)relayoutAll
{
    CGFloat pitchYOffset = (CGFloat)arStatus.pitch * arStatus.vPixelsPerDegree;
    NSArray *annotationViews = relayoutAll ? self.annotationViews : self.visibleAnnotationViews;
    
    for (ArvixARAnnotationView *annotationView in annotationViews) {
        if (!annotationView.annotaion) continue;
        
        ArvixARAnnotation *annotation = annotationView.annotaion;
        if (relayoutAll) {
            CGFloat x = [self xPositionForAnnotationView:annotationView arStatus:arStatus];
            CGFloat y = [self yPositionForAnnotationView:annotationView arStatus:arStatus];
            
            annotationView.arZeroPoint = CGPointMake(x, y);
        }
        CGFloat headingXOffset = (CGFloat)(deltaAngle(annotation.azimuth, arStatus.heading)) * (CGFloat)(arStatus.hPixelsPerDegree);
        
        CGFloat x = annotationView.arZeroPoint.x + headingXOffset;
        CGFloat y = annotationView.arZeroPoint.y + pitchYOffset + annotationView.arStackOffset.y;
        //NSLog(@"annotationView(x:%f y:%f)", x, y);
        
        // Final position of annotation
        annotationView.frame = CGRectMake(x, y, annotationView.bounds.size.width, annotationView.bounds.size.height);
    }
}

/**
 * x position without the heading, heading offset is added in layoutAnnotationViews due to performance.
 */
- (CGFloat)xPositionForAnnotationView:(ArvixARAnnotationView*)annotationView arStatus:(ArvixARStatus*)arStatus
{
    CGFloat centerX = self.bounds.size.width * 0.5;
    CGFloat x = centerX - (annotationView.bounds.size.width * annotationView.centerOffset.x);
    
    return x;
}

/**
 * y position without the pitch, pitch offset is added in layoutAnnotationViews due to performance.
 */
- (CGFloat)yPositionForAnnotationView:(ArvixARAnnotationView*)annotationView arStatus:(ArvixARStatus*)arStatus
{
    if (annotationView.annotaion == nil) return 0;
    
    ArvixARAnnotation *annotation = annotationView.annotaion;
    CGFloat bottomY = self.bounds.size.height * (CGFloat)self.bottomBorder;
    double distance = annotation.distanceFromUser;
    
    // Offset by distance
    double distanceOffset = 0;
    if (self.distanceOffsetMode != DistanceOffsetModeNone) {
        if (self.distanceOffsetFunction) {
            distanceOffsetFunction function = self.distanceOffsetFunction;
            distanceOffset = function(distance);
        } else if (distance > self.distanceOffsetMinThreshold && self.distanceOffsetMultiplier != 0) {
            double distanceOffsetMultiplier = self.distanceOffsetMultiplier;
            double distanceForOffsetCalculation = distance - self.distanceOffsetMinThreshold;
            distanceOffset = -(distanceForOffsetCalculation * distanceOffsetMultiplier);
        }
    }
    
    CGFloat y = bottomY - (annotationView.bounds.size.height * annotationView.centerOffset.y) + (float)distanceOffset;
    
    return y;
}



#pragma mark - DistanceOffset

- (void)adjustDistanceOffsetParameters
{
    if (self.activeAnnotations.firstObject
        && self.activeAnnotations.firstObject.distanceFromUser != 0
        && self.activeAnnotations.lastObject
        && self.activeAnnotations.lastObject.distanceFromUser) {
        double minDistance = self.activeAnnotations.firstObject.distanceFromUser;
        double maxDistance = self.activeAnnotations.lastObject.distanceFromUser;
        
        if (minDistance > maxDistance) {minDistance = maxDistance;}
        double deltaDistance = maxDistance - minDistance;
        double availableHeight = (double)(self.bounds.size.height) * self.bottomBorder - 30; // 30 because we don't want them to be on top but little bit below
        
        if (self.distanceOffsetMode == DistanceOffsetModeAutomatic) {
            self.distanceOffsetMinThreshold = minDistance;
            self.distanceOffsetMultiplier = deltaDistance > 0 ? availableHeight / deltaDistance : 0;
        } else if (self.distanceOffsetMode == DistanceOffsetModeAutomaticOffsetMinDistance) {
            self.distanceOffsetMinThreshold = minDistance;
        }
    }
}

#pragma mark - Getter & Setter

- (NSArray<ArvixARAnnotation*>*)annotations
{
    if (!_annotations) {
        _annotations = [NSArray array];
    }
    
    return _annotations;
}

- (NSArray<ArvixARAnnotation*>*)activeAnnotations
{
    if (!_activeAnnotations) {
        _activeAnnotations = [NSArray array];
    }
    
    return _activeAnnotations;
}

- (NSArray<ArvixARAnnotationView*>*)annotationViews
{
    if (!_annotationViews) {
        _annotationViews = [NSArray array];
    }
    
    return _annotationViews;
}

- (NSArray<ArvixARAnnotationView*>*)visibleAnnotationViews
{
    if (!_visibleAnnotationViews) {
        _visibleAnnotationViews = [NSArray array];
    }
    
    return _visibleAnnotationViews;
}

@end
