//
//  OTWPlaneMapViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPlaneMapViewController.h"
#import "BottomSheetDemoViewController.h"
#import "OTWFootprintReleaseViewController.h"
#import "OTWFootprintsViewController.h"

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import "OTWFootprintService.h"
#import "OTWFootprintSearchParams.h"
#import "OTWPointAnnotation.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OTWUITapGestureRecognizer.h"
#import <MJExtension.h>

#import <STPopup.h>
#import "OTWFootprintReleaseViewController.h"

@interface OTWPlaneMapViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate>

@property (nonatomic,strong) UIView *container;
@property (nonatomic,strong) UIImageView *locationImageV;
@property (nonatomic,strong) UIButton *userImageButtonV;
@property (nonatomic,strong) UIImageView *userImageV;
@property (nonatomic,strong) UIButton *backButton;
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
@property (nonatomic,strong) STPopupController *popupController;
@property (nonatomic,strong) BottomSheetDemoViewController *bottomSheetDemoViewController;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKMapView *mapView;

@property (nonatomic,strong) OTWFootprintSearchParams *footprintSearchParams;
@property (nonatomic,strong) NSDictionary *reponseCacheData;
@property (nonatomic,strong) NSMutableArray *currentAnnotations;
@end

@implementation OTWPlaneMapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    //进入地图初始化隐藏条件筛选按钮
    self.dateButton_oneDay.hidden = YES;
    self.dateButton_sevenDay.hidden = YES;
    self.dateButton_oneMonth.hidden = YES;
    self.locationBtton_100m.hidden = YES;
    self.locationBtton_500m.hidden = YES;
    self.locationBtton_1000m.hidden = YES;
    //隐藏底边栏
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc] init];
    //启动LocationService
    [_locService startUserLocationService];
    
    _mapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    _mapView.showsUserLocation = YES;
    //是否支持地图旋转
    _mapView.rotateEnabled = NO;
    [_mapView setZoomEnabled:YES];
    //设置缩放级别为16级，3~19
    [_mapView setZoomLevel:16];
    self.view = _mapView;
    [self setUpBase];
}

- (void)viewDidAppear:(BOOL)animated
{

}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    //释放内存
    _mapView.delegate = nil;
    _locService.delegate = nil;
}

- (void)dealloc
{
    //释放内存
    _mapView.delegate = nil;
}

- (void)setUpBase
{
    //返回按钮
    [self.view addSubview:self.backButton];
    [self.container addSubview:self.locationImageV];
    [self.locationImageV addSubview:self.userImageButtonV];
    [self.userImageButtonV addSubview:self.userImageV];
    
    //刷新
    OTWUITapGestureRecognizer *refreshTapGesture=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshFootprints)];
    [self.refreshButton addGestureRecognizer:refreshTapGesture];
    [self.view insertSubview:self.refreshButton aboveSubview:self.mapView];
    
    //时间
    CGFloat dateButtonX = SCREEN_WIDTH - 35 - 15;
    CGFloat dateButtonY = CGRectGetMaxY(self.refreshButton.frame) + 10;
    self.dateButton.frame = CGRectMake(dateButtonX, dateButtonY, 35, 35);
    [self.view insertSubview:self.dateButton aboveSubview:self.mapView];
    
    //定位
    CGFloat locationButtonY = CGRectGetMaxY(self.dateButton.frame) + 10;
    self.locationButton.frame = CGRectMake(dateButtonX, locationButtonY, 35, 35);
    [self.view insertSubview:self.locationButton aboveSubview:self.mapView];
    
    //相机
    CGFloat cameraButtonX = SCREEN_WIDTH - 50*3 - 15 - 7*2;
    CGFloat cameraButtonY = SCREEN_HEIGHT - 15*2 - 50;
    self.cameraButton.frame = CGRectMake(cameraButtonX, cameraButtonY, 50, 50);
    [self.view insertSubview:self.cameraButton aboveSubview:self.mapView];
    
    //列表
    CGFloat arListButtonX = CGRectGetMaxX(self.cameraButton.frame) + 7;
    self.arListButton.frame = CGRectMake(arListButtonX, cameraButtonY, 50, 50);
    [self.view insertSubview:self.arListButton aboveSubview:self.mapView];
    
    //平面地图
    CGFloat planeMapButtonX = CGRectGetMaxX(self.arListButton.frame) + 7;
    self.planeMapButton.frame = CGRectMake(planeMapButtonX, cameraButtonY, 50, 50);
    [self.view insertSubview:self.planeMapButton aboveSubview:self.mapView];
    
    //时间筛选-1天内
    CGFloat dateButton_oneDayX = CGRectGetMaxX(self.dateButton.frame) - 65*3 - 5*3 - 35;
    self.dateButton_oneDay.frame = CGRectMake(dateButton_oneDayX, dateButtonY, 65, 35);
    [self.view insertSubview:self.dateButton_oneDay aboveSubview:self.mapView];
    
    //时间筛选-7天内
    CGFloat dateButton_sevenDayX = CGRectGetMaxX(self.dateButton.frame) - 65*2 - 5*2- 35;
    self.dateButton_sevenDay.frame = CGRectMake(dateButton_sevenDayX, dateButtonY, 65, 35);
    [self.view insertSubview:self.dateButton_sevenDay aboveSubview:self.mapView];
    
    //时间筛选-一个月内
    CGFloat dateButton_oneMonthX = CGRectGetMaxX(self.dateButton.frame) - 65 - 5- 35;
    self.dateButton_oneMonth.frame = CGRectMake(dateButton_oneMonthX, dateButtonY, 65, 35);
    [self.view insertSubview:self.dateButton_oneMonth aboveSubview:self.mapView];
    
    //距离筛选-100米内
    CGFloat locationBtton_100mX = CGRectGetMaxX(self.dateButton.frame) - 45*3 - 5*3 - 35;
    self.locationBtton_100m.frame = CGRectMake(locationBtton_100mX, locationButtonY, 45, 35);
    [self.view insertSubview:self.locationBtton_100m aboveSubview:self.mapView];
    
    //距离筛选-500米内
    CGFloat locationBtton_500mX = CGRectGetMaxX(self.dateButton.frame) - 45*2 - 5*2 - 35;
    self.locationBtton_500m.frame = CGRectMake(locationBtton_500mX, locationButtonY, 45, 35);
    [self.view insertSubview:self.locationBtton_500m aboveSubview:self.mapView];
    
    //距离筛选-1000米内
    CGFloat locationBtton_1000mX = CGRectGetMaxX(self.dateButton.frame) - 45 - 5 - 35;
    self.locationBtton_1000m.frame = CGRectMake(locationBtton_1000mX, locationButtonY, 45, 35);
    [self.view insertSubview:self.locationBtton_1000m aboveSubview:self.mapView];
}

#pragma mark 顶部返回按钮
- (void)backButtonClick
{
    [[OTWLaunchManager sharedManager].mainTabController didSelectedItemByIndex:0];
}

#pragma mark 足迹查询参数
-(OTWFootprintSearchParams *)footprintSearchParams
{
    if (!_footprintSearchParams) {
        _footprintSearchParams = [[OTWFootprintSearchParams alloc] init];
        //列表查询
        _footprintSearchParams.type = @"map";
        //默认搜索半径为1公里
        _footprintSearchParams.searchDistance = @"three";
        //默认当前页为 0
        _footprintSearchParams.number = 0;
        //默认每页大小为 30
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

#pragma mark 获取足迹列表
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
    [self fetchARFootprints:self.footprintSearchParams.mj_keyValues completion:^(id result) {
        if ([[NSString stringWithFormat:@"%@",result[@"body"][@"last"]] isEqualToString:@"1"]) {
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
        [self assembleAnnotation:footprintModels];
    }];
}

#pragma mark 刷新-换一批足迹
- (void)refreshFootprints
{
    [self getFootprints];
}

#pragma mark 根据时间筛选
- (void)searchBydate:(OTWUITapGestureRecognizer*)tapGesture
{
    NSMutableDictionary *condition = tapGesture.opId;
    self.footprintSearchParams.time = [condition objectForKey:@"searchParamValue"];
    [self getFootprints];
}

#pragma mark 根据距离筛选
- (void)searchByDistance:(OTWUITapGestureRecognizer*)tapGesture
{
    NSMutableDictionary *condition = tapGesture.opId;
    self.footprintSearchParams.searchDistance = [condition objectForKey:@"searchParamValue"];
    [self getFootprints];
}

#pragma mark 跳转至足迹列表页面
- (void)toFootprintListView
{
    OTWFootprintsViewController *footprintListVC = [[OTWFootprintsViewController alloc] init];
    [self.navigationController pushViewController:footprintListVC animated:YES];
}

#pragma mark 跳转至AR足迹页面
- (void)toARFootprintListView
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

#pragma mark annotations操作
- (void)assembleAnnotation:(NSMutableArray<OTWFootprintListModel*>*)footprints
{
    if (!self.currentAnnotations) {
        self.currentAnnotations = [NSMutableArray array];
    }
    if (self.currentAnnotations && self.currentAnnotations.count > 0) {
        [self removeAllAnnotations];
    }
    for (OTWFootprintListModel *footprint in footprints) {
        [self setAnnotations:footprint];
    }
}

#pragma mark 设置annotation
- (void)setAnnotations:(OTWFootprintListModel*)footprint
{
    CLLocationCoordinate2D coor;
    OTWPointAnnotation *annotation = [[OTWPointAnnotation alloc] init];
    coor.latitude = footprint.latitude;
    coor.longitude = footprint.longitude;
    annotation.coordinate = coor;
    annotation.footprint = footprint;
    //百度地图sdk中的一个bug，必须设置title属性，后面才能响应didSelectAnnotationView代理
    annotation.title = @"";
    [_mapView addAnnotation:annotation];
    [self.currentAnnotations addObject:annotation];
}

#pragma mark 移除所有标注
- (void)removeAllAnnotations
{
    NSArray *annotations = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:annotations];
}

#pragma mark delegate方法
#pragma mark 处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}

#pragma mark 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //定位信息加载成功，一般刷新时会调用
    self.footprintSearchParams.latitude = userLocation.location.coordinate.latitude;
    self.footprintSearchParams.longitude = userLocation.location.coordinate.longitude;
    self.footprintSearchParams.number = 0;
    self.footprintSearchParams.currentTime = nil;
    [self getFootprints];
    [_locService stopUserLocationService];
    [_mapView updateLocationData:userLocation];
}

#pragma mark 将UIView转换成UIImage
-(UIImage*)UIViewToUIImageView:(UIView*)view{
    CGSize size = view.bounds.size;
    //第一个参数表示区域大小；第二个参数表示是否是非透明的如果需要显示半透明效果，需要传NO，否则传YES；第三个参数是屏幕密度
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    
    NSString *identifier  = @"otwAnnotation";
    OTWPointAnnotation *otwAnnotation = (OTWPointAnnotation*)annotation;
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:otwAnnotation reuseIdentifier:identifier];
        UIImage *userImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:otwAnnotation.footprint.userHeadImg]]];
        annotationView.annotation = otwAnnotation;
        [self.userImageV setImage:userImage];
        annotationView.canShowCallout = NO;
        annotationView.image = [self UIViewToUIImageView:self.container];
        annotationView.centerOffset = CGPointMake(drand48()+3, drand48()+3);
        return annotationView;
    }
    return nil;
}

#pragma mark 选中一个annotation views时，调用此接口
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //取消标注选中状态
    [_mapView deselectAnnotation:view.annotation animated:NO];
    OTWPointAnnotation *otwAnnotation = (OTWPointAnnotation*)view.annotation;
    //打开底部模态框
    [self openModal:otwAnnotation.footprint];
}

#pragma mark 打开底部模态框
- (void)openModal:(OTWFootprintListModel*)footprint
{
    NSLog(@"打开模态框！");
    self.bottomSheetDemoViewController = [[BottomSheetDemoViewController alloc] init];
    [self.bottomSheetDemoViewController setFootprint:footprint];
    self.bottomSheetDemoViewController.mapController = self;
    self.popupController = [[STPopupController alloc] initWithRootViewController:self.bottomSheetDemoViewController];
    self.popupController.style = STPopupStyleBottomSheet;
    self.popupController.containerView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.popupController.backgroundView addGestureRecognizer:tapRecognizer];
    [self.popupController setNavigationBarHidden:YES];
    [self.popupController presentInViewController:self];
}

#pragma mark 点击模态框遮罩层事件
- (void) tapAction
{
    [self.popupController dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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

- (UIView*)container
{
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 38)];
        _container.backgroundColor = [UIColor clearColor];
    }
    return _container;
}

- (UIImageView*)locationImageV
{
    if (!_locationImageV) {
        _locationImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 38)];
        [_locationImageV setImage:[UIImage imageNamed:@"zjdw"]];
    }
    return _locationImageV;
}

- (UIButton*)userImageButtonV
{
    if (!_userImageButtonV) {
        _userImageButtonV = [UIButton buttonWithType:UIButtonTypeCustom];
        _userImageButtonV.frame = CGRectMake(3.5, 3.5, 25, 25);
        _userImageButtonV.backgroundColor = [UIColor clearColor];
    }
    return _userImageButtonV;
}

- (UIImageView*)userImageV
{
    if (!_userImageV) {
        _userImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _userImageV.layer.cornerRadius = _userImageV.Witdh/2.0;
        _userImageV.layer.masksToBounds = YES;
    }
    return _userImageV;
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
        [_planeMapButton setImage:[UIImage imageNamed:@"ar_ARditu"] forState:UIControlStateNormal];
        [_arListButton addTarget:self action:@selector(toARFootprintListView) forControlEvents:UIControlEventTouchUpInside];
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
