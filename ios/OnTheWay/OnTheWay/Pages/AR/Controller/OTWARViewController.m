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
#import "OTWARCustomAnnotation.h"
#import "MCYARAnnotationView.h"
#import "MCYARViewController.h"

#import "OTWCustomAnnotationView.h"
#import "OTWFootprintSearchParams.h"
#import "OTWFootprintsChangeAddressController.h"
#import "OTWFootprintReleaseViewController.h"
#import "OTWFootprintsViewController.h"
#import "OTWFootprintService.h"
#import "OTWUITapGestureRecognizer.h"

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>
#import <MJExtension.h>
#import "MBProgressHUD+PYExtension.h"

@interface OTWARViewController ()<MCYARDataSource,BMKLocationServiceDelegate>

@property(nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) UIButton *refreshButton;
@property(nonatomic,strong) UIButton *dateButton;
@property(nonatomic,strong) UIButton *locationButton;
@property(nonatomic,strong) UIButton *cameraButton;
@property(nonatomic,strong) UIButton *arListButton;
@property(nonatomic,strong) UIButton *planeMapButton;

@property(nonatomic,strong) UIButton *dateButton_oneDay;
@property(nonatomic,strong) UIButton *dateButton_sevenDay;
@property(nonatomic,strong) UIButton *dateButton_oneMonth;
@property(nonatomic,strong) UIButton *locationBtton_100m;
@property(nonatomic,strong) UIButton *locationBtton_500m;
@property(nonatomic,strong) UIButton *locationBtton_1000m;


//查询对象
@property (nonatomic,strong) OTWFootprintSearchParams *footprintSearchParams;
//定位
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,copy) BMKUserLocation *userLocation;
@property (nonatomic,strong) NSDictionary *reponseCacheData;

@end

@implementation OTWARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocService];
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
    _locService.delegate = self;
    self.dateButton_oneDay.hidden = YES;
    self.dateButton_sevenDay.hidden = YES;
    self.dateButton_oneMonth.hidden = YES;
    self.locationBtton_100m.hidden = YES;
    self.locationBtton_500m.hidden = YES;
    self.locationBtton_1000m.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
}

- (void)buildUI
{
    //返回按钮
    [self.view insertSubview:self.backButton aboveSubview:self.presenter];
    
    //刷新
    OTWUITapGestureRecognizer *refreshTapGesture=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshFootprints)];
    [self.refreshButton addGestureRecognizer:refreshTapGesture];
    [self.view insertSubview:self.refreshButton aboveSubview:self.presenter];
    
    //时间
    CGFloat dateButtonX = SCREEN_WIDTH - 35 - 15;
    CGFloat dateButtonY = CGRectGetMaxY(self.refreshButton.frame) + 10;
    self.dateButton.frame = CGRectMake(dateButtonX, dateButtonY, 35, 35);
    [self.view insertSubview:self.dateButton aboveSubview:self.presenter];
    
    //定位
    CGFloat locationButtonY = CGRectGetMaxY(self.dateButton.frame) + 10;
    self.locationButton.frame = CGRectMake(dateButtonX, locationButtonY, 35, 35);
    [self.view insertSubview:self.locationButton aboveSubview:self.presenter];
    
    //相机
    CGFloat cameraButtonX = SCREEN_WIDTH - 50*3 - 15 - 7*2;
    CGFloat cameraButtonY = SCREEN_HEIGHT - 15*2 - 50;
    self.cameraButton.frame = CGRectMake(cameraButtonX, cameraButtonY, 50, 50);
    [self.view insertSubview:self.cameraButton aboveSubview:self.presenter];
    
    //列表
    CGFloat arListButtonX = CGRectGetMaxX(self.cameraButton.frame) + 7;
    self.arListButton.frame = CGRectMake(arListButtonX, cameraButtonY, 50, 50);
    [self.view insertSubview:self.arListButton aboveSubview:self.presenter];
    
    //平面地图
    CGFloat planeMapButtonX = CGRectGetMaxX(self.arListButton.frame) + 7;
    self.planeMapButton.frame = CGRectMake(planeMapButtonX, cameraButtonY, 50, 50);
    [self.view insertSubview:self.planeMapButton aboveSubview:self.presenter];
    
    //时间筛选-1天内
    CGFloat dateButton_oneDayX = CGRectGetMaxX(self.dateButton.frame) - 65*3 - 5*3 - 35;
    self.dateButton_oneDay.frame = CGRectMake(dateButton_oneDayX, dateButtonY, 65, 35);
    [self.view insertSubview:self.dateButton_oneDay aboveSubview:self.presenter];
    
    //时间筛选-7天内
    CGFloat dateButton_sevenDayX = CGRectGetMaxX(self.dateButton.frame) - 65*2 - 5*2- 35;
    self.dateButton_sevenDay.frame = CGRectMake(dateButton_sevenDayX, dateButtonY, 65, 35);
    [self.view insertSubview:self.dateButton_sevenDay aboveSubview:self.presenter];
    
    //时间筛选-一个月内
    CGFloat dateButton_oneMonthX = CGRectGetMaxX(self.dateButton.frame) - 65 - 5- 35;
    self.dateButton_oneMonth.frame = CGRectMake(dateButton_oneMonthX, dateButtonY, 65, 35);
    [self.view insertSubview:self.dateButton_oneMonth aboveSubview:self.presenter];
    
    //距离筛选-100米内
    CGFloat locationBtton_100mX = CGRectGetMaxX(self.dateButton.frame) - 45*3 - 5*3 - 35;
    self.locationBtton_100m.frame = CGRectMake(locationBtton_100mX, locationButtonY, 45, 35);
    [self.view insertSubview:self.locationBtton_100m aboveSubview:self.presenter];
    
    //距离筛选-500米内
    CGFloat locationBtton_500mX = CGRectGetMaxX(self.dateButton.frame) - 45*2 - 5*2 - 35;
    self.locationBtton_500m.frame = CGRectMake(locationBtton_500mX, locationButtonY, 45, 35);
    [self.view insertSubview:self.locationBtton_500m aboveSubview:self.presenter];
    
    //距离筛选-1000米内
    CGFloat locationBtton_1000mX = CGRectGetMaxX(self.dateButton.frame) - 45 - 5 - 35;
    self.locationBtton_1000m.frame = CGRectMake(locationBtton_1000mX, locationButtonY, 45, 35);
    [self.view insertSubview:self.locationBtton_1000m aboveSubview:self.presenter];
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self initCLLocationManager];
        if(_locService){
            _locService.delegate = nil;
            _locService = nil;
        }
        return;
    }
    
    //开始定位服务
    [_locService startUserLocationService];
    
//    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    nextButton.frame = CGRectMake(SCREEN_WIDTH-80, 200, 80, 80);
//    nextButton.backgroundColor = [UIColor whiteColor];
//    [nextButton setTitle:@"换一批" forState:UIControlStateNormal];
//    [nextButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:nextButton aboveSubview:self.presenter];
    
}



- (void) initLocService{
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)initCLLocationManager
{
    BOOL enable=[CLLocationManager locationServicesEnabled];
    NSInteger status=[CLLocationManager authorizationStatus];
    if(!enable || status<3)
    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
        {
            CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打开定位开关"
                                                            message:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"立即开启",@"好", nil];
        [alertView show];
        
    }
}

//- (void)nextButtonClick
//{
//    double lat = 30.740117;
//    double lon = 104.063477;
//    double deltaLat = 0.04;
//    double deltaLon = 0.07;
//    double altitudeDelta = 0;
//    NSInteger count = 50;
//    
//#warning 这是假数据，需要换为真实数据
//    NSArray *dummyAnnotations = [self getDummyAnnotation:lat centerLongitude:lon deltaLat:deltaLat deltaLon:deltaLon altitudeDelta:altitudeDelta count:count];
////    [self.presenter clear];
////    /[self clearRadar];
//    [self setAnnotations:dummyAnnotations];
//}


#pragma mark 返回事件
- (void)backButtonClick
{
    [[OTWLaunchManager sharedManager].mainTabController didSelectedItemByIndex:0]; // 显示首页
}

#pragma mark 控制时间筛选按钮显示／隐藏
- (void)dateButtonClick
{
    
    self.dateButton_oneDay.hidden = !self.dateButton_oneDay.hidden;
    self.dateButton_sevenDay.hidden = !self.dateButton_sevenDay.hidden;
    self.dateButton_oneMonth.hidden = !self.dateButton_oneMonth.hidden;
}

#pragma mark 控制距离筛选按钮显示／隐藏
- (void)locationButtonClick
{
    
    self.locationBtton_100m.hidden = !self.locationBtton_100m.hidden;
    self.locationBtton_500m.hidden = !self.locationBtton_500m.hidden;
    self.locationBtton_1000m.hidden = !self.locationBtton_1000m.hidden;
}

#pragma mark 刷新-换一批足迹
- (void)refreshFootprints
{
    DLog(@"OTWUITapGestureRecognizer手势----%@",self.footprintSearchParams.mj_keyValues);
    [self getFootprints];
}


#pragma mark 根据时间筛选
- (void)searchBydate:(OTWUITapGestureRecognizer*)tapGesture
{
    NSMutableDictionary *condition = tapGesture.opId;
    self.footprintSearchParams.time = [condition objectForKey:@"searchParamValue"];
    DLog(@"OTWUITapGestureRecognizer手势----%@",self.footprintSearchParams.mj_keyValues);
    [self getFootprints];
}

#pragma mark 根据距离筛选
- (void)searchByDistance:(OTWUITapGestureRecognizer*)tapGesture
{
    NSMutableDictionary *condition = tapGesture.opId;
    self.footprintSearchParams.searchDistance = [condition objectForKey:@"searchParamValue"];
    DLog(@"OTWUITapGestureRecognizer手势----%@",self.footprintSearchParams.mj_keyValues);
    [self getFootprints];
}



#pragma mark 跳转至足迹列表页面
- (void)toFootprintListView
{
    OTWFootprintsViewController *footprintListVC = [[OTWFootprintsViewController alloc] init];
    [self.navigationController pushViewController:footprintListVC animated:YES];
}

#pragma mark 跳转至足迹发布页面
- (void)toReleaseFootprintView
{
    OTWFootprintReleaseViewController *footprintReleaseVC = [[OTWFootprintReleaseViewController alloc] init];
    [self.navigationController pushViewController:footprintReleaseVC animated:YES];
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

#pragma mark 初始化足迹查询参数
-(OTWFootprintSearchParams *)footprintSearchParams
{
    if (!_footprintSearchParams) {
        _footprintSearchParams = [[OTWFootprintSearchParams alloc] init];
        //列表查询
        _footprintSearchParams.type = @"ar";
        //默认搜索半径为1公里
        _footprintSearchParams.searchDistance = @"three";
        //默认当前页为 0
        _footprintSearchParams.number = 0;
        //默认每页大小为 15
        _footprintSearchParams.size = 30;
        //默认不是最后一页
        _footprintSearchParams.isLastPage = NO;
        //默认是第一页
        _footprintSearchParams.isFirstPage = YES;
        //默认足迹发布时间1个月内
        _footprintSearchParams.time = @"oneMonth";
    }
    
    return _footprintSearchParams;
}

-(void)fetchARFootprints:(NSDictionary *)params completion:(requestBackBlock)block
{
    
    [OTWFootprintService getFootprintList:params completion:^(id result, NSError *error) {
        if (result) {
            if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
                if (block) {
                    self.footprintSearchParams.currentTime = result[@"currentTime"];
                    block(result);
                }
            }else{
                if(self.reponseCacheData){
                    if (block) {
                        block(self.reponseCacheData);
                    }
                }
            }
        } else {
            if(self.reponseCacheData){
                if (block) {
                    block(self.reponseCacheData);
                }
            }
        }
    } responseCache:^(id responseCache) {
        self.reponseCacheData = responseCache;
    }];
}

#pragma mark 根据查询参数加载足迹数据
- (void)getFootprints
{
    DLog(@"搜索结果：%@",self.footprintSearchParams.mj_keyValues);
    [self fetchARFootprints:self.footprintSearchParams.mj_keyValues completion:^(id result) {
        DLog(@"是否为最后一页%@",result[@"body"][@"last"]);
        if (result[@"body"][@"last"]) {
            self.footprintSearchParams.isLastPage = YES;
            self.footprintSearchParams.number  = 0;
        } else {
            self.footprintSearchParams.number += 1;
        }
        if ([[NSString stringWithFormat:@"%@",result[@"body"][@"first"]] isEqualToString:@"true"]) {
            self.footprintSearchParams.isFirstPage = YES;
        }
        
        NSMutableArray *footprintModels = [OTWFootprintListModel mj_objectArrayWithKeyValuesArray:result[@"body"][@"content"]];
        if (footprintModels.count == 0) {
            return;
        }
        NSArray *dummyAnnotations = [self assembleAnnotation:footprintModels];
        [self setAnnotations:dummyAnnotations];
    }];
}

- (NSArray*)getDummyAnnotation:(double)centerLatitude centerLongitude:(double)centerLongitude altitudeDelta:(double)altitudeDelta count:(NSInteger)count
{
    NSMutableArray *annotations = [NSMutableArray array];
    srand48(2);
    
    for (int i = 0; i < count; i++) {
        CLLocation *location = [self getRandomLocation:centerLatitude centerLongitude:centerLongitude altitudeDelta:altitudeDelta];
        
        MCYARAnnotation *annotation = [[MCYARAnnotation alloc] initWithIdentifier:nil title:[NSString stringWithFormat:@"PppI(%d)", i] location:location];
        [annotations addObject:annotation];
    }
    
    return annotations;
}

#pragma mark 组装足迹annotation
- (NSArray*)assembleAnnotation:(NSMutableArray<OTWFootprintListModel*>*)footprints
{
    double altitudeDelta = 0;
    NSMutableArray *annotations = [NSMutableArray array];
    for (OTWFootprintListModel *footprint in footprints) {
        CLLocation *location = [self getRandomLocation:footprint.latitude centerLongitude:footprint.longitude altitudeDelta:altitudeDelta];
        OTWARCustomAnnotation *annotation = [[OTWARCustomAnnotation alloc] init];
        annotation.footprint = footprint;
        annotation.location = location;
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

- (CLLocation*)getRandomLocation:(double)centerLatitude centerLongitude:(double)centerLongitude altitudeDelta:(double)altitudeDelta
{
    double lat = centerLatitude;
    double lon = centerLongitude;
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

#pragma mark 跳转到足迹详情
-(void)jumpToFootprintDetail:(OTWUITapGestureRecognizer*)gesture
{
    OTWARCustomAnnotation *annotation = gesture.opId;
    OTWFootprintDetailController *VC =  [[OTWFootprintDetailController alloc] init];
    [VC setFid:annotation.footprint.footprintId.description];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - MCYARDatasource
- (MCYARAnnotationView*)ar:(MCYARViewController*)arViewController viewForAnnotation:(MCYARAnnotation*)annotation
{
    OTWCustomAnnotationView *annotationView = [[OTWCustomAnnotationView alloc] init];
    annotationView.frame = CGRectMake(0, 0, 164, 42);
    OTWUITapGestureRecognizer *tapGesture=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToFootprintDetail:)];
    tapGesture.opId = annotation;
    [annotationView addGestureRecognizer:tapGesture];
    return annotationView;
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
    //定位信息加载成功，一般刷新时会调用
    self.footprintSearchParams.latitude = userLocation.location.coordinate.latitude;
    self.footprintSearchParams.longitude = userLocation.location.coordinate.longitude;
    self.footprintSearchParams.number = 0;
    self.footprintSearchParams.currentTime = nil;
    [self getFootprints];
    [_locService stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [_locService stopUserLocationService];
}

#pragma mark 按钮初始化
- (UIButton*)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 20, 80, 44);
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton setImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton*)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat refreshButtonX = SCREEN_WIDTH - 35 - 15;
        CGFloat refreshButtonY = SCREEN_HEIGHT - 195 - 35;
        _refreshButton.frame = CGRectMake(refreshButtonX, refreshButtonY, 35, 35);
        _refreshButton.backgroundColor = [UIColor clearColor];
        [_refreshButton setImage:[UIImage imageNamed:@"ar_huanyipi"] forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(dateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

- (UIButton*)dateButton
{
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dateButton.backgroundColor = [UIColor clearColor];
        [_dateButton setImage:[UIImage imageNamed:@"zj_shijian"] forState:UIControlStateNormal];
        [_dateButton addTarget:self action:@selector(dateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateButton;
}

- (UIButton*)locationButton
{
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.backgroundColor = [UIColor clearColor];
        [_locationButton setImage:[UIImage imageNamed:@"juli"] forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(locationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationButton;
}

- (UIButton*)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.backgroundColor = [UIColor clearColor];
        [_cameraButton setImage:[UIImage imageNamed:@"ar_fabu"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(toReleaseFootprintView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}
- (UIButton*)arListButton
{
    if (!_arListButton) {
        _arListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _arListButton.backgroundColor = [UIColor clearColor];
        [_arListButton setImage:[UIImage imageNamed:@"ar_list"] forState:UIControlStateNormal];
        [_arListButton addTarget:self action:@selector(toFootprintListView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arListButton;
}

- (UIButton*)planeMapButton
{
    if (!_planeMapButton) {
        _planeMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _planeMapButton.backgroundColor = [UIColor clearColor];
        [_planeMapButton setImage:[UIImage imageNamed:@"ar_pingmian"] forState:UIControlStateNormal];
    }
    return _planeMapButton;
}

- (UIButton*)dateButton_oneDay
{
    if (!_dateButton_oneDay) {
        _dateButton_oneDay = [UIButton buttonWithType:UIButtonTypeCustom];
        _dateButton_oneDay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _dateButton_oneDay.layer.cornerRadius = 18;
        [_dateButton_oneDay setTitle:@"一天内" forState:UIControlStateNormal];
        [_dateButton_oneDay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _dateButton_oneDay.titleLabel.font = [UIFont systemFontOfSize:14];
        _dateButton_oneDay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        NSMutableDictionary *customCondition = [[NSMutableDictionary alloc] init];
        OTWUITapGestureRecognizer *tapGesture_oneday = [[OTWUITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBydate:)];
        customCondition = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"oneDay",@"searchParamValue",nil];
        tapGesture_oneday.opId = customCondition;
        [self.dateButton_oneDay addGestureRecognizer:tapGesture_oneday];
    }
    return _dateButton_oneDay;
}

- (UIButton*)dateButton_sevenDay
{
    if (!_dateButton_sevenDay) {
        _dateButton_sevenDay = [UIButton buttonWithType:UIButtonTypeCustom];
        _dateButton_sevenDay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _dateButton_sevenDay.layer.cornerRadius = 18;
        [_dateButton_sevenDay setTitle:@"7天内" forState:UIControlStateNormal];
        [_dateButton_sevenDay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _dateButton_sevenDay.titleLabel.font = [UIFont systemFontOfSize:14];
        _dateButton_sevenDay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        NSMutableDictionary *customCondition = [[NSMutableDictionary alloc] init];
        OTWUITapGestureRecognizer *tapGesture_sevenday=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchBydate:)];
        customCondition = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"sevenDay",@"searchParamValue",nil];
        tapGesture_sevenday.opId = customCondition;
        [_dateButton_sevenDay addGestureRecognizer:tapGesture_sevenday];
    }
    return _dateButton_sevenDay;
}

- (UIButton*)dateButton_oneMonth
{
    if (!_dateButton_oneMonth) {
        _dateButton_oneMonth = [UIButton buttonWithType:UIButtonTypeCustom];
        _dateButton_oneMonth.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _dateButton_oneMonth.layer.cornerRadius = 18;
        [_dateButton_oneMonth setTitle:@"1个月内" forState:UIControlStateNormal];
        [_dateButton_oneMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _dateButton_oneMonth.titleLabel.font = [UIFont systemFontOfSize:14];
        _dateButton_oneMonth.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        NSMutableDictionary *customCondition = [[NSMutableDictionary alloc] init];
        OTWUITapGestureRecognizer *tapGesture_onemonth=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchBydate:)];
        customCondition = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"oneMonth",@"searchParamValue",nil];
        tapGesture_onemonth.opId = customCondition;
        [_dateButton_oneMonth addGestureRecognizer:tapGesture_onemonth];
    }
    return _dateButton_oneMonth;
}

- (UIButton*)locationBtton_100m
{
    if (!_locationBtton_100m) {
        _locationBtton_100m = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationBtton_100m.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _locationBtton_100m.layer.cornerRadius = 18;
        [_locationBtton_100m setTitle:@"100m" forState:UIControlStateNormal];
        [_locationBtton_100m setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _locationBtton_100m.titleLabel.font = [UIFont systemFontOfSize:14];
        _locationBtton_100m.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        NSMutableDictionary *customCondition = [[NSMutableDictionary alloc] init];
        OTWUITapGestureRecognizer *tapGesture_100m=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchByDistance:)];
        customCondition = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"one",@"searchParamValue",nil];
        tapGesture_100m.opId = customCondition;
        [_locationBtton_100m addGestureRecognizer:tapGesture_100m];
    }
    return _locationBtton_100m;
}

- (UIButton*)locationBtton_500m
{
    if (!_locationBtton_500m) {
        _locationBtton_500m = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationBtton_500m.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _locationBtton_500m.layer.cornerRadius = 18;
        [_locationBtton_500m setTitle:@"500m" forState:UIControlStateNormal];
        [_locationBtton_500m setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _locationBtton_500m.titleLabel.font = [UIFont systemFontOfSize:14];
        _locationBtton_500m.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        NSMutableDictionary *customCondition = [[NSMutableDictionary alloc] init];
        OTWUITapGestureRecognizer *tapGesture_500m=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchByDistance:)];
        customCondition = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"two",@"searchParamValue",nil];
        tapGesture_500m.opId = customCondition;
        [_locationBtton_500m addGestureRecognizer:tapGesture_500m];
    }
    return _locationBtton_500m;
}

- (UIButton*)locationBtton_1000m
{
    if (!_locationBtton_1000m) {
        _locationBtton_1000m = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationBtton_1000m.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _locationBtton_1000m.layer.cornerRadius = 18;
        [_locationBtton_1000m setTitle:@"1km" forState:UIControlStateNormal];
        [_locationBtton_1000m setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _locationBtton_1000m.titleLabel.font = [UIFont systemFontOfSize:14];
        _locationBtton_1000m.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        NSMutableDictionary *customCondition = [[NSMutableDictionary alloc] init];
        OTWUITapGestureRecognizer *tapGesture_1000m=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchByDistance:)];
        customCondition = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"three",@"searchParamValue",nil];
        tapGesture_1000m.opId = customCondition;
        [_locationBtton_1000m addGestureRecognizer:tapGesture_1000m];
    }
    return _locationBtton_1000m;
}

@end
