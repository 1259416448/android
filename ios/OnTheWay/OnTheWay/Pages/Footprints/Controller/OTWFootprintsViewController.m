//
//  OTWFootprintsViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintsViewController.h"
#import "OTWFootprintListModel.h"
#import "OTWFootprintListFrame.h"
#import "OTWFootprintListTableViewCell.h"
#import "OTWFootprintDetailController.h"
#import "OTWPersonalFootprintsListController.h"
#import <MJRefresh.h>
#import "OTWUserModel.h"
#import "OTWCustomNavigationBar.h"
#import "OTWFootprintReleaseViewController.h"
#import "OTWPlaneMapViewController.h"
#import "OTWFootprintService.h"

#import "OTWFootprintsChangeAddressController.h"
#import "OTWFootprintsChangeAddressModel.h"
#import "OTWFootprintSearchParams.h"

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>
#import <MJExtension.h>

@interface OTWFootprintsViewController () <UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *footprintTableView;

@property(nonatomic,strong) UIButton *cameraButton;
@property(nonatomic,strong) UIButton *arButton;
@property(nonatomic,strong) UIButton *planeMapButton;

@property (nonatomic,strong) OTWFootprintSearchParams *footprintSearchParams;
@property (nonatomic,strong) BMKLocationService *locService;  //定位
@property (nonatomic,copy) BMKUserLocation *userLocation;
@property (nonatomic,assign) BOOL ifFirstLocation;
@property (nonatomic,strong) NSMutableArray<OTWFootprintListFrame *> *footprintTableData;
@property (nonatomic,strong) NSDictionary *reponseCacheData;

//第一次进入页面时，加载提示View
@property (nonatomic,strong) UIView *firstLoadingView;


@end

@implementation OTWFootprintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addReleasedFootprint:) name:@"releasedFoorprint" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedFootprint:) name:@"foorprintAlreadyDeleted" object:nil];
    [self initLocService];
    _ifFirstLocation = YES;
    // Do any additional setup after loading the view.
    self.customNavigationBar.leftButtonClicked = ^(){
        //这里直接回到上一个首页
        [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexFind];
    };
    [self buildUI];
}

- (void) addReleasedFootprint:(NSNotification*)sender
{
    //用户信息，当前用户
    OTWFootprintListModel *footprintDetail = [OTWFootprintListModel initWithDict:sender.userInfo];
    if(footprintDetail.footprintPhotoArray && footprintDetail.footprintPhotoArray.count>0){
        footprintDetail.footprintPhoto = footprintDetail.footprintPhotoArray[0];
    }
    footprintDetail.userId = [NSNumber numberWithInt:[[OTWUserModel shared].userId intValue]];
    footprintDetail.userHeadImg = [OTWUserModel shared].headImg;
    footprintDetail.userNickname = [OTWUserModel shared].name;
    OTWFootprintListFrame *footprintFrame = [[OTWFootprintListFrame alloc] init];
    [footprintFrame setFootprint:footprintDetail];
    [_footprintTableData insertObject:footprintFrame atIndex:0];
    [self.footprintTableView reloadData];
}


#pragma mark - 详情页面中发现有被删除的足迹
- (void) deletedFootprint:(NSNotification*)sender
{
    NSDictionary *dict = sender.userInfo;
    for (int i = 0; i<_footprintTableData.count; i++) {
        if([_footprintTableData[i].footprint.footprintId.description isEqualToString:dict[@"footprintId"]]){
            [_footprintTableData removeObjectAtIndex:i];
            [self.footprintTableView reloadData];
            break;
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"releasedFoorprint" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"foorprintAlreadyDeleted" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _locService.delegate = self;
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _locService.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;    //让rootView禁止滑动
    }
}

-(void)buildUI
{
    _footprintTableData = [[NSMutableArray alloc] init];
    
    //设置标题
    self.title = @"足迹列表";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //默认【下拉刷新】
    self.footprintTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullNewFootprints)];
    //默认【上拉加载】
    self.footprintTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFootprints:)];
    [self.view addSubview:self.footprintTableView];
    
    [self.view addSubview:self.cameraButton];
    
    [self.view addSubview:self.arButton];
    
    [self.view addSubview:self.planeMapButton];
    
    [self.view addSubview:self.firstLoadingView];
    
    [self.view bringSubviewToFront:self.customNavigationBar];
    
    
    self.footprintTableView.mj_footer.hidden = YES;
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self initCLLocationManager];
        if(_locService){
            _locService.delegate = nil;
            _locService = nil;
        }
        self.firstLoadingView.hidden = YES;
        return;
    }
    
    [_locService startUserLocationService];
}

- (void) initLocService{
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
}


-(OTWFootprintSearchParams *)footprintSearchParams
{
    if (!_footprintSearchParams) {
        _footprintSearchParams = [[OTWFootprintSearchParams alloc] init];
        //列表查询
        _footprintSearchParams.type = @"list";
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

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.footprintTableData.count;
}

#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
}
#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OTWFootprintDetailController *VC =  [[OTWFootprintDetailController alloc] init];
    [VC setFid:self.footprintTableData[indexPath.row].footprint.footprintId.description];
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark 返回第indexPath这行对应的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"OTWFootprintListTableViewCellStatus";
    OTWFootprintListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [OTWFootprintListTableViewCell cellWithTableView:tableView identifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    WeakSelf(self);
//    cell.tapOne = ^(NSString *opId){
//        OTWPersonalFootprintsListController *listVC = [[OTWPersonalFootprintsListController alloc] init];
//        //判断是否是当前用户，然后跳转
//        listVC.ifMyFootprint = [[OTWUserModel shared].userId.description isEqualToString:opId];
//        [weakself.navigationController pushViewController:listVC animated:YES];
//    };
    [cell setFootprintListFrame:self.footprintTableData[indexPath.row]];
    return cell;
}

-(UITableView*)footprintTableView{
    if(!_footprintTableView){
        _footprintTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationHeight - 20, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _footprintTableView.dataSource = self;
        _footprintTableView.delegate = self;
        _footprintTableView.separatorStyle  = UITableViewCellSelectionStyleNone;
        _footprintTableView.backgroundColor = [UIColor clearColor];
    }
    return _footprintTableView;
}

- (UIButton*)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.backgroundColor = [UIColor clearColor];
        CGFloat cameraButtonX = SCREEN_WIDTH - 50*3 - 15 - 7*2;
        CGFloat cameraButtonY = SCREEN_HEIGHT - 15*2 - 50;
        self.cameraButton.frame = CGRectMake(cameraButtonX, cameraButtonY, 50, 50);
        [_cameraButton setImage:[UIImage imageNamed:@"ar_fabu"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(toReleaseFootprintView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}
- (UIButton*)arButton
{
    if (!_arButton) {
        _arButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _arButton.backgroundColor = [UIColor clearColor];
        CGFloat arListButtonX = CGRectGetMaxX(self.cameraButton.frame) + 7;
        _arButton.frame = CGRectMake(arListButtonX, self.cameraButton.MinY, 50, 50);
        [_arButton setImage:[UIImage imageNamed:@"ar_ARditu"] forState:UIControlStateNormal];
        [_arButton addTarget:self action:@selector(toFootprintARView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arButton;
}

- (UIButton*)planeMapButton
{
    if (!_planeMapButton) {
        _planeMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _planeMapButton.backgroundColor = [UIColor clearColor];
        CGFloat planeMapButtonX = CGRectGetMaxX(self.arButton.frame) + 7;
        self.planeMapButton.frame = CGRectMake(planeMapButtonX, self.cameraButton.MinY, 50, 50);
        [_planeMapButton setImage:[UIImage imageNamed:@"ar_pingmian"] forState:UIControlStateNormal];
        [_planeMapButton addTarget:self action:@selector(planeMapButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _planeMapButton;
}

#pragma mark 跳转至足迹列表页面
- (void)toFootprintARView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark 跳转至足迹发布页面
- (void)toReleaseFootprintView
{
    if(![[OTWLaunchManager sharedManager] showLoginViewWithController:self completion:nil]){
        OTWFootprintReleaseViewController *releaseVC = [[OTWFootprintReleaseViewController alloc] init];
        [self.navigationController pushViewController:releaseVC animated:YES];
    };
}

-(void)planeMapButtonClick
{
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    NSUInteger index = [viewControllers indexOfObject:[OTWLaunchManager sharedManager].footprintPlaneMapVC];
//    if(index != NSNotFound){
//        [self.navigationController popToViewController:[OTWLaunchManager sharedManager].footprintPlaneMapVC animated:NO];
//    }else{
//        [self.navigationController pushViewController:[OTWLaunchManager sharedManager].footprintPlaneMapVC animated:NO];
//    }
}

-(void)loadMoreFootprints:(BOOL)reflesh
{
    NSDictionary *footprintSearchParamsDict = self.footprintSearchParams.mj_keyValues;
    [self fetchFootprints:footprintSearchParamsDict completion:^(id result) {
        NSDictionary *body = result[@"body"];
        self.footprintSearchParams.currentTime = result[@"currentTime"];
        NSArray *array = body[@"content"];
        if(array && array.count>0){
            if(reflesh){
                [_footprintTableData removeAllObjects];
            }
            for (NSDictionary *dict in array) {
                OTWFootprintListModel *footprintModel = [OTWFootprintListModel mj_objectWithKeyValues:dict];
                OTWFootprintListFrame *footprintFrame = [[OTWFootprintListFrame alloc] init];
                [footprintFrame setFootprint:footprintModel];
                [_footprintTableData addObject:footprintFrame];
            }
            [self.footprintTableView reloadData];
            if(array.count < self.footprintSearchParams.size){
                [self.footprintTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.footprintSearchParams.number += 1;
                [self.footprintTableView.mj_footer endRefreshing];
            }
        }else{
            [self.footprintTableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.footprintTableView.mj_footer.hidden = NO;
        [self.footprintTableView.mj_header endRefreshing];
        self.firstLoadingView.hidden = YES;
    }];
}

-(void)pullNewFootprints
{
    self.firstLoadingView.hidden = YES;
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self initCLLocationManager];
        [self.footprintTableView.mj_header endRefreshing];
        if(_locService){
            _locService.delegate = nil;
            _locService = nil;
        }
        return;
    }
    
    //没有定位信息
    if(!_locService){
        [self initLocService];
    }
    
    _ifFirstLocation = YES;
    [_locService startUserLocationService];
//    self.footprintSearchParams.number = 0;
//    self.footprintSearchParams.currentTime = nil;
//    [self loadMoreFootprints:YES];
    [self.footprintTableView.mj_footer endRefreshing];
    self.footprintTableView.mj_footer.hidden = YES;
}

-(void)fetchFootprints:(NSDictionary *)params completion:(requestBackBlock)block
{

    [OTWFootprintService getFootprintList:params completion:^(id result, NSError *error) {
        if (result) {
            if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
                if (block) {
                    block(result);
                }
            }else{
                [self errorTips:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO];
                [self.footprintTableView.mj_footer endRefreshing];
                [self.footprintTableView.mj_header endRefreshing];
                if(self.reponseCacheData){
                    if (block) {
                        block(self.reponseCacheData);
                    }
                }
                self.firstLoadingView.hidden = YES;
            }
        }else{
            self.firstLoadingView.hidden = YES;
            [self netWorkErrorTips:error];
            [self.footprintTableView.mj_footer endRefreshing];
            [self.footprintTableView.mj_header endRefreshing];
            if(self.reponseCacheData){
                if (block) {
                    block(self.reponseCacheData);
                }
            }
        }
    } responseCache:^(id reponseCache){
        //[self errorTips:@"网络错误" userInteractionEnabled:YES];
        self.reponseCacheData = reponseCache;
//        if (block) {
//            block(reponseCache);
//        }
    }];
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    DLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _userLocation = userLocation;
    _ifFirstLocation = NO;
    //定位信息加载成功，一般刷新时会调用
    self.footprintSearchParams.latitude = userLocation.location.coordinate.latitude;
    self.footprintSearchParams.longitude = userLocation.location.coordinate.longitude;
    self.footprintSearchParams.number = 0;
    self.footprintSearchParams.currentTime = nil;
    [self loadMoreFootprints:YES];
    [_locService stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [self errorTips:@"定位信息获取失败" userInteractionEnabled:YES];
    [self.footprintTableView.mj_footer endRefreshingWithNoMoreData];
    [self.footprintTableView.mj_header endRefreshing];
    [_locService stopUserLocationService];
}

- (UIView *) firstLoadingView
{
    if(!_firstLoadingView){
        _firstLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, 50)];
        _firstLoadingView.backgroundColor = [UIColor clearColor];
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 15, 0, 30, 30)];
        [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [indicatorView startAnimating];
        [_firstLoadingView addSubview:indicatorView];
    }
    return _firstLoadingView;
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

#pragma marks -- UIAlertViewDelegate --
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

@end
