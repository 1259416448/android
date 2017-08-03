//
//  OTWARViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWARViewController.h"
#import "MCYARConfiguration.h"
#import "MCYARAnnotation.h"
#import "MCYARAnnotationView.h"
#import "MCYARViewController.h"

#import "OTWCustomAnnotationView.h"
#import "OTWFootprintSearchParams.h"
#warning test
#import "OTWFootprintsChangeAddressController.h"

@interface OTWARViewController ()<MCYARDataSource>
@property (nonatomic,strong) OTWFootprintSearchParams *footprintSearchParams;
@end

@implementation OTWARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showARViewController];
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
    
    double lat = 30.540017;
    double lon = 104.063377;
    double deltaLat = 0.04;
    double deltaLon = 0.07;
    double altitudeDelta = 0;
    NSInteger count = 20;
    
#warning 这是假数据，需要换为真实数据
    NSArray *dummyAnnotations = [self getDummyAnnotation:lat centerLongitude:lon deltaLat:deltaLat deltaLon:deltaLon altitudeDelta:altitudeDelta count:count];
    [self setAnnotations:dummyAnnotations];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)buildUI // test
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 80, 44);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:backButton aboveSubview:self.presenter];
    
    //刷新
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat refreshButtonX = SCREEN_WIDTH - 35 - 15;
    CGFloat refreshButtonY = SCREEN_HEIGHT - 195 - 35;
    refreshButton.frame = CGRectMake(refreshButtonX, refreshButtonY, 35, 35);
    refreshButton.backgroundColor = [UIColor clearColor];
    [refreshButton setImage:[UIImage imageNamed:@"ar_huanyipi"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:refreshButton aboveSubview:self.presenter];
    
    //时间
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat dateButtonY = CGRectGetMaxY(refreshButton.frame) + 10;
    dateButton.frame = CGRectMake(refreshButtonX, dateButtonY, 35, 35);
    dateButton.backgroundColor = [UIColor clearColor];
    [dateButton setImage:[UIImage imageNamed:@"zj_shijian"] forState:UIControlStateNormal];
    [dateButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:dateButton aboveSubview:self.presenter];
    
    //定位
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat locationButtonY = CGRectGetMaxY(dateButton.frame) + 10;
    locationButton.frame = CGRectMake(refreshButtonX, locationButtonY, 35, 35);
    locationButton.backgroundColor = [UIColor clearColor];
    [locationButton setImage:[UIImage imageNamed:@"juli"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:locationButton aboveSubview:self.presenter];
    
    //相机
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat cameraButtonX = SCREEN_WIDTH - 50*3 - 15 - 7*2;
    CGFloat cameraButtonY = SCREEN_HEIGHT - 15*2 - 50;
    cameraButton.frame = CGRectMake(cameraButtonX, cameraButtonY, 50, 50);
    cameraButton.backgroundColor = [UIColor clearColor];
    [cameraButton setImage:[UIImage imageNamed:@"ar_fabu"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:cameraButton aboveSubview:self.presenter];
    
    //列表
    UIButton *arListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat arListButtonX = CGRectGetMaxX(cameraButton.frame) + 7;
    arListButton.frame = CGRectMake(arListButtonX, cameraButtonY, 50, 50);
    arListButton.backgroundColor = [UIColor clearColor];
    [arListButton setImage:[UIImage imageNamed:@"ar_list"] forState:UIControlStateNormal];
    [arListButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:arListButton aboveSubview:self.presenter];
    
    //平面地图
    UIButton *planeMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat planeMapButtonX = CGRectGetMaxX(arListButton.frame) + 7;
    planeMapButton.frame = CGRectMake(planeMapButtonX, cameraButtonY, 50, 50);
    planeMapButton.backgroundColor = [UIColor clearColor];
    [planeMapButton setImage:[UIImage imageNamed:@"ar_pingmian"] forState:UIControlStateNormal];
    [planeMapButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:planeMapButton aboveSubview:self.presenter];
    
//    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchButton.frame = CGRectMake(SCREEN_WIDTH-80, 100, 80, 80);
//    searchButton.backgroundColor = [UIColor whiteColor];
//    [searchButton setImage:[UIImage imageNamed:@"ar_list"] forState:UIControlStateNormal];
//    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:searchButton aboveSubview:self.presenter];
//    
//    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    nextButton.frame = CGRectMake(SCREEN_WIDTH-80, 200, 80, 80);
//    nextButton.backgroundColor = [UIColor whiteColor];
//    [nextButton setTitle:@"换一批" forState:UIControlStateNormal];
//    [nextButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:nextButton aboveSubview:self.presenter];
    
}

- (void)nextButtonClick
{
    double lat = 30.540117;
    double lon = 104.063477;
    double deltaLat = 0.04;
    double deltaLon = 0.07;
    double altitudeDelta = 0;
    NSInteger count = 50;
    
#warning 这是假数据，需要换为真实数据
    NSArray *dummyAnnotations = [self getDummyAnnotation:lat centerLongitude:lon deltaLat:deltaLat deltaLon:deltaLon altitudeDelta:altitudeDelta count:count];
    //[self.presenter clear];
    ///[self clearRadar];
    [self setAnnotations:dummyAnnotations];
}

- (void)backButtonClick
{
    [[OTWLaunchManager sharedManager].mainTabController didSelectedItemByIndex:0]; // 显示首页
}

- (void)searchButtonClick
{
    OTWFootprintsChangeAddressController *personalInfo = [[OTWFootprintsChangeAddressController alloc] init];
    [self.navigationController pushViewController:personalInfo animated:YES];
}

- (void)showARViewController
{
    // Present ARViewController
    self.dataSource = self;
    // Vertical offset by distance
    self.presenter.distanceOffsetMode = DistanceOffsetModeManual;
    self.presenter.distanceOffsetMultiplier = 0.1; // Pixels per meter
    self.presenter.distanceOffsetMinThreshold = 500;
    self.presenter.maxDistance = 3000;
    self.presenter.maxVisibleAnnotations = 100;
    self.presenter.verticalStackingEnabled = true;
    self.trackingManager.userDistanceFilter = 15;
    self.trackingManager.reloadDistanceFilter = 50;
    // debug
    self.uiOptions.closeButtonEnabled = false;
    self.uiOptions.debugLabel = false;
    self.uiOptions.closeButtonEnabled = true;
    self.uiOptions.debugMap = false;
    self.uiOptions.simulatorDebugging = [Platform isSimulator];;
    self.uiOptions.setUserLocationToCenterOfAnnotations = [Platform isSimulator];
    // Interface orientation
    self.interfaceOrientationMask = UIInterfaceOrientationMaskAll;
    __weak typeof(self) weakSelf;
    self.onDidFailToFindLocation = ^(NSTimeInterval timeElapsed, BOOL acquiredLocationBefore) {
        [weakSelf handleLocationFailure:timeElapsed acquiredLocationBefore:acquiredLocationBefore arViewController:weakSelf];
    };
}

-(OTWFootprintSearchParams *)footprintSearchParams
{
    if (!_footprintSearchParams) {
        _footprintSearchParams = [[OTWFootprintSearchParams alloc] init];
        //列表查询
        _footprintSearchParams.type = @"ar";
        //默认当前页为 0
        _footprintSearchParams.number = 0;
        //默认每页大小为 15
        _footprintSearchParams.size = 15;
        //范围
        //_footprintSearchParams.distance = @"";
        //时间
        //_footprintSearchParams.time = @"";
    }
    
    return _footprintSearchParams;
}

- (NSArray*)getDummyAnnotation:(double)centerLatitude centerLongitude:(double)centerLongitude deltaLat:(double)deltaLat deltaLon:(double)deltaLon altitudeDelta:(double)altitudeDelta count:(NSInteger)count
{
    NSMutableArray *annotations = [NSMutableArray array];
    srand48(2);
    
    for (int i = 0; i < count; i++) {
        CLLocation *location = [self getRandomLocation:centerLatitude centerLongitude:centerLongitude deltaLat:deltaLat deltaLon:deltaLon altitudeDelta:altitudeDelta];
        
        MCYARAnnotation *annotation = [[MCYARAnnotation alloc] initWithIdentifier:nil title:[NSString stringWithFormat:@"PppI(%d)", i] location:location];
        [annotations addObject:annotation];
    }
    
    return annotations;
}

- (NSArray*)addDummyAnnotationWithLat:(double)lat lon:(double)lon altitude:(double)altitude title:(NSString*)title
{
    NSMutableArray *annotations = [NSMutableArray array];
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) altitude:altitude horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
    MCYARAnnotation *annotation = [[MCYARAnnotation alloc] initWithIdentifier:nil title:title location:location];
    [annotations addObject:annotation];
    
    return annotations;
}

- (CLLocation*)getRandomLocation:(double)centerLatitude centerLongitude:(double)centerLongitude deltaLat:(double)deltaLat deltaLon:(double)deltaLon altitudeDelta:(double)altitudeDelta
{
    double lat = centerLatitude;
    double lon = centerLongitude;
    
    double latDelta = -(deltaLat / 2) + drand48() * deltaLat;
    double lonDelta = -(deltaLon / 2) + drand48() * deltaLon;
    lat = lat + latDelta;
    lon = lon + lonDelta;
    
    double altitude = drand48() * altitudeDelta;
    
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) altitude:altitude horizontalAccuracy:1 verticalAccuracy:1 timestamp:[NSDate date]];
}

- (void)handleLocationFailure:(NSTimeInterval)elapsedSeconds acquiredLocationBefore:(BOOL)acquiredLocationBefore
             arViewController:(MCYARViewController*)arViewController
{
    MCYARViewController *arVC = arViewController;
    if (arVC == nil) return;
    if ([Platform isSimulator]) return;
    
    NSLog(@"Failed to find location after: (%f) seconds, acquiredLocationBefore: (%d)", elapsedSeconds, acquiredLocationBefore);
    
    // Example of handling location failure
    if (elapsedSeconds >= 20 && !acquiredLocationBefore) {
        
        // Stopped bcs we don't want multiple alerts
        [arVC.trackingManager stopTracking];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Problems" message:@"Cannot find location, use Wi-Fi if possible!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark - MCYARDatasource
- (MCYARAnnotationView*)ar:(MCYARViewController*)arViewController viewForAnnotation:(MCYARAnnotation*)annotation
{
    OTWCustomAnnotationView *annotationView = [[OTWCustomAnnotationView alloc] init];
    annotationView.frame = CGRectMake(0, 0, 164, 42);
    
    return annotationView;
}

@end
