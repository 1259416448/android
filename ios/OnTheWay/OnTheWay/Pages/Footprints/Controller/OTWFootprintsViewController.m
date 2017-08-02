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

@interface OTWFootprintsViewController () <UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,strong) UITableView *footprintTableView;
@property (nonatomic,strong) NSMutableArray<OTWFootprintListFrame *> *footprintFrames;
@property (nonatomic,strong) UIView * ARdituImageView;
@property (nonatomic,strong) UIView * fabuImageView;
@property (nonatomic,strong) UIView * pingmianImageView;

@property (nonatomic,strong) OTWFootprintChangeAddressArrayModel *defaultChooseModel;
@property (nonatomic,strong) OTWFootprintSearchParams *footprintSearchParams;
@property (nonatomic,strong) BMKLocationService *locService;  //定位
@property (nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic,copy) BMKUserLocation *userLocation;
@property (nonatomic,assign) BOOL ifFirstLocation;

@property (nonatomic,strong) NSMutableArray *footprints;
@property (nonatomic,assign) BOOL isFirstSearch;

@end

@implementation OTWFootprintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullNotice) name:@"newRelease" object:nil];
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    [_locService startUserLocationService];
    _ifFirstLocation = YES;
    _isFirstSearch = YES;
    // Do any additional setup after loading the view.
    self.customNavigationBar.leftButtonClicked = ^(){
        //这里直接回到上一个首页
        [[OTWLaunchManager sharedManager].mainTabController didSelectedItemByIndex:0];
    };
    self.footprints = [NSMutableArray new];
    [self buildUI];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

-(void)buildUI
{
    //设置标题
    self.title = @"足迹列表";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    
    //默认【下拉刷新】
    self.footprintTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullNewFootprints)];
    //默认【上拉加载】
    self.footprintTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFootprints)];
    [self.view addSubview:self.footprintTableView];
    
    [self.view addSubview:self.ARdituImageView];
    
    [self.view addSubview:self.fabuImageView];
    
    [self.view addSubview:self.pingmianImageView];
    
    [self.view bringSubviewToFront:self.customNavigationBar];
}


-(OTWFootprintSearchParams *)footprintSearchParams
{
    if (!_footprintSearchParams) {
        _footprintSearchParams = [[OTWFootprintSearchParams alloc] init];
        //列表查询
        _footprintSearchParams.type = @"list";
        //默认当前页为 0
        _footprintSearchParams.number = 0;
        //默认总页数 0
        _footprintSearchParams.totalPages = 0;
        //默认每页大小为 10
        _footprintSearchParams.size = 10;
        //范围
        _footprintSearchParams.distance = @"";
        //时间
        _footprintSearchParams.time = @"";
    }

    return _footprintSearchParams;
}

-(void)refresh
{
    DLog(@"refresh");
}
-(void)loadMore
{
    DLog(@"loadMore");
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.footprintFrames.count;
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
    [VC setFid:self.footprintFrames[indexPath.row].footprint.footprintId.description];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark 返回第indexPath这行对应的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"OTWFootprintListTableViewCellStatus";
    OTWFootprintListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [OTWFootprintListTableViewCell cellWithTableView:tableView identifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WeakSelf(self);
        cell.tapOne = ^(NSString *opId){
            OTWPersonalFootprintsListController *listVC = [[OTWPersonalFootprintsListController alloc] init];
            //判断是否是当前用户，然后跳转
            listVC.ifMyFootprint = [[OTWUserModel shared].userId.description isEqualToString:opId];
            [weakself.navigationController pushViewController:listVC animated:YES];
        };
    }
    [cell setFootprintListFrame:self.footprintFrames[indexPath.row]];
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(NSMutableArray*)footprintFrames{
    if(!_footprintFrames){
//        [self.footprintTableView.mj_footer beginRefreshing];
    }
    self.footprintFrames = [self setFrameByData:self.footprints];

    return _footprintFrames;
}

-(NSMutableArray *)setFrameByData:(NSMutableArray*)footprints
{
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:footprints.count];
    for (OTWFootprintListModel *footprintModel in footprints) {
        // 根据模型数据创建frame模型
        OTWFootprintListFrame *footprintFrame = [[OTWFootprintListFrame alloc] init];
        [footprintFrame setFootprint:footprintModel];
        [models addObject:footprintFrame];
    }
    return [models copy];
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

-(UIView*)ARdituImageView{
    if(!_ARdituImageView){
        _ARdituImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50-50-4, SCREEN_HEIGHT-30-49, 50, 50)] ;
        _ARdituImageView.backgroundColor = [UIColor clearColor];
        [(UIControl *)_ARdituImageView addTarget:self action:@selector(ARdituClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgARditu=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgARditu.image=[UIImage imageNamed:@"ar_ARditu"];
        [_ARdituImageView addSubview:imgARditu];
    }
    return _ARdituImageView;
}

-(UIView*)fabuImageView{
    if(!_fabuImageView){
        _fabuImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50-50-50-8, SCREEN_HEIGHT-30-49, 50, 50)] ;
        _fabuImageView.backgroundColor = [UIColor clearColor];
        [(UIControl *)_fabuImageView addTarget:self action:@selector(fubuClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgfabu=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgfabu.image=[UIImage imageNamed:@"ar_fabu"];
        [_fabuImageView addSubview:imgfabu];
    }
    return _fabuImageView;
}

-(UIView*)pingmianImageView{
    if(!_pingmianImageView){
        _pingmianImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50, SCREEN_HEIGHT-30-49, 50, 50)] ;
        _pingmianImageView.backgroundColor = [UIColor clearColor];
        [(UIControl *)_pingmianImageView addTarget:self action:@selector(pingmianClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgpingmian=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgpingmian.image=[UIImage imageNamed:@"ar_pingmian"];
        [_pingmianImageView addSubview:imgpingmian];
        
    }
    return _pingmianImageView;
}

-(void)ARdituClick{
    DLog(@"我点击了ARditu");
}

-(void)fubuClick{
    //验证登陆信息
    
    if(![[OTWLaunchManager sharedManager] showLoginViewWithController:self completion:nil]){
        OTWFootprintReleaseViewController *releaseVC = [[OTWFootprintReleaseViewController alloc] init];
        [self.navigationController pushViewController:releaseVC animated:YES];
    };
}

-(void)toPlaneMap
{
    OTWPlaneMapViewController *planeMapVC = [[OTWPlaneMapViewController alloc] init];
    [self.navigationController pushViewController:planeMapVC animated:YES];
}
-(void)pingmianClick{
    DLog(@"我点击了pingmianClick");
    OTWPlaneMapViewController *planeMapVC = [[OTWPlaneMapViewController alloc] init];
    [self.navigationController pushViewController:planeMapVC animated:YES];
}

-(void)loadMoreFootprints
{
    NSDictionary *footprintSearchParamsDict = self.footprintSearchParams.mj_keyValues;
    [self fetchFootprints:footprintSearchParamsDict completion:^(id result) {
        if (self.footprints.count == [result[@"body"][@"totalElements"] intValue]) {
            [self.footprintTableView.mj_footer endRefreshingWithNoMoreData];
            [self.footprintTableView.mj_footer endRefreshing];
            return;
        }
        if ([result[@"body"][@"content"] count] > 0) {
            for (int i = 0; i < [result[@"body"][@"content"] count]; i++) {
                OTWFootprintListModel *footprintModel = [OTWFootprintListModel mj_objectWithKeyValues:[result[@"body"][@"content"] objectAtIndex:i]];
                [self.footprints addObject:footprintModel];
            }
            if (self.footprints.count != [result[@"body"][@"totalElements"] intValue]) {
                self.footprintSearchParams.number += 1;
            }
        }
        [self.footprintTableView reloadData];
        [self.footprintTableView.mj_footer endRefreshing];
    }];
}

-(void)pullNewFootprints
{
    [self.footprints removeAllObjects];
    self.footprintSearchParams.number = 0;
    [self fetchFootprints:self.footprintSearchParams.mj_keyValues completion:^(id result) {
        if ([result[@"body"][@"content"] count] > 0) {
            for (int i = 0; i < [result[@"body"][@"content"] count]; i++) {
                OTWFootprintListModel *footprintModel = [OTWFootprintListModel mj_objectWithKeyValues:[result[@"body"][@"content"] objectAtIndex:i]];
                [self.footprints addObject:footprintModel];
            }
            if (self.footprints.count != [result[@"body"][@"totalElements"] intValue]) {
                self.footprintSearchParams.number += 1;
            }
        }
        [self.footprintTableView reloadData];
        [self.footprintTableView.mj_header endRefreshing];
    }];
}

-(void)pullNotice
{
    [self.footprintTableView.mj_header beginRefreshing];
}

-(void)fetchFootprints:(NSDictionary *)params completion:(requestBackBlock)block
{
    DLog(@"当前查询参数：%@",params);
    [OTWFootprintService getFootprintList:params completion:^(id result, NSError *error) {
        if (result) {
            if ([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]) {
                if (block) {
                    block(result);
                }
            }
        }
    }];
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    DLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
        _userLocation = userLocation;
        [_locService stopUserLocationService];
    }else{
        NSLog(@"反geo检索发送失败");
    }
}


- (void)didFailToLocateUserWithError:(NSError *)error
{
    DLog(@"error :%@",error);
}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error ==BMK_SEARCH_NO_ERROR){
        if(result.poiList.count>0){
            OTWFootprintChangeAddressArrayModel *model = [[OTWFootprintChangeAddressArrayModel alloc] init];
            BMKPoiInfo *poiInfo = ((BMKPoiInfo *)result.poiList[0]);
            model.latitude = poiInfo.pt.latitude;
            model.longitude = poiInfo.pt.longitude;
            self.footprintSearchParams.latitude = poiInfo.pt.latitude;
            self.footprintSearchParams.longitude = poiInfo.pt.longitude;
            _ifFirstLocation = NO;
            [self fetchFootprints:self.footprintSearchParams.mj_keyValues completion:^(id result) {
                if (self.footprints.count == [result[@"body"][@"totalElements"] intValue]) {
                    [self.footprintTableView.mj_footer endRefreshingWithNoMoreData];
                    [self.footprintTableView.mj_footer endRefreshing];
                    return;
                }
                if ([result[@"body"][@"content"] count] > 0) {
                    for (int i = 0; i < [result[@"body"][@"content"] count]; i++) {
                        OTWFootprintListModel *footprintModel = [OTWFootprintListModel mj_objectWithKeyValues:[result[@"body"][@"content"] objectAtIndex:i]];
                        [self.footprints addObject:footprintModel];
                    }
                    if (self.footprints.count != [result[@"body"][@"totalElements"] intValue]) {
                        self.footprintSearchParams.number += 1;
                    }
                }
                [self.footprintTableView reloadData];
                [self.footprintTableView.mj_footer endRefreshing];
            }];
        }
    }
}

@end
