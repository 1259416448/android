//
//  OTWFootprintsChangeAddressController.m
//  OnTheWay
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintsChangeAddressController.h"
#import "OTWFootprintsChangeAddressModel.h"
#import "OTWFootprintsChangeAddressCellTableViewCell.h"
#import "CHCustomSearchBar.h"
#import "OTWCustomNavigationBar.h"

#import <MJRefresh.h>


@interface OTWFootprintsChangeAddressController()<UITableViewDataSource,UITableViewDelegate,BMKPoiSearchDelegate,UISearchBarDelegate,BMKGeoCodeSearchDelegate>{
    BMKPoiSearch *_poiSearch;
    BMKGeoCodeSearch *_geoCodeSearch;
    int _curPage;
}
@property (nonatomic,strong) UITableView *footprintTableView;
@property (nonatomic,strong) CHCustomSearchBar *footprintSearchAddress;
@property (nonatomic,strong) UIView *footprintTableViewTableViewHeader;
@property(nonatomic,assign) UIEdgeInsets textFieldInset;
@property (nonatomic,strong) UIView *customLeftNavigationBarView;

@property (nonatomic,strong) OTWFootprintChangeAddressArrayModel *defaultChooseModel;

@property (nonatomic,copy) OTWFootprintsChangeAddressModel *status;
@property (nonatomic,strong) UIView *searchBG;
@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,copy) NSString *defaultPoiKey;
@property (nonatomic,assign) BOOL ifFirstSearch;


@end

@implementation OTWFootprintsChangeAddressController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _poiSearch = [[BMKPoiSearch alloc] init];
    
    _poiSearch.delegate = self;
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    _curPage = 0;
    
    _ifFirstSearch = YES;
    
    [self initData];
    
    [self buildUI];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _poiSearch.delegate = nil;
    _footprintSearchAddress.delegate = nil;
    _geoCodeSearch.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData
{
    _status = [[OTWFootprintsChangeAddressModel alloc] init];
    _status.addressArray = [[NSMutableArray alloc] init];
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = _location;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
        [self.footprintTableView.mj_footer beginRefreshing];
    }else{
        //弹出错误提示信息
        NSLog(@"反geo检索发送失败");
    }
    
}

-(void)buildUI
{
    //设置标题
    self.title = @"所在地址";
    [self setCustomNavigationLeftView:self.customLeftNavigationBarView];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    //搜索框
    
    [self.footprintTableViewTableViewHeader addSubview:self.footprintSearchAddress];
    
    [self.view addSubview:self.footprintTableView];
    
    self.footprintTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    [self.view addSubview:self.searchBG];
    
    [self.view bringSubviewToFront:self.customNavigationBar];
}

- (void) loadMore
{
    if(_ifFirstSearch) return;
    if([_footprintSearchAddress.text isEqualToString:@""]){
        [self.footprintTableView.mj_footer endRefreshing];
        self.footprintTableView.mj_footer.hidden = YES;
        return;
    }else{
        self.footprintTableView.mj_footer.hidden = NO;
    }
    //poi检索数据
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = _curPage;
    option.pageCapacity = 10;
    
    option.location = _location;
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    option.keyword = _footprintSearchAddress.text;
    
    BOOL flag = [_poiSearch poiSearchNearBy:option];
    if(flag){
        DLog(@"周边检索发送成功");
    }
    else{
        DLog(@"周边检索发送失败");
    }
}

- (UIView *) customLeftNavigationBarView
{
    if(!_customLeftNavigationBarView){
        _customLeftNavigationBarView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 45, 32.5)];
        _customLeftNavigationBarView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 34, 22.5)];
        titleLabel.text = @"取消";
        titleLabel.textColor = [UIColor color_202020];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [_customLeftNavigationBarView addSubview:titleLabel];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTap)];
        [_customLeftNavigationBarView addGestureRecognizer:tapGesturRecognizer];
    }
    return _customLeftNavigationBarView;
}

- (void) cancelTap
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(UITableView *)footprintTableView{
    if(!_footprintTableView){
        _footprintTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationHeight) style:UITableViewStyleGrouped];
        _footprintTableView.dataSource = self;
        
        _footprintTableView.delegate = self;
        
        _footprintTableView.backgroundColor = [UIColor clearColor];
        
        _footprintTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
        //设置tableview的第一行显示内容
        _footprintTableView.tableHeaderView=self.footprintTableViewTableViewHeader;
    }
    return _footprintTableView;
}

-(UIView*)footprintTableViewTableViewHeader{
    if(!_footprintTableViewTableViewHeader){
        _footprintTableViewTableViewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 51)];
        _footprintTableViewTableViewHeader.backgroundColor=[UIColor clearColor];
        _footprintTableViewTableViewHeader.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        _footprintTableViewTableViewHeader.layer.borderWidth=0.5;
    }
    return _footprintTableViewTableViewHeader;
}

-(CHCustomSearchBar*)footprintSearchAddress{
    if(!_footprintSearchAddress){
        _footprintSearchAddress=[[CHCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 50)];
        [_footprintSearchAddress setPlaceholder:@"搜索附近位置"];
        [_footprintSearchAddress setContentMode:UIViewContentModeCenter];
        
       //自定义搜索框的大小
        _footprintSearchAddress.textFieldInset=UIEdgeInsetsMake(7.5, 15, 7.5, 15);
        
        //替换搜索图标
//        [_footprintSearchAddress setImage:[UIImage imageNamed:@"sousuo_1"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        //这个枚举可以对searchBar进行修改
        _footprintSearchAddress.searchBarStyle = UISearchBarStyleProminent;
        
  
        UITextField *searchField = nil;
        for (UIView *subview in  _footprintSearchAddress.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIView")]&&subview.subviews.count>0) {
                subview.backgroundColor = [UIColor color_f4f4f4];
                [[subview.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        //的到搜索框 并设置他的属性
        searchField = [[[_footprintSearchAddress.subviews firstObject] subviews] lastObject];
        searchField.layer.cornerRadius = 3;
        searchField.layer.masksToBounds = YES;
        searchField.layer.borderColor = [UIColor color_d5d5d5].CGColor;
        searchField.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.9f];
        searchField.layer.borderWidth = 0.5;
        //设置图标
        UIImage *image = [UIImage imageNamed: @"sousuo_1"];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        iView.frame = CGRectMake(0, 0, 15 , 15);
        UIView *myview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15 , 15)];
        [myview addSubview: iView];
        searchField.leftView = myview;
        
        _footprintSearchAddress.delegate = self;
    }
    return _footprintSearchAddress;
}

-(UIView *) searchBG
{
    if(!_searchBG)
    {
        _searchBG = [[UIView alloc] initWithFrame:self.footprintTableView.bounds];
        _searchBG.backgroundColor = [UIColor clearColor];
        _searchBG.hidden = YES;
    }
    return _searchBG;
}

-(void) location:(CLLocationCoordinate2D) location
{
    _location = location;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tapOne(_status.addressArray[indexPath.row]);
    [self cancelTap];
    [self.footprintTableView removeFromSuperview];
}

#pragma mark 返回每组行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _status.addressArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"findViewCellI";
    OTWFootprintsChangeAddressCellTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWFootprintsChangeAddressCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData:_status.addressArray[indexPath.row]];
    return cell;
}
#pragma mark - 代理方法
#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * sectionHeader=[[UIView alloc] init];
    sectionHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH,50);
    sectionHeader .backgroundColor=[UIColor whiteColor];

    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 30)];
    name.text=_status.city;
    name.textColor=[UIColor color_202020];
    name.font=[UIFont systemFontOfSize:16];
    
    [sectionHeader addSubview:name];
    return sectionHeader;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _searchBG.hidden = NO;
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if([_footprintSearchAddress.text isEqualToString:@""]){
        [self.footprintTableView.mj_footer endRefreshing];
        self.footprintTableView.mj_footer.hidden = YES;
    }else{
        self.footprintTableView.mj_footer.hidden = NO;
    }
    _searchBG.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [_status.addressArray removeAllObjects];
    [self.footprintTableView reloadData];
    self.footprintTableView.mj_footer.hidden = NO;
    [self.footprintTableView.mj_footer beginRefreshing];
    _curPage = 0;
    
}

#pragma mark - BMKPoiSearchDelegate
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        for (BMKPoiInfo *one in poiResultList.poiInfoList) {
            OTWFootprintChangeAddressArrayModel *model = [[OTWFootprintChangeAddressArrayModel alloc] init];
            model.latitude = one.pt.latitude;
            model.longitude = one.pt.longitude;
            model.name = one.name;
            model.address = one.address;
            model.uuid = one.uid;
            [_status.addressArray addObject:model];
        }
        [self.footprintTableView reloadData];
        if(_status.addressArray.count == poiResultList.totalPoiNum){
            [self.footprintTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            _curPage +=1;
            [self.footprintTableView.mj_footer endRefreshing];
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
        [self.footprintTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        NSLog(@"抱歉，未找到结果");
        [self.footprintTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    _defaultChooseModel.isClick = YES;
    [_status.addressArray addObject:_defaultChooseModel];
    if (error ==BMK_SEARCH_NO_ERROR){
        _status.city = result.addressDetail.city;
        for (BMKPoiInfo *poiInfo in result.poiList) {
            if([poiInfo.uid isEqualToString:_defaultChooseModel.uuid]) continue;
            OTWFootprintChangeAddressArrayModel *model = [[OTWFootprintChangeAddressArrayModel alloc] init];
            model.latitude = poiInfo.pt.latitude;
            model.longitude = poiInfo.pt.longitude;
            model.name = poiInfo.name;
            model.address = poiInfo.address;
            model.uuid = poiInfo.uid;
            [_status.addressArray addObject:model];
        }
        [self.footprintTableView.mj_footer endRefreshing];
        self.footprintTableView.mj_footer.hidden = YES;
        [self.footprintTableView reloadData];
        _ifFirstSearch = NO;
    }
}

#pragma mark - 设置默认选中地址

-(void) defaultChooseModel:(OTWFootprintChangeAddressArrayModel *)defaultChooseModel
{
    _defaultChooseModel = defaultChooseModel;
}

- (void) dealloc
{
    DLog(@"dealloc");
}

@end
