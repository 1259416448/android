//
//  OTWPrintARViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPrintARViewController.h"
#import "ArvixARConfiguration.h"
#import "ArvixARAnnotation.h"
#import "OTWARCustomAnnotation.h"
#import "ArvixARAnnotationView.h"
#import "ArvixARViewController.h"
#import "OTWPlaneMapViewController.h"

#import "OTWCustomAnnotationView.h"
#import "OTWFootprintSearchParams.h"
#import "OTWFootprintsChangeAddressController.h"
#import "OTWFootprintReleaseViewController.h"
#import "OTWFootprintsViewController.h"
#import "OTWFootprintService.h"
#import "OTWUITapGestureRecognizer.h"

#import <MJExtension.h>
#import "MBProgressHUD+PYExtension.h"
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>

@interface OTWPrintARViewController ()<ArvixARDataSource,UIAlertViewDelegate,BMKGeoCodeSearchDelegate>

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

@property(nonatomic,strong) UIView *infoBGView;
@property(nonatomic,strong) UILabel *footprintLabel;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UILabel *footprintSumLabel;
@property(nonatomic,strong) UIImageView *addressImageView;
@property(nonatomic,strong) UIImage *addressImage;
@property(nonatomic,strong) UILabel *addressLabel;

//查询对象
@property (nonatomic,strong) OTWFootprintSearchParams *footprintSearchParams;
@property (nonatomic,strong) NSDictionary *reponseCacheData;

@property (nonatomic,assign) BOOL ifFirstLoadData;

//经纬度反解码
@property (nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;


@end

@implementation OTWPrintARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showARViewController];
    [self buildUI];
    self.ifFirstLoadData = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otwApplicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;    //让rootView禁止滑动
    }
}

-(void) otwApplicationDidBecomeActive
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){ //移除页面上显示的数据
        [self setAnnotations:@[]];
        _ifFirstLoadData = NO;
    }
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    //当前方法一定不能省略
    [super viewWillAppear:animated];
    self.geoCodeSearch.delegate = self;
    [self hideAllButton];
    [self.navigationController setNavigationBarHidden:YES];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
    //定位信息
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self initCLLocationManager];
        return ;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.geoCodeSearch.delegate = nil;
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
    
    //附近足迹总信息
    [self.view insertSubview:self.infoBGView aboveSubview:self.presenter];
    [self.infoBGView addSubview:self.footprintLabel];
    [self.infoBGView addSubview:self.lineView];
    [self.infoBGView addSubview:self.footprintSumLabel];
    [self.infoBGView addSubview:self.addressImageView];
    [self.infoBGView addSubview:self.addressLabel];
    
}

-(MBProgressHUD *) addLoadingHud
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.userInteractionEnabled = NO;
    return hud;
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
        //alertView.tag = ALERTTAGNUMBER;
        [alertView show];
        
    }
}

#pragma marks -- UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark 返回事件
- (void)backButtonClick
{
    self.trackingManager.stopLocation = TRUE;
    [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexFind]; // 显示首页
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

-(void)hideAllButton
{
    self.dateButton_oneDay.hidden = YES;
    self.dateButton_sevenDay.hidden = YES;
    self.dateButton_oneMonth.hidden = YES;
    self.locationBtton_100m.hidden = YES;
    self.locationBtton_500m.hidden = YES;
    self.locationBtton_1000m.hidden = YES;
}

- (void)planeMapButtonClick
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSUInteger index = [viewControllers indexOfObject:[OTWLaunchManager sharedManager].footprintPlaneMapVC];
    if(index != NSNotFound){
        [self.navigationController popToViewController:[OTWLaunchManager sharedManager].footprintPlaneMapVC animated:NO];
    }else{
        [self.navigationController pushViewController:[OTWLaunchManager sharedManager].footprintPlaneMapVC animated:NO];
    }
}

#pragma mark 刷新-换一批足迹
- (void)refreshFootprints
{
    [self hideAllButton];
    [self getFootprints];
}


#pragma mark 根据时间筛选
- (void)searchBydate:(OTWUITapGestureRecognizer*)tapGesture
{
    NSMutableDictionary *condition = tapGesture.opId;
    self.footprintSearchParams.time = [condition objectForKey:@"searchParamValue"];
    self.footprintSearchParams.number = 0;
    [self dateButtonClick];
    [self getFootprints];
}

#pragma mark 根据距离筛选
- (void)searchByDistance:(OTWUITapGestureRecognizer*)tapGesture
{
    NSMutableDictionary *condition = tapGesture.opId;
    self.footprintSearchParams.searchDistance = [condition objectForKey:@"searchParamValue"];
    self.footprintSearchParams.number = 0;
    if([self.footprintSearchParams.searchDistance isEqualToString:@"one"]){
        self.radar.maxDistance = 100;
    }else if([self.footprintSearchParams.searchDistance isEqualToString:@"two"]){
        self.radar.maxDistance = 500;
    }else if([self.footprintSearchParams.searchDistance isEqualToString:@"three"]){
        self.radar.maxDistance = 1000;
    }
    [self locationButtonClick];
    [self getFootprints];
}



#pragma mark 跳转至足迹列表页面
- (void)toFootprintListView
{
    //获取当前push View
    NSArray *viewController = self.navigationController.viewControllers;
    //检查 footprintVC 是否在 队列中
    NSUInteger index = [viewController indexOfObject:[OTWLaunchManager sharedManager].footprintVC];
    if(index != NSNotFound){ //存在
        [self.navigationController popToViewController:[OTWLaunchManager sharedManager].footprintVC animated:NO];
    }else{ //不存在
        [self.navigationController pushViewController:[OTWLaunchManager sharedManager].footprintVC animated:NO];
    }
}

#pragma mark 跳转至足迹发布页面
- (void)toReleaseFootprintView
{
    //需要验证登陆
    if([[OTWLaunchManager sharedManager] showLoginViewWithController:self completion:nil]){
        return ;
    }
    OTWFootprintReleaseViewController *footprintReleaseVC = [[OTWFootprintReleaseViewController alloc] init];
    [self.navigationController pushViewController:footprintReleaseVC animated:YES];
}

- (void)showARViewController
{
    //雷达默认范围 1km
    
    self.radar.maxDistance = 1000;
    
    // Present ARViewController
    self.dataSource = self;
    // Vertical offset by distance
    self.presenter.distanceOffsetMode = DistanceOffsetModeManual;
    self.presenter.distanceOffsetMultiplier = 0.1; // Pixels per meter
    self.presenter.distanceOffsetMinThreshold = 500;
    self.presenter.maxDistance = 3000;
    self.presenter.maxVisibleAnnotations = 100;
    self.presenter.verticalStackingEnabled = true;
    self.trackingManager.userDistanceFilter = 30;
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
    MBProgressHUD *hud = [self addLoadingHud];
    [OTWFootprintService getFootprintList:params completion:^(id result, NSError *error) {
        
        [hud hideAnimated:YES];
        
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
            [self netWorkErrorTips:error];
            self.ifFirstLoadData = NO;
        }
    } responseCache:^(id responseCache) {
        self.reponseCacheData = responseCache;
    }];
}

#pragma mark 根据查询参数加载足迹数据
- (void)getFootprints
{
    [self fetchARFootprints:self.footprintSearchParams.mj_keyValues completion:^(id result) {
        
        if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
            //最后一页
            if ([[NSString stringWithFormat:@"%@",result[@"body"][@"last"]] isEqualToString:@"1"]) {
                self.footprintSearchParams.isLastPage = YES;
                self.footprintSearchParams.number  = 0;
                //提示，判断是否是第一页
                if([[NSString stringWithFormat:@"%@",result[@"body"][@"first"]] isEqualToString:@"0"]){
                    [self errorTips:@"已经是最后一批信息，再次点击会循环展示" userInteractionEnabled:NO];
                }
            } else {
                self.footprintSearchParams.number += 1;
            }
            if ([[NSString stringWithFormat:@"%@",result[@"body"][@"first"]] isEqualToString:@"true"]) {
                self.footprintSearchParams.isFirstPage = YES;
            }
            
            NSMutableArray *footprintModels = [OTWFootprintListModel mj_objectArrayWithKeyValuesArray:result[@"body"][@"content"]];
            if (footprintModels.count == 0) {
                [self setAnnotations:@[]];
            }else{
                NSArray *dummyAnnotations = [self assembleAnnotation:footprintModels];
                [self setAnnotations:dummyAnnotations];
            }
            self.footprintSumLabel.text = [NSString stringWithFormat:@"%@",result[@"body"][@"totalElements"]];
        }else{
            [self errorTips:@"服务端繁忙，请稍后再试" userInteractionEnabled:YES];
        }
    }];
}

#pragma mark 组装足迹annotation
- (NSArray*)assembleAnnotation:(NSMutableArray<OTWFootprintListModel*>*)footprints
{
    double altitudeDelta = 0;
    NSMutableArray *annotations = [NSMutableArray array];
    for (OTWFootprintListModel *footprint in footprints) {
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(footprint.latitude, footprint.longitude) altitude:altitudeDelta horizontalAccuracy:1 verticalAccuracy:1 timestamp:[NSDate date]];
        OTWARCustomAnnotation *annotation = [[OTWARCustomAnnotation alloc] init];
        annotation.footprint = footprint;
        annotation.location = location;
        [annotations addObject:annotation];
    }
    return annotations;
}

- (void)handleLocationFailure:(NSTimeInterval)elapsedSeconds acquiredLocationBefore:(BOOL)acquiredLocationBefore
             arViewController:(ArvixARViewController*)arViewController
{
    ArvixARViewController *arVC = arViewController;
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
    self.trackingManager.stopLocation = NO;
    [VC setFid:annotation.footprint.footprintId.description];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - ArvixARDatasource
- (ArvixARAnnotationView*)ar:(ArvixARViewController*)arViewController viewForAnnotation:(ArvixARAnnotation*)annotation
{
    OTWCustomAnnotationView *annotationView = [[OTWCustomAnnotationView alloc] init];
    annotationView.frame = CGRectMake(0, 0, 164, 42);
    OTWUITapGestureRecognizer *tapGesture=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToFootprintDetail:)];
    tapGesture.opId = annotation;
    [annotationView addGestureRecognizer:tapGesture];
    return annotationView;
}

#pragma mark 按钮初始化
- (UIButton*)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 20, 65, 44);
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
        [_planeMapButton addTarget:self action:@selector(planeMapButtonClick) forControlEvents:UIControlEventTouchUpInside];
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

- (UIView *)infoBGView
{
    if(!_infoBGView){
        _infoBGView = [[UIView alloc] initWithFrame:CGRectMake(104, SCREEN_HEIGHT - 15 - 80 + 9, SCREEN_WIDTH - 104 - 15 - 57 * 3 , 80 - 9)];
        _infoBGView.backgroundColor = [UIColor clearColor];
    }
    return _infoBGView;
}

- (UILabel*)footprintLabel
{
    if(!_footprintLabel){
        _footprintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 42, 10)];
        _footprintLabel.textColor = [UIColor whiteColor];
        _footprintLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _footprintLabel.layer.opacity = 0.7;
        _footprintLabel.text = @"附近足迹";
    }
    return _footprintLabel;
}

-(UIView*)lineView
{
    if(!_lineView){
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.footprintLabel.MinX, self.footprintLabel.MaxY + 4, 40, 1)];
        _lineView.backgroundColor = [UIColor whiteColor];
        _lineView.layer.opacity = 0.4;
    }
    return _lineView;
}

-(UILabel*)footprintSumLabel
{
    if(!_footprintSumLabel){
        _footprintSumLabel = [[UILabel alloc] initWithFrame:CGRectMake(_footprintLabel.MinX, self.lineView.MaxY + 4 , self.infoBGView.Witdh + 10 , 25)];
        _footprintSumLabel.textColor = [UIColor whiteColor];
        _footprintSumLabel.layer.opacity = 0.8;
        _footprintSumLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:30];
        _footprintSumLabel.text = @"0";
    }
    return _footprintSumLabel;
}

-(UIImage*)addressImage
{
    if(!_addressImage){
        _addressImage =[UIImage imageNamed:@"dingwei"];
    }
    return _addressImage;
}

-(UIImageView*)addressImageView
{
    if(!_addressImageView){
        _addressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_footprintLabel.MinX, self.footprintSumLabel.MaxY + 11, 10, 10)];
        _addressImageView.image = self.addressImage;
    }
    return _addressImageView;
}

-(UILabel*)addressLabel
{
    if(!_addressLabel){
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.addressImageView.MaxX + 2, self.footprintSumLabel.MaxY + 10 , 150, 12)];
        _addressLabel.textColor = [UIColor color_c4c4c4];
        _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _addressLabel.text = @"定位信息加载中~~~";
    }
    return _addressLabel;
}

-(BMKGeoCodeSearch*)geoCodeSearch
{
    if(!_geoCodeSearch){
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        _geoCodeSearch.delegate = self;
    }
    return _geoCodeSearch;
}

- (void)arTrackingManager:(ArvixARTrackingManager *)trackingManager didUpdateUserLocation:(CLLocation *)location
{
    [super arTrackingManager:trackingManager didUpdateReloadLocation:location];
    
    DLog(@">>>>>>>>,定位成功");
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location.coordinate;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }
    
    //定位信息加载成功，一般刷新时会调用
    if(!self.ifFirstLoadData){
        self.ifFirstLoadData = YES;
        self.footprintSearchParams.latitude = location.coordinate.latitude;
        self.footprintSearchParams.longitude = location.coordinate.longitude;
        self.footprintSearchParams.number = 0;
        self.footprintSearchParams.currentTime = nil;
        [self getFootprints];
    }
    
}

- (void)arTrackingManager:(ArvixARTrackingManager *)trackingManager didUpdateReloadLocation:(CLLocation *)location
{
    [super arTrackingManager:trackingManager didUpdateReloadLocation:location];
    
    DLog(@">>>>>>>>,重新定位成功，这里可以重载数据");
    
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location.coordinate;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }
    
    //定位信息加载成功，一般刷新时会调用
    if(!self.ifFirstLoadData){
        self.ifFirstLoadData = YES;
        self.footprintSearchParams.latitude = location.coordinate.latitude;
        self.footprintSearchParams.longitude = location.coordinate.longitude;
        self.footprintSearchParams.number = 0;
        self.footprintSearchParams.currentTime = nil;
        [self getFootprints];
    }
    
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error ==BMK_SEARCH_NO_ERROR){
        if(result.poiList.count>0){
            BMKPoiInfo *poiInfo = ((BMKPoiInfo *)result.poiList[0]);
            self.addressLabel.text = poiInfo.address;
        }else{
            self.addressLabel.text = result.address;
        }
    }else{
        self.addressLabel.text = @"定位信息加载失败~~~";
    }
}

@end
