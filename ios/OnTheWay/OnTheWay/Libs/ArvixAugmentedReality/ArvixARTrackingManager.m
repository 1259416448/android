//
//  ArvixARBaseTrackingManager.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ArvixARTrackingManager.h"
#import "ArvixARConfiguration.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface ArvixARTrackingManager () <BMKLocationServiceDelegate>
{
    double _innerHeadingFilterFactor;
}

@property (nonatomic, assign) BOOL tracking;      // Tracking state.
@property (nonatomic, strong) BMKLocationService *locationManager;
@property (nonatomic, strong) CLLocation *userLocation; // Last detected user location
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) CMAcceleration previousAcceleration;
@property (nonatomic, strong) CLLocation *reloadLocationPrevious;
//位置通知定时任务
@property (nonatomic, strong) NSTimer *reportLocationTimer;
//定位成功后发出成功通知的时间 = 0 表示第一次定位 第一次定位会立即通知
@property (nonatomic, assign) NSTimeInterval reportLocationDate;
//暂时没有发现有什么用，目前是错误后5s后发起错误回调
@property (nonatomic, strong) NSTimer *locationSearchTimer;
//开始时间
@property (nonatomic, assign) NSTimeInterval locationSearchStartTime;
@property (nonatomic, assign) BOOL catchupPitch;
@property (nonatomic, strong) NSDate *headingStartDate;
@property (nonatomic, assign) CLDeviceOrientation orientation;


@end

@implementation ArvixARTrackingManager

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // init public property
        self.headingFilterFactor = 0.05;
        _innerHeadingFilterFactor = 0.05;
        _pitchFilterFactor = 0.05;
        _reloadDistanceFilter = 50;
        _userDistanceFilter = 15;
        _minimumHeadingAccuracy = 120;
        _allowCompassCalibration = false;
        _minimumLocationHorizontalAccuracy = 500;
        _minimumLocationAge = 30;
        
        // init private property
        
        _tracking = false;
        _heading = 0;
        _filteredHeading = 0;
        _filteredPitch = 0;
        
        self.stopLocation = YES;
        
        self.locationManager.distanceFilter = self.userDistanceFilter;
        
        _previousAcceleration.x = 0;
        _previousAcceleration.y = 0;
        _previousAcceleration.z = 0;
        
        _locationSearchTimer = nil;
        _locationSearchStartTime = 0;
        _catchupPitch = false;
        
        _orientation = CLDeviceOrientationPortrait;
        //self.locationManager.headingOrientation = self.orientation;
        
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    // Defaults
    self.reloadDistanceFilter = 50;
    self.userDistanceFilter = 15;
    
    // Setup location manager
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = self.userDistanceFilter;
    self.locationManager.headingFilter = 1;
    self.locationManager.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self deviceOrientationDidChange];
}

- (void)deviceOrientationDidChange
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft
        || deviceOrientation == UIDeviceOrientationLandscapeRight
        || deviceOrientation == UIDeviceOrientationPortrait
        || deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        self.orientation = (CLDeviceOrientation)deviceOrientation;
    }
}

#pragma mark - Public Methods


#pragma mark Tracking

/**
 * Starts location and motion manager 初始值为false
 
 * - Parameter notifyFailure:     If true, will call arTrackingManager:didFailToFindLocationAfter: if location is not found.
 */
- (void)startTracking:(BOOL)notifyLocationFailure
{
    if(self.stopLocation){
        [self resetAllTrackingData];
        self.locationManager.delegate = self;
        // Request authorization if state is not determined
        if (CLLocationManager.locationServicesEnabled) {
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                //提示没有打开定位，直接return掉
                return;
            }
        }
        
        // Location search
        if (notifyLocationFailure) {
            [self startLocationSearchTimer:true];
            
            // Calling delegate with value 0 to be flexible, for example user might want to show indicator when search is starting.
            if (self.delegate && [self.delegate respondsToSelector:@selector(arTrackingManager:didFailToFindLocationAfter:)]) {
                [self.delegate arTrackingManager:self didFailToFindLocationAfter:0];
            }
        }
        
        // Debug
        if (self.debugLocation != nil) {
            self.userLocation = self.debugLocation;
        }
        
        // Start motion and location managers
        [self.motionManager startAccelerometerUpdates];
        [self.locationManager startUserLocationService];
        self.tracking = true;
    }
}

/**
 * Stops location and motion manager
 */
- (void)stopTracking
{
    if(self.stopLocation){
        [self resetAllTrackingData];
        // stop motion and location managers
        [self.motionManager stopAccelerometerUpdates];
        [self.locationManager stopUserLocationService];
        self.locationManager.delegate = nil;
        self.tracking = false;
    }
}

/**
 * stops all timers and resets all data.
 */
- (void)resetAllTrackingData
{
    [self stopLocationSearchTimer:true];
    self.locationSearchStartTime = 0;
    
    [self stopReportLocationTimer];
    self.reportLocationDate = 0;
    
    _previousAcceleration.x = 0;
    _previousAcceleration.y = 0;
    _previousAcceleration.z = 0;
    
    self.userLocation = nil;
    self.heading = 0;
    self.filteredHeading = 0;
    self.filteredPitch = 0;
    
    // This will make filterdPitch catchup current pitch value on next heading calculation
    self.catchupPitch = true;
    self.headingStartDate = nil;
}

#pragma mark  Location search

/**
 * 由swift特性转编而来 初始值为true
 */
- (void)startLocationSearchTimer:(BOOL)resetStartTime
{
    [self stopLocationSearchTimer:true];
    
    if (resetStartTime) {
        self.locationSearchStartTime = [NSDate date].timeIntervalSince1970;
    }
    self.locationSearchTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(locationSearchTimerTick) userInfo:nil repeats:false];
}

/**
 * 由swift特性转编而来 初始值为true
 */
- (void)stopLocationSearchTimer:(BOOL)resetStartTime
{
    if (self.locationSearchTimer) {
        [self.locationSearchTimer invalidate];
        self.locationSearchTimer = nil;
    }
}

- (void)locationSearchTimerTick
{
    if (self.locationSearchStartTime == 0) return;
    
    NSTimeInterval locationSeachStartTime = self.locationSearchStartTime;
    NSTimeInterval elapsedSeconds =[[NSDate date] timeIntervalSince1970] - locationSeachStartTime;
    
    [self startLocationSearchTimer:false];
    if (self.delegate && [self.delegate respondsToSelector:@selector(arTrackingManager:didFailToFindLocationAfter:)]) {
        [self.delegate arTrackingManager:self didFailToFindLocationAfter:elapsedSeconds];
    }
}

#pragma mark

- (void)stopReportLocationTimer
{
    if (self.reportLocationTimer) {
        [self.reportLocationTimer invalidate];
        self.reportLocationTimer = nil;
    }
}

- (void)startReportLocationTimer
{
    [self stopReportLocationTimer];
    self.reportLocationTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reportLocationToDelegate) userInfo:nil repeats:NO];
}

- (void)reportLocationToDelegate
{
    [self stopReportLocationTimer];
    self.reportLocationDate = [NSDate date].timeIntervalSince1970;
    
    if (self.userLocation == nil || self.reloadLocationPrevious == nil || self.reloadDistanceFilter == 0) return;
    
    CLLocation *userLocation = self.userLocation;
    CLLocation *reloadLocationPrevious = self.reloadLocationPrevious;
    CLLocationDistance reloadDistanceFilter = self.reloadDistanceFilter;
    
    if ([reloadLocationPrevious distanceFromLocation:userLocation] > reloadDistanceFilter) {
        self.reloadLocationPrevious = userLocation;
        if (self.delegate && [self.delegate respondsToSelector:@selector(arTrackingManager:didUpdateReloadLocation:)]) {
            [self.delegate arTrackingManager:self didUpdateReloadLocation:userLocation];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(arTrackingManager:didUpdateUserLocation:)]) {
            [self.delegate arTrackingManager:self didUpdateUserLocation:userLocation];
        }
    }
}

#pragma mark Calculations

/**
 * Returns filtered(low-pass) pitch in degrees. -90(looking down), 0(looking straight), 90(looking up)
 */
- (void)filterPitch
{
    if (self.debugPitch != 0) return;
    if (self.motionManager.accelerometerData == nil) return;
    
    CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    
    // First real reding agter startTracking? Making filter catch up
    if (self.catchupPitch && (acceleration.x != 0 || acceleration.y != 0 || acceleration.z != 0)) {
        self.previousAcceleration = acceleration;
        self.catchupPitch = false;
    }
    
    // Low-pass filter - filtering data so it is not jumping around.
    double pitchFilterFactor = self.pitchFilterFactor;
    _previousAcceleration.x = (acceleration.x * pitchFilterFactor) + (self.previousAcceleration.x  * (1.0 - pitchFilterFactor));
    _previousAcceleration.y = (acceleration.y * pitchFilterFactor) + (self.previousAcceleration.y  * (1.0 - pitchFilterFactor));
    _previousAcceleration.z = (acceleration.z * pitchFilterFactor) + (self.previousAcceleration.z  * (1.0 - pitchFilterFactor));
    
    CLDeviceOrientation deviceOrientation = self.orientation;
    double angle = 0;
    
    if (deviceOrientation == CLDeviceOrientationPortrait)
    {
        angle = atan2(self.previousAcceleration.y, self.previousAcceleration.z);
    }
    else if (deviceOrientation == CLDeviceOrientationPortraitUpsideDown)
    {
        angle = atan2(-self.previousAcceleration.y, self.previousAcceleration.z);
    }
    else if (deviceOrientation == CLDeviceOrientationLandscapeLeft)
    {
        angle = atan2(self.previousAcceleration.x, self.previousAcceleration.z);
    }
    else if (deviceOrientation == CLDeviceOrientationLandscapeRight)
    {
        angle = atan2(-self.previousAcceleration.x, self.previousAcceleration.z);
    }
    
    angle = radiansToDegrees(angle);
    angle += 90;
    // Not really needed but, if pointing device down it will return 0...-30...-60...270...240 but like this it returns 0...-30...-60...-90...-120
    if (angle > 180 ) {
        angle -= 360;
    }
    
    // Even more filtering, not sure if really needed //@TODO
    self.filteredPitch = (self.filteredPitch + angle) / 2.0;
}

- (void)filterHeading
{
    double headingFilterFactor = _innerHeadingFilterFactor;
    double previousFilteredHeading = self.filteredHeading;
    double newHeading = self.debugHeading;
    if (self.debugHeading == 0) {
        newHeading = self.heading;
    }
    
    /*
     Low pass filter on heading cannot be done by using regular formula because our input(heading)
     is circular so we would have problems on heading passing North(0). Example:
     newHeading = 350
     previousHeading = 10
     headingFilterFactor = 0.5
     filteredHeading = 10 * 0.5 + 350 * 0.5 = 180 NOT OK - IT SHOULD BE 0
     
     First solution is to instead of passing 350 to the formula, we pass -10.
     Second solution is to not use 0-360 degrees but to express values with sine and cosine.
     */
    
    /*
     Second solution
     let newHeadingRad = degreesToRadians(newHeading)
     self.filteredHeadingSin = sin(newHeadingRad) * headingFilterFactor + self.filteredHeadingSin * (1 - headingFilterFactor)
     self.filteredHeadingCos = cos(newHeadingRad) * headingFilterFactor + self.filteredHeadingCos * (1 - headingFilterFactor)
     self.filteredHeading = radiansToDegrees(atan2(self.filteredHeadingSin, self.filteredHeadingCos))
     self.filteredHeading = normalizeDegree(self.filteredHeading)
     */
    
    double newHeadingTransformed = newHeading;
    if (fabs(newHeading - previousFilteredHeading) > 180) {
        if (previousFilteredHeading < 180 && newHeading > 180) {
            newHeadingTransformed -= 360;
        } else if (previousFilteredHeading > 180 && newHeading < 180) {
            newHeadingTransformed += 360;
        }
    }
    self.filteredHeading = (newHeadingTransformed * headingFilterFactor) + (previousFilteredHeading * (1.0 - headingFilterFactor));
    self.filteredHeading = normalizeDegree(self.filteredHeading);
}

/**
 * rename to heading
 * bool 默认值为false
 */
- (double)azimuthFromUserToLocation:(CLLocation*)userLocation location:(CLLocation*)location approximate:(BOOL)approximate
{
    double azimuth = 0;
    if (approximate) {
        azimuth = [self approximateBearingBetween:userLocation endLocation:location];
    } else {
        azimuth = [self bearingBetween:userLocation endLocation:location];
    }
    
    return azimuth;
}

- (double)bearingBetween:(CLLocation*) startLocation endLocation:(CLLocation*)endLocation
{
    double azimuth = 0;
    CLLocationCoordinate2D startCoordinate = startLocation.coordinate;
    double lat1 = degreesToRadians(startCoordinate.latitude);
    double lon1 = degreesToRadians(startCoordinate.longitude);
    
    double lat2 = degreesToRadians(endLocation.coordinate.latitude);
    double lon2 = degreesToRadians(endLocation.coordinate.longitude);
    
    double dLon = lon2 - lon1;
    
    //NSLog(@"start(lat1:%f, lon1:%f)  end(lat2:%f lon2:%f) dLon:%f", lat1, lon1, lat2, lon2, dLon);
    
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double radiansBearing = atan2(y, x);
    azimuth = radiansToDegrees(radiansBearing);
    if (azimuth < 0) {
        azimuth += 360;
    }
    
    return azimuth;
}

/**
 Approximate bearing between two points, good for small distances(<10km).
 This is 30% faster than bearingBetween but it is not as precise. Error is about 1 degree on 10km, 5 degrees on 300km, depends on location...
 
 It uses formula for flat surface and multiplies it with LAT_LON_FACTOR which "simulates" earth curvature.
 */
- (double)approximateBearingBetween:(CLLocation*)startLocation endLocation:(CLLocation*)endLocation
{
    double azimuth = 0;
    
    CLLocationCoordinate2D startCoordinate = startLocation.coordinate;
    CLLocationCoordinate2D endCoordinate = endLocation.coordinate;
    
    double latitudeDistance = startCoordinate.latitude - endCoordinate.latitude;
    double longitudeDistance = startCoordinate.longitude - endCoordinate.longitude;
    
    azimuth = radiansToDegrees(atan2(longitudeDistance, (latitudeDistance * (double)LAT_LON_FACTOR)));
    azimuth += 180.0;
    
    return azimuth;
}

/**
 * location/heading/pitch 都是可选值
 */
- (void)startDebugMode:(CLLocation*)location heading:(double)heading pitch:(double)pitch
{
    if (location != nil) {
        self.debugLocation = location;
        self.userLocation = location;
    }
    
    if (heading != 0) {
        self.debugHeading = heading;
        //self.filteredHeading = heading    // Don't, it is different for heading bcs we are also simulating low pass filter
    }
    
    if (pitch != 0) {
        self.debugPitch = pitch;
        self.filteredPitch = pitch;
    }
}

- (void)stopDebugMode
{
    self.debugLocation = nil;
    self.userLocation = nil;
    self.debugHeading = 0;
    self.debugPitch = 0;
}

#pragma mark - Setter

- (BMKLocationService*)locationManager
{
    if (!_locationManager) {
        _locationManager = [[BMKLocationService alloc] init];
    }
    
    return _locationManager;
}

- (CMMotionManager*)motionManager
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    
    return _motionManager;
}

#pragma mark - BMKLocationServiceDelegate

//经纬度变化
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocation *location = userLocation.location;
    
    DLog("目前经纬度信息 location %f %f",location.coordinate.latitude,location.coordinate.longitude);
    
    NSTimeInterval age = location.timestamp.timeIntervalSinceNow;
    
    //    NSLog(@"Disregarding location: age:%f, self.minimumLocationAge:%f , self.minimumLocationHorizontalAccuracy:%f, location.horizontalAccuracy:%f", age, self.minimumLocationAge, self.minimumLocationHorizontalAccuracy, location.horizontalAccuracy);
    
    DLog(@"经纬度发生了变化！！！ %f age %f s",[self.userLocation distanceFromLocation:location],age);
    
    if(self.userLocation && [self.userLocation distanceFromLocation:location] < self.userDistanceFilter) return;
    
    if (age < -self.minimumLocationAge
        || location.horizontalAccuracy > self.minimumLocationHorizontalAccuracy
        || location.horizontalAccuracy < 0) {
        
        return;
    }
    
    // Location found, stop timer that is responsible for measuring how long location is not found.
    [self stopLocationSearchTimer:true];
    
    //===== Set current user location
    self.userLocation = location;
    
    if (_debugLocation != nil) {self.userLocation = _debugLocation;}
    if (self.reloadLocationPrevious == nil) {self.reloadLocationPrevious = self.userLocation;}
    
    //===== Reporting location 5s after we get location, this will filter multiple locations calls and make only one delegate call
    BOOL reportIsScheduled = (self.reportLocationTimer != nil);
    
    // First time, reporting immediately
    if (self.reportLocationDate == 0) {
        [self reportLocationToDelegate];
    }
    // Report is already scheduled, doing nothing, it will report last location delivered in max 5s
    // 位置通知定时任务已经创建，这里什么也不做，将在5秒内通知最后一个位置更新
    else if (reportIsScheduled) {
        
    }
    // Scheduling report in 5s
    //没有创建通知，这里创建位置报告
    else {
        DLog(@"经纬度发生了变化！！！已经通知");
        [self startReportLocationTimer];
    }
    
}

//罗盘信息变化
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    CLHeading *newHeading = userLocation.heading;
    
    if (newHeading.headingAccuracy < 0 || newHeading.headingAccuracy > self.minimumHeadingAccuracy) return;
    
    double previousHeading = self.heading;
    
    // filteredHeading is not updated here bcs this is not called too often. filterHeading method should be called manually
    // with display timer.
    if (newHeading.trueHeading < 0) {
        self.heading = fmod(newHeading.magneticHeading, 360.0);
    } else {
        self.heading = fmod(newHeading.trueHeading, 360.0);
    }
    
    /**
     Handling unprecise readings, this whole section should prevent annotations from spinning because of
     unprecise readings & filtering. e.g. if first reading is 10° and second is 80°, due to filtering, annotations
     would move slowly from 10°-80°. So when we detect such situtation, we set _otwHeadingFilterFactor to 1, meaning that
     filtering is temporarily disabled and annotatoions will immediately jump to new heading.
     
     This is done only first 5 seconds after first heading.
     */
    
    // First heading after tracking started. Catching up filteredHeading.
    if (self.headingStartDate == nil) {
        self.headingStartDate = [NSDate date];
        self.filteredHeading = self.heading;
    }
    
    if (self.headingStartDate != nil) { // Always ture
        NSDate *headingStartDate = self.headingStartDate;
        double recommendedHeadingFilterFactor = self.headingFilterFactor;
        NSTimeInterval headingFilteringStartTime = 5;
        
        // First 5 seconds after first heading?
        if (headingStartDate.timeIntervalSinceNow > -headingFilteringStartTime) {
            // Disabling filtering if heading difference(current and previous) is > 10
            if (fabs(deltaAngle(self.heading, previousHeading)) > 10) {
                recommendedHeadingFilterFactor = 1; // We could also just set self.filteredHeading = self.heading
            }
        }
        _innerHeadingFilterFactor = recommendedHeadingFilterFactor;
    }
    
}

//定位信息错误
- (void)didFailToLocateUserWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(arTrackingManager:didFailToLocateWithError:)]) {
        [self.delegate arTrackingManager:self didFailToLocateWithError:error];
    }
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return self.allowCompassCalibration;
}



@end
