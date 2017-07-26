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
#warning test
#import "OTWFootprintsChangeAddressController.h"

@interface OTWARViewController ()<MCYARDataSource>

@end

@implementation OTWARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showARViewController];
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildUI
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 80, 44);
    backButton.backgroundColor = [UIColor whiteColor];
    [backButton setImage:[UIImage imageNamed:@"AR_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.arViewController.view insertSubview:backButton atIndex:0];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(SCREEN_WIDTH-80, 100, 80, 80);
    searchButton.backgroundColor = [UIColor whiteColor];
    [searchButton setImage:[UIImage imageNamed:@"ar_list"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.arViewController.view insertSubview:searchButton atIndex:0];
}

- (void)backButtonClick
{
    [self.arViewController dismissViewControllerAnimated:YES completion:nil];
    [[OTWLaunchManager sharedManager].mainTabController didSelectedItemByIndex:0]; // 显示首页
}

- (void)searchButtonClick
{
    NSLog(@"点击了search按钮");
    OTWFootprintsChangeAddressController *personalInfo = [[OTWFootprintsChangeAddressController alloc] init];
    [self.arViewController dismissViewControllerAnimated:NO completion:^{
        [self.navigationController pushViewController:personalInfo animated:YES];
    }];
    
    
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)showARViewController
{
    double lat = 30.540017;
    double lon = 104.063377;
    double deltaLat = 0.04;
    double deltaLon = 0.07;
    double altitudeDelta = 0;
    NSInteger count = 20;
    
    NSArray *dummyAnnotations = [self getDummyAnnotation:lat centerLongitude:lon deltaLat:deltaLat deltaLon:deltaLon altitudeDelta:altitudeDelta count:count];
    
    // Present ARViewController
    self.arViewController = [[MCYARViewController alloc] init];
    self.arViewController.dataSource = self;
    // Vertical offset by distance
    self.arViewController.presenter.distanceOffsetMode = DistanceOffsetModeManual;
    self.arViewController.presenter.distanceOffsetMultiplier = 0.1; // Pixels per meter
    self.arViewController.presenter.distanceOffsetMinThreshold = 500;
    self.arViewController.presenter.maxDistance = 3000;
    self.arViewController.presenter.maxVisibleAnnotations = 100;
    self.arViewController.presenter.verticalStackingEnabled = true;
    self.arViewController.trackingManager.userDistanceFilter = 15;
    self.arViewController.trackingManager.reloadDistanceFilter = 50;
    // debug
    self.arViewController.uiOptions.closeButtonEnabled = false;
    self.arViewController.uiOptions.debugLabel = false;
    self.arViewController.uiOptions.closeButtonEnabled = true;
    self.arViewController.uiOptions.debugMap = false;
    self.arViewController.uiOptions.simulatorDebugging = [Platform isSimulator];;
    self.arViewController.uiOptions.setUserLocationToCenterOfAnnotations = [Platform isSimulator];
    // Interface orientation
    self.arViewController.interfaceOrientationMask = UIInterfaceOrientationMaskAll;
    __weak typeof(self) weakSelf;
    self.arViewController.onDidFailToFindLocation = ^(NSTimeInterval timeElapsed, BOOL acquiredLocationBefore) {
        [weakSelf handleLocationFailure:timeElapsed acquiredLocationBefore:acquiredLocationBefore arViewController:weakSelf.arViewController];
    };
    [self.arViewController setAnnotations:dummyAnnotations];
    //[self.navigationController pushViewController:self.arViewController animated:NO];
    [self presentViewController:self.arViewController animated:NO completion:nil];
}

- (NSArray*)getDummyAnnotation:(double)centerLatitude centerLongitude:(double)centerLongitude deltaLat:(double)deltaLat deltaLon:(double)deltaLon altitudeDelta:(double)altitudeDelta count:(NSInteger)count
{
    NSMutableArray *annotations = [NSMutableArray array];
    srand48(2);
    
    for (int i = 0; i < count; i++) {
        CLLocation *location = [self getRandomLocation:centerLatitude centerLongitude:centerLongitude deltaLat:deltaLat deltaLon:deltaLon altitudeDelta:altitudeDelta];
        
        MCYARAnnotation *annotation = [[MCYARAnnotation alloc] initWithIdentifier:nil title:[NSString stringWithFormat:@"POI(%d)", i] location:location];
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
    annotationView.frame = CGRectMake(0, 0, 150, 50);
    
    return annotationView;
}

@end
