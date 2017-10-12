//
//  OTWARShopViewController.m
//  OnTheWay
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessARViewController.h"
#import "ArvixARConfiguration.h"
#import "ArvixARAnnotation.h"
#import "OTWBusinessARAnnotation.h"
#import "ArvixARAnnotationView.h"
#import "ArvixARViewController.h"
#import "OTWPlaneMapViewController.h"

#import "OTWBusinessARAnnotationView.h"
#import "OTWFootprintSearchParams.h"
#import "OTWFootprintsChangeAddressController.h"
#import "OTWFootprintReleaseViewController.h"
#import "OTWFootprintsViewController.h"
#import "OTWARShopService.h"
#import "OTWUITapGestureRecognizer.h"
#import "OTWBusinessARAnnotationFrame.h"
#import "OTWBusinessDetailViewController.h"
#import "OTWBusinessARSiftTableViewCell.h"
#import "OTWBusinessARSiftDetailTableViewCell.h"
#import "OTWBusinessSortModel.h"
#import "OTWBusinessDetailSortModel.h"

#import <MJExtension.h>
#import "MBProgressHUD+PYExtension.h"
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>

@interface OTWBusinessARViewController ()<ArvixARDataSource,UIAlertViewDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>


@property(nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) UIButton *refreshButton;
@property(nonatomic,strong) UIButton *locationButton;
@property(nonatomic,strong) UIButton *cameraButton;
@property(nonatomic,strong) UIButton *arListButton;
@property(nonatomic,strong) UIButton *planeMapButton;
@property(nonatomic,strong) UIButton *siftButton;
@property(nonatomic,strong) UIButton *searchButton;
@property(nonatomic,strong) UIButton *cancelButton;

@property(nonatomic,strong) UIView *siftView;

@property(nonatomic,strong) UIView *searchView;

@property(nonatomic,strong) UITableView *siftSortTableView;
@property(nonatomic,strong) UITableView *siftDetailTableView;

@property(nonatomic,strong) UIButton *locationBtton_100m;
@property(nonatomic,strong) UIButton *locationBtton_500m;
@property(nonatomic,strong) UIButton *locationBtton_1000m;

@property(nonatomic,strong) UIView *shopPopoverV;
@property(nonatomic,strong) UILabel *shopTitle;
@property(nonatomic,strong) UIImageView *gotoV;
@property(nonatomic,strong) UILabel *gotoLabel;
@property(nonatomic,strong) UIImageView *shopLocationIcon;
@property(nonatomic,strong) UILabel *shopLocationContent;
@property(nonatomic,strong) UIImageView *telePhoneIcon;
@property(nonatomic,strong) UILabel *telePhoneNum;
@property(nonatomic,strong) UIButton *viewShopDetail;


@property(nonatomic,strong) UIView *infoBGView;
@property(nonatomic,strong) UILabel *footprintLabel;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UILabel *footprintSumLabel;
@property(nonatomic,strong) UIImageView *addressImageView;
@property(nonatomic,strong) UIImage *addressImage;
@property(nonatomic,strong) UILabel *addressLabel;

@property(nonatomic,strong) NSString *businessId;

@property(nonatomic,strong) NSIndexPath *selectedIndexPath;


//查询对象
@property (nonatomic,strong) OTWFootprintSearchParams *arShopSearchParams;
@property (nonatomic,strong) NSDictionary *reponseCacheData;

@property (nonatomic,assign) BOOL ifFirstLoadData;

//经纬度反解码
@property (nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;

//筛选分类数据
@property(nonatomic,strong) NSMutableArray *siftSortArr;
@property(nonatomic,strong) NSMutableArray *siftDetailArr;


@end

@implementation OTWBusinessARViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _siftSortArr = @[].mutableCopy;
    _siftDetailArr = @[].mutableCopy;
    [self getbusinessSortData];
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
    
    //筛选按钮
    [self.view insertSubview:self.siftButton aboveSubview:self.presenter];
//    [self.view bringSubviewToFront:self.siftButton];
    
    //搜索按钮
    
    //筛选view

    [self.view insertSubview:self.siftView aboveSubview:self.presenter];
    [self.siftView addSubview:self.searchView];
    [self.siftView addSubview:self.cancelButton];
    [self.siftView addSubview:self.siftSortTableView];
    [self.siftView addSubview:self.siftDetailTableView];
    
    //刷新
    OTWUITapGestureRecognizer *refreshTapGesture=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshFootprints)];
    [self.refreshButton addGestureRecognizer:refreshTapGesture];
    [self.view insertSubview:self.refreshButton aboveSubview:self.presenter];
    
    //定位
    CGFloat locationButtonX = SCREEN_WIDTH - 35 - 15;
    CGFloat locationButtonY = CGRectGetMaxY(self.refreshButton.frame) + 10;
    self.locationButton.frame = CGRectMake(locationButtonX, locationButtonY, 35, 35);
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
    
    //距离筛选-100米内
    CGFloat locationBtton_100mX = CGRectGetMaxX(self.refreshButton.frame) - 45*3 - 5*3 - 35;
    self.locationBtton_100m.frame = CGRectMake(locationBtton_100mX, locationButtonY, 45, 35);
    [self.view insertSubview:self.locationBtton_100m aboveSubview:self.presenter];
    
    //距离筛选-500米内
    CGFloat locationBtton_500mX = CGRectGetMaxX(self.refreshButton.frame) - 45*2 - 5*2 - 35;
    self.locationBtton_500m.frame = CGRectMake(locationBtton_500mX, locationButtonY, 45, 35);
    [self.view insertSubview:self.locationBtton_500m aboveSubview:self.presenter];
    
    //距离筛选-1000米内
    CGFloat locationBtton_1000mX = CGRectGetMaxX(self.refreshButton.frame) - 45 - 5 - 35;
    self.locationBtton_1000m.frame = CGRectMake(locationBtton_1000mX, locationButtonY, 45, 35);
    [self.view insertSubview:self.locationBtton_1000m aboveSubview:self.presenter];
    
    
    
    
    
    //附近足迹总信息
    [self.view insertSubview:self.infoBGView aboveSubview:self.presenter];
    [self.infoBGView addSubview:self.footprintLabel];
    [self.infoBGView addSubview:self.lineView];
    [self.infoBGView addSubview:self.footprintSumLabel];
    [self.infoBGView addSubview:self.addressImageView];
    [self.infoBGView addSubview:self.addressLabel];
    [self.view insertSubview:self.shopPopoverV aboveSubview:self.presenter];
    
    
    //刷新
    OTWUITapGestureRecognizer *changeShopDetailVGesture=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBusinessSimpleInfo)];
    [self.presenter addGestureRecognizer:changeShopDetailVGesture];
    [self.shopPopoverV addSubview:self.shopTitle];
    [self.shopPopoverV addSubview:self.gotoV];
    [self.shopPopoverV addSubview:self.gotoLabel];
    [self.shopPopoverV addSubview:self.shopLocationIcon];
    [self.shopPopoverV addSubview:self.shopLocationContent];
    [self.shopPopoverV addSubview:self.telePhoneIcon];
    [self.shopPopoverV addSubview:self.telePhoneNum];
    [self.shopPopoverV addSubview:self.viewShopDetail];

    
}

#pragma mark tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _siftSortTableView) {
        return _siftSortArr.count;
    }else if (tableView == _siftDetailTableView)
    {
        NSInteger count = 0;
        for (OTWBusinessSortModel * model in _siftSortArr) {
            if (model.selected) {
                count = model.children.count;
            }
        }
        return count;
    }else
    {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _siftSortTableView) {
        static NSString *flag=@"OTWBusinessARSiftTableViewCell";
        OTWBusinessARSiftTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell == nil) {
            cell=[[OTWBusinessARSiftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        OTWBusinessSortModel * model = _siftSortArr[indexPath.row];
        cell.titleLabel.text = model.name;
        if (model.selected) {
            cell.backgroundColor = [UIColor color_f4f4f4];
            cell.titleLabel.textColor = [UIColor colorWithHexString:model.colorCode];
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.textColor = [UIColor color_202020];
        }
        return cell;
    }else if (tableView == _siftDetailTableView)
    {
        static NSString *flag=@"OTWBusinessARSiftDetailTableViewCell";
        OTWBusinessARSiftDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell == nil) {
            cell=[[OTWBusinessARSiftDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        for (OTWBusinessSortModel * model in _siftSortArr) {
            if (model.selected) {
                OTWBusinessDetailSortModel * detailModel = model.children[indexPath.row];
                cell.titleLabel.text = detailModel.name;
                if (detailModel.selected) {
                    cell.selectedImg.hidden = NO;
                }else
                {
                    cell.selectedImg.hidden = YES;
                }
            }
        }
        return cell;
    }else
    {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _siftSortTableView) {
        for (OTWBusinessSortModel * model in _siftSortArr) {
            model.selected = NO;
        }
        OTWBusinessSortModel * model = _siftSortArr[indexPath.row];
        model.selected = YES;
        [_siftSortTableView reloadData];
        [_siftDetailTableView reloadData];
    }else if (tableView == _siftDetailTableView)
    {
        self.arShopSearchParams.number = 0;
        for (OTWBusinessSortModel * models in _siftSortArr) {
            for (OTWBusinessDetailSortModel * result in models.children) {
                result.selected = NO;
            }
        }
        for (OTWBusinessSortModel * model in _siftSortArr) {
            if (model.selected) {
                if (indexPath.row == 0) {
                    self.arShopSearchParams.typeIds = [NSString stringWithFormat:@"%@",model.typeId];
                    OTWBusinessDetailSortModel * detailModel = model.children[0];
                    detailModel.selected = !detailModel.selected;
                    for (OTWBusinessDetailSortModel * result in model.children) {
                        result.selected = detailModel.selected;
                    }
                    
                }else{
                    OTWBusinessDetailSortModel * detailModel = model.children[indexPath.row];
                    self.arShopSearchParams.typeIds = [NSString stringWithFormat:@"%@,%@",model.typeId,detailModel.typeId];
                    detailModel.selected = YES;
                }
//                [self startPoiSearch];
                [self getArShops];
            }
        }
        [_siftSortTableView reloadData];
        [_siftDetailTableView reloadData];
        _siftView.hidden = YES;
    }else{
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
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
    [self hideBusinessSimpleInfo];
    [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexFind]; // 显示首页
}

/**
 * 显示简要信息展示
 */
- (void)showBusinessSimpleInfo:(NSNumber *) businessId
{
    self.shopPopoverV.hidden = NO;
    self.radar.hidden = YES;
    self.businessId = businessId.description;
    
    for (OTWBusinessARAnnotation *annotation in self.annotations) {
        OTWBusinessARAnnotationView *annotationView = (OTWBusinessARAnnotationView *) annotation.annotationView;
        if([annotation.businessFrame.businessDetail.businessId isEqualToNumber:businessId]){
            annotation.businessFrame.colorAlpha = 1;
            annotation.businessFrame.distanceAlpha = 1;
        }else{
            annotation.businessFrame.colorAlpha = 0.5;
            annotation.businessFrame.distanceAlpha = 0.5;
        }
        [annotationView setShopColorVBackGroup];
    }
}

/**
 * 隐藏简要信息展示
 */
- (void) hideBusinessSimpleInfo
{
    self.shopPopoverV.hidden = YES;
    self.radar.hidden = NO;
    self.businessId = nil;
    for (OTWBusinessARAnnotation *annotation in self.annotations) {
        OTWBusinessARAnnotationView *annotationView = (OTWBusinessARAnnotationView *) annotation.annotationView;
        annotation.businessFrame.colorAlpha = 0.85;
        annotation.businessFrame.distanceAlpha = 1;
        [annotationView setShopColorVBackGroup];
    }
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
    self.locationBtton_100m.hidden = YES;
    self.locationBtton_500m.hidden = YES;
    self.locationBtton_1000m.hidden = YES;
}

- (void)planeMapButtonClick
{
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    NSUInteger index = [viewControllers indexOfObject:[OTWLaunchManager sharedManager].footprintPlaneMapVC];
//    if(index != NSNotFound){
//        [self.navigationController popToViewController:[OTWLaunchManager sharedManager].footprintPlaneMapVC animated:NO];
//    }else{
//        [self.navigationController pushViewController:[OTWLaunchManager sharedManager].footprintPlaneMapVC animated:NO];
//    }
}
/**
 * 筛选
 */
- (void)siftButtonClick
{
    _siftView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    _siftView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 415);
    [UIView commitAnimations];

}
/**
 * 搜索商家
 */
- (void)toSearchBusiness
{
//    _siftView.hidden = YES;
}
- (void)cancelButtonClick
{
    [UIView beginAnimations:nil context:nil];
    _siftView.frame = CGRectMake(0, -415, SCREEN_WIDTH, 415);
    [UIView commitAnimations];
    _siftView.hidden = YES;
}

#pragma mark 刷新-换一批足迹
- (void)refreshFootprints
{
    [self hideBusinessSimpleInfo];
    [self hideAllButton];
    [self getArShops];
}

#pragma mark 根据距离筛选
- (void)searchByDistance:(OTWUITapGestureRecognizer*)tapGesture
{
    [self hideBusinessSimpleInfo];
    NSMutableDictionary *condition = tapGesture.opId;
    self.arShopSearchParams.searchDistance = [condition objectForKey:@"searchParamValue"];
    self.arShopSearchParams.number = 0;
    if([self.arShopSearchParams.searchDistance isEqualToString:@"one"]){
        self.radar.maxDistance = 100;
        self.arShopSearchParams.distance = @"0.1";
    }else if([self.arShopSearchParams.searchDistance isEqualToString:@"two"]){
        self.radar.maxDistance = 500;
        self.arShopSearchParams.distance = @"0.5";
    }else if([self.arShopSearchParams.searchDistance isEqualToString:@"three"]){
        self.radar.maxDistance = 1000;
        self.arShopSearchParams.distance = @"1";
    }
    [self locationButtonClick];
    [self getArShops];
}



#pragma mark 跳转至商家列表页面
- (void)toFootprintListView
{
    [OTWLaunchManager sharedManager].FindBusinessmenVC.latitude = self.arShopSearchParams.latitude;
    [OTWLaunchManager sharedManager].FindBusinessmenVC.longitude = self.arShopSearchParams.longitude;
    [OTWLaunchManager sharedManager].FindBusinessmenVC.isFromAR = YES;

    //获取当前push View
    NSArray *viewController = self.navigationController.viewControllers;
    //检查 footprintVC 是否在 队列中
    NSUInteger index = [viewController indexOfObject:[OTWLaunchManager sharedManager].FindBusinessmenVC];
    if(index != NSNotFound){ //存在
        [self.navigationController popToViewController:[OTWLaunchManager sharedManager].FindBusinessmenVC animated:NO];
    }else{ //不存在
        [self.navigationController pushViewController:[OTWLaunchManager sharedManager].FindBusinessmenVC animated:NO];
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
-(OTWFootprintSearchParams *)arShopSearchParams
{
    if (!_arShopSearchParams) {
        _arShopSearchParams = [[OTWFootprintSearchParams alloc] init];
        //列表查询
        _arShopSearchParams.type = @"ar";
        //默认搜索半径为1公里
        _arShopSearchParams.searchDistance = @"three";
        //默认当前页为 0
        _arShopSearchParams.number = 0;
        //默认每页大小为 15
        _arShopSearchParams.size = 30;
        //默认不是最后一页
        _arShopSearchParams.isLastPage = NO;
        //默认是第一页
        _arShopSearchParams.isFirstPage = YES;
    }
    
    return _arShopSearchParams;
}

-(void)fetchARShops:(NSDictionary *)params completion:(requestBackBlock)block
{
    MBProgressHUD *hud = [self addLoadingHud];
    DLog(@"查询参数：%@",params);
    [OTWARShopService getARShopList:params completion:^(id result, NSError *error) {
        
        [hud hideAnimated:YES];
        
        if (result) {
            if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
                if (block) {
                    self.arShopSearchParams.currentTime = result[@"currentTime"];
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
#pragma mark 获取店家分类信息

- (void)getbusinessSortData
{
    NSString * url = @"/app/business/type/all";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [OTWNetworkManager doGET:url parameters:nil responseCache:^(id responseCache) {
            if([[NSString stringWithFormat:@"%@",responseCache[@"code"]] isEqualToString:@"0"]){
                NSArray *arr = [NSArray arrayWithArray:[responseCache objectForKey:@"body"]];
                for (NSDictionary *result in arr)
                {
                    OTWBusinessSortModel * model = [OTWBusinessSortModel mj_objectWithKeyValues:result];
                    model.selected = NO;
                    [_siftSortArr addObject:model];
                }
                [self reloadTableView];
            }
        } success:^(id responseObject) {
            if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
                [_siftSortArr removeAllObjects];
                NSArray *arr = [NSArray arrayWithArray:[responseObject objectForKey:@"body"]];
                
                for (NSDictionary *result in arr)
                {
                    OTWBusinessSortModel * model = [OTWBusinessSortModel mj_objectWithKeyValues:result];
                    model.selected = NO;
                    [_siftSortArr addObject:model];
                }
                [self reloadTableView];
            }
        } failure:^(NSError *error) {
            
        }];
    });
    
}
- (void)reloadTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        OTWBusinessSortModel * model = _siftSortArr[0];
        model.selected = YES;
        for (OTWBusinessSortModel * result in _siftSortArr) {
            OTWBusinessDetailSortModel * resultModel = [[OTWBusinessDetailSortModel alloc] init];
            resultModel.name = @"全部";
            resultModel.selected = NO;
            [result.children insertObject:resultModel atIndex:0];
        }
        [_siftSortTableView reloadData];
        [_siftDetailTableView reloadData];
    });
}

#pragma mark 根据查询参数加载足迹数据
- (void)getArShops
{
    [self fetchARShops:self.arShopSearchParams.mj_keyValues completion:^(id result) {
        
        if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
            //最后一页
            if ([[NSString stringWithFormat:@"%@",result[@"body"][@"last"]] isEqualToString:@"1"]) {
                self.arShopSearchParams.isLastPage = YES;
                self.arShopSearchParams.number  = 0;
                //提示，判断是否是第一页
                if([[NSString stringWithFormat:@"%@",result[@"body"][@"first"]] isEqualToString:@"0"]){
                    [self errorTips:@"已经是最后一批信息，再次点击会循环展示" userInteractionEnabled:NO];
                }
            } else {
                self.arShopSearchParams.number += 1;
            }
            if ([[NSString stringWithFormat:@"%@",result[@"body"][@"first"]] isEqualToString:@"true"]) {
                self.arShopSearchParams.isFirstPage = YES;
            }
            DLog(@"商店列表:%@",result[@"body"][@"content"]);
            
            NSMutableArray *arShopModels = [OTWBusinessModel mj_objectArrayWithKeyValuesArray:result[@"body"][@"content"]];
            if (arShopModels.count == 0) {
                [self MBProgressHUDErrorTips:@"抱歉，未找到结果"];
                [self setAnnotations:@[]];
            }else{
                NSArray *dummyAnnotations = [self assembleAnnotation:arShopModels];
                [self setAnnotations:dummyAnnotations];
            }
            NSNumber * shopsNum = result[@"body"][@"totalElements"];
            if (shopsNum.integerValue > 100) {
                self.footprintSumLabel.text = @"99+";
            }else{
                self.footprintSumLabel.text = [NSString stringWithFormat:@"%@",shopsNum];
            }
        }else{
            [self errorTips:@"服务端繁忙，请稍后再试" userInteractionEnabled:YES];
        }
    }];
}
- (void)MBProgressHUDErrorTips:(NSString *)error{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = error;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    [hud hideAnimated:YES afterDelay:2];
}

#pragma mark 组装足迹annotation
- (NSArray*)assembleAnnotation:(NSMutableArray<OTWBusinessModel*>*)arShops
{
    double altitudeDelta = 0;
    NSMutableArray *annotations = [NSMutableArray array];
    for (OTWBusinessModel *shop in arShops) {
        
        OTWBusinessARAnnotationFrame *businessFrame = [OTWBusinessARAnnotationFrame initWithBusinessDetail:shop];
        
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(shop.latitude, shop.longitude) altitude:altitudeDelta horizontalAccuracy:1 verticalAccuracy:1 timestamp:[NSDate date]];
        OTWBusinessARAnnotation *annotation = [[OTWBusinessARAnnotation alloc] init];
        annotation.businessFrame = businessFrame;
        annotation.location = location;
        annotation.colorCode = shop.colorCode;
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

#pragma mark 跳转到商家详情
-(void)showShopDetail:(OTWUITapGestureRecognizer*)gesture
{
    OTWBusinessARAnnotation *annotation = gesture.opId;
    [self showBusinessSimpleInfo:annotation.businessFrame.businessDetail.businessId];
    self.shopTitle.text = annotation.businessFrame.businessDetail.name;
    self.shopLocationContent.text = annotation.businessFrame.businessDetail.address;
    self.businessId = annotation.businessFrame.businessDetail.businessId.description;
    if (annotation.businessFrame.businessDetail.contactInfo && ![annotation.businessFrame.businessDetail.contactInfo isEqualToString:@""]) {
        self.telePhoneIcon.hidden = NO;
        self.telePhoneNum.hidden = NO;
        self.telePhoneNum.text = annotation.businessFrame.businessDetail.contactInfo;
    } else {
        self.telePhoneIcon.hidden = YES;
        self.telePhoneNum.hidden = YES;
    }
}

#pragma mark - ArvixARDatasource
- (ArvixARAnnotationView*)ar:(ArvixARViewController*)arViewController viewForAnnotation:(ArvixARAnnotation*)annotation
{
    OTWBusinessARAnnotationView *annotationView = [[OTWBusinessARAnnotationView alloc] init];
    OTWBusinessARAnnotation *businessAnnotation =(OTWBusinessARAnnotation *)annotation;
    annotationView.frame = CGRectMake(0, 0,businessAnnotation.businessFrame.annotationW, 35);
    OTWUITapGestureRecognizer *tapGesture=[[OTWUITapGestureRecognizer alloc]initWithTarget:self action:@selector(showShopDetail:)];
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
        CGFloat refreshButtonY = SCREEN_HEIGHT - 150 - 35;
        _refreshButton.frame = CGRectMake(refreshButtonX, refreshButtonY, 35, 35);
        _refreshButton.backgroundColor = [UIColor clearColor];
        [_refreshButton setImage:[UIImage imageNamed:@"ar_huanyipi"] forState:UIControlStateNormal];
    }
    return _refreshButton;
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
- (UIButton *)siftButton
{
    if (!_siftButton) {
        _siftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _siftButton.frame = CGRectMake(SCREEN_WIDTH - 50, 25, 35, 35);
        _siftButton.backgroundColor = [UIColor clearColor];
        [_siftButton setImage:[UIImage imageNamed:@"ar_shaixuan_1"] forState:UIControlStateNormal];
        [_siftButton addTarget:self action:@selector(siftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _siftButton;
}

- (UIView *)siftView
{
    if (!_siftView) {
        _siftView = [[UIView alloc] initWithFrame:CGRectMake(0, -415, SCREEN_WIDTH, 415)];
        _siftView.backgroundColor = [UIColor whiteColor];
        //        _siftView.userInteractionEnabled = YES;
        _siftView.hidden = YES;
    }
    return _siftView;
}

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = ({
            UIView * View = [[UIView alloc] initWithFrame:CGRectMake(15, 25.5, SCREEN_WIDTH - 77, 33)];
            View.backgroundColor = [UIColor color_f4f4f4];
            View.layer.masksToBounds = YES;
            View.layer.cornerRadius = 15;
            UIImageView * search = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 15, 15)];
            search.image = [UIImage imageNamed:@"sousuo_1"];
            [View addSubview:search];
            UILabel * tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(search.frame) + 10, 0, 150, 33)];
            tipsLabel.backgroundColor = [UIColor clearColor];
            tipsLabel.font = [UIFont systemFontOfSize:14];
            tipsLabel.textColor = [UIColor color_979797];
            tipsLabel.text = @"搜索附近的美食、商城";
            [View addSubview:tipsLabel];
            tipsLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSearchBusiness)];
            tap.delegate = self;
            [tipsLabel addGestureRecognizer:tap];
            View;
        });

    }
    return _searchView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(SCREEN_WIDTH - 35, 32, 20, 20);
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton setImage:[UIImage imageNamed:@"ar_guanbi"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UITableView *)siftSortTableView
{
    if (!_siftSortTableView) {
        _siftSortTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH * 0.32, 351) style:UITableViewStylePlain];
        _siftSortTableView.delegate = self;
        _siftSortTableView.dataSource = self;
        _siftSortTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _siftSortTableView.backgroundColor = [UIColor whiteColor];
        UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.32, 44)];
        headView.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.32, 43.5)];
        label.text = @"全部分类";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor color_202020];
        label.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:label];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH * 0.32, 0.5)];
        line.backgroundColor = [UIColor color_d5d5d5];
        [headView addSubview:line];
        _siftSortTableView.tableHeaderView = headView;
    }
    return _siftSortTableView;
}

- (UITableView *)siftDetailTableView
{
    if (!_siftDetailTableView) {
        _siftDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.32, 64, SCREEN_WIDTH * 0.68, 351) style:UITableViewStylePlain];
        _siftDetailTableView.delegate = self;
        _siftDetailTableView.dataSource = self;
        _siftDetailTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _siftDetailTableView.backgroundColor = [UIColor color_f4f4f4];
    }
    return _siftDetailTableView;
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

- (UIView*)shopPopoverV
{
    if (!_shopPopoverV) {
        _shopPopoverV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 130, SCREEN_WIDTH, 130)];
        _shopPopoverV.backgroundColor = [UIColor whiteColor];
        _shopPopoverV.hidden = YES;
        //设置一个上阴影
        _shopPopoverV.layer.shadowOffset = CGSizeMake(0, -1);
        _shopPopoverV.layer.shadowOpacity = 0.3;
        _shopPopoverV.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    return _shopPopoverV;
}

- (UILabel*)shopTitle
{
    if (!_shopTitle) {
        _shopTitle = [[UILabel alloc] init];
        _shopTitle.textColor = [UIColor color_202020];
        [_shopTitle setFont:[UIFont systemFontOfSize:17.0]];
        CGFloat W = SCREEN_WIDTH - 15 - 10 - 15*2 - 7.5 - 20 - 21.5 - 10;
        _shopTitle.text = @"海底捞(白家庄店)";
        _shopTitle.frame = CGRectMake(15, 15, W, 18);
    }
    return _shopTitle;
}

- (UIImageView*)gotoV
{
    if (!_gotoV) {
        _gotoV = [[UIImageView alloc] init];
        CGFloat X = SCREEN_WIDTH - 21.5 - 20;
        _gotoV.frame = CGRectMake(X, 15, 20, 20);
        [_gotoV setImage:[UIImage imageNamed:@"daohang"]];
    }
    return _gotoV;
}

- (UILabel*)gotoLabel
{
    if (!_gotoLabel) {
        CGFloat X = SCREEN_WIDTH - 35 - 15;
        _gotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetMaxY(self.gotoV.frame) + 5, 35, 12)];
        _gotoLabel.textColor = [UIColor color_979797];
        [_gotoLabel setFont:[UIFont systemFontOfSize:11.0]];
        _gotoLabel.textAlignment = NSTextAlignmentCenter;
        _gotoLabel.text = @"到这去";
    }
    return _gotoLabel;
}

- (UIImageView*)shopLocationIcon
{
    if (!_shopLocationIcon) {
        _shopLocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.shopTitle.frame)+11, 10, 10)];
        [_shopLocationIcon setImage:[UIImage imageNamed:@"dingwei"]];
    }
    return _shopLocationIcon;
}

- (UIButton*)viewShopDetail
{
    if (!_viewShopDetail) {
        _viewShopDetail = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewShopDetail.frame = CGRectMake(0, 92, SCREEN_WIDTH, 38.5);
        _viewShopDetail.backgroundColor = [UIColor color_f4f4f4];
        _viewShopDetail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _viewShopDetail.titleLabel.font = [UIFont systemFontOfSize:13];
        [_viewShopDetail setTitle:@"查看商户更多信息" forState:UIControlStateNormal];
        [_viewShopDetail setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
        [_viewShopDetail addTarget:self action:@selector(viewBusinessDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewShopDetail;
}

- (UILabel*)shopLocationContent
{
    if (!_shopLocationContent) {
        _shopLocationContent = [[UILabel alloc] init];
        _shopLocationContent.textColor = [UIColor color_979797];
        [_shopLocationContent setFont:[UIFont systemFontOfSize:13.0]];
        CGFloat X = CGRectGetMaxX(self.shopLocationIcon.frame) + 5;
        CGFloat Y = CGRectGetMaxY(self.shopTitle.frame) + 10;
        CGFloat W = SCREEN_WIDTH - CGRectGetMaxX(self.shopLocationIcon.frame) - 5 - 15*2 - 35 - 15;
        _shopLocationContent.frame = CGRectMake(X, Y, W, 12);
        _shopLocationContent.text = @"东城区东直门内大街233号";
    }
    return _shopLocationContent;
}

- (UIImageView*)telePhoneIcon
{
    if (!_telePhoneIcon) {
        _telePhoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.shopLocationIcon.frame)+7, 10, 10)];
        [_telePhoneIcon setImage:[UIImage imageNamed:@"ar_dianhua"]];
    }
    return _telePhoneIcon;
}

- (UILabel*)telePhoneNum
{
    if (!_telePhoneNum) {
        _telePhoneNum = [[UILabel alloc] init];
        _telePhoneNum.textColor = [UIColor color_979797];
        [_telePhoneNum setFont:[UIFont systemFontOfSize:13.0]];
        CGFloat X = CGRectGetMaxX(self.telePhoneIcon.frame) + 5;
        CGFloat Y = CGRectGetMaxY(self.shopLocationContent.frame) + 5;
        _telePhoneNum.frame = CGRectMake(X, Y, 120, 12);
        _telePhoneNum.text = @"010-3456776";
    }
    return _telePhoneNum;
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
        _footprintLabel.text = @"附近商家";
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

/**
 * 跳转到商家详情页面
 */
- (void) viewBusinessDetail
{
    self.trackingManager.stopLocation = YES;
    OTWBusinessDetailViewController *businessVC = [[OTWBusinessDetailViewController alloc] init];
    [businessVC setOpData:self.businessId];
    [self.navigationController pushViewController:businessVC animated:YES];
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
        self.arShopSearchParams.latitude = location.coordinate.latitude;
        self.arShopSearchParams.longitude = location.coordinate.longitude;
        self.arShopSearchParams.number = 0;
        self.arShopSearchParams.currentTime = nil;
        [self getArShops];
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
        self.arShopSearchParams.latitude = location.coordinate.latitude;
        self.arShopSearchParams.longitude = location.coordinate.longitude;
        self.arShopSearchParams.number = 0;
        self.arShopSearchParams.currentTime = nil;
        [self getArShops];
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
