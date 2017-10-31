//
//  OTWFindBusinessmenController.m
//  OnTheWay
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFindBusinessmenController.h"
#import "OTWFindBusinessmenModel.h"
#import "OTWFindBusinessmenViewCell.h"
#import "OTWFindViewController.h"
#import "OTWShopDetailsController.h"
#import "OTWBusinessDetailViewController.h"
#import "OTWFootprintSearchParams.h"
#import <MJExtension.h>
#import "OTWARShopService.h"
#import "OTWBusinessModel.h"
#import "OTWFootprintReleaseViewController.h"
#import "OTWBusinessARSiftTableViewCell.h"
#import "OTWBusinessARSiftDetailTableViewCell.h"
#import "OTWBusinessSortModel.h"
#import "OTWBusinessDetailSortModel.h"
#import "OTWBusinessListSearchViewController.h"
#import "OTWCustomNavigationBar.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface OTWFindBusinessmenViewController () <UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,OTWBusinessListSearchViewControllerDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_status;
}
@property (nonatomic,strong) UIView * ARdituImageView;
@property (nonatomic,strong) UIView * fabuImageView;
@property (nonatomic,strong) OTWFootprintSearchParams *arShopSearchParams;
@property (nonatomic,strong) NSDictionary *reponseCacheData;
@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,strong) BMKLocationService *locService;
//筛选按钮
@property(nonatomic,strong) UIButton *siftButton;
//搜索按钮
@property(nonatomic,strong) UIButton *searchButton;

@property(nonatomic,strong) UIButton *cancelButton;

@property(nonatomic,strong) UIView *siftView;

@property(nonatomic,strong) UIView *searchView;

@property(nonatomic,strong) UITableView *siftSortTableView;
@property(nonatomic,strong) UITableView *siftDetailTableView;

@property(nonatomic,strong) UIButton *cameraButton;
@property(nonatomic,strong) UIButton *arButton;
@property(nonatomic,strong) UIButton *planeMapButton;


//@property (nonatomic,strong) UIView * pingmianImageView;
@end

@implementation OTWFindBusinessmenViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _siftSortArr = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _status = [[NSMutableArray alloc] init];
    [self.locService startUserLocationService];
    if (_isFromAR) {
    }else{
        self.arShopSearchParams.typeIds = [NSString stringWithFormat:@"%@",_typeId];
    }
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.frame=CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65);
    
  // _tableView.separatorColor= [UIColor color_d5d5d5];
    
   _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.arShopSearchParams.number = 0;
        _arShopSearchParams.q = nil;
        [self getShopsList];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.arShopSearchParams.number++;
        [self getShopsList];
    }];
    [self.view addSubview:_tableView];
    
    [self.view addSubview:self.ARdituImageView];
    
    [self.view addSubview:self.fabuImageView];
    [self buildUI];
    //获取商家分类信息
    [self getbusinessSortData];
    
    //[self.view addSubview:self.pingmianImageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{
    _status = [[NSMutableArray alloc] init];
    NSDictionary *dic=@{@"BusinessmenAddress":@"东城区东直门内大街233",@"BusinessmenName":@"胡大饭馆（东直门总店）",@"BusinessmenNeedTime":@"步行约8分钟",@"BusinessmenDistance":@"432m",@"coupons":@[@"faxianshangjia",@"faxianshangjia",@"faxianshangjia"]};
    
    NSDictionary *dic2=@{@"BusinessmenAddress":@"东城区东直门内大街233",@"BusinessmenName":@"胡大饭馆胡大饭馆",@"BusinessmenNeedTime":@"步行约8分钟",@"BusinessmenDistance":@"432m",@"coupons":@[@"faxianshangjia",@"faxianshangjia",@"faxianshangjia"]};
    
    NSDictionary *dic3=@{@"BusinessmenAddress":@"东城区东直门内大街233",@"BusinessmenName":@"胡大饭馆胡大饭馆胡大饭馆胡大饭馆",@"BusinessmenNeedTime":@"步行约8分钟",@"BusinessmenDistance":@"432m",@"coupons":@[@"faxianshangjia",@"faxianshangjia",@"faxianshangjia",@"faxianshangjia",@"faxianshangjia"]};
        NSDictionary *dic4=@{@"BusinessmenAddress":@"东城区东直门内大街233",@"BusinessmenName":@"胡大饭馆（东直门总店）",@"BusinessmenNeedTime":@"步行约8分钟",@"BusinessmenDistance":@"432m",@"coupons":@[]};
        NSDictionary *dic5=@{@"BusinessmenAddress":@"东城区东直门内大街233",@"BusinessmenName":@"胡大饭馆（东直门总店）",@"BusinessmenNeedTime":@"步行约8分钟",@"BusinessmenDistance":@"432m",@"coupons":@[@"faxianshangjia",@"faxianshangjia",@"faxianshangjia"]};
        NSDictionary *dic6=@{@"BusinessmenAddress":@"东城区东直门内大街233",@"BusinessmenName":@"胡大饭馆（东直门总店）",@"BusinessmenNeedTime":@"步行约8分钟",@"BusinessmenDistance":@"432m",@"coupons":@[@"faxianshangjia",@"faxianshangjia",@"faxianshangjia"]};
        NSDictionary *dic7=@{@"BusinessmenAddress":@"东城区东直门内大街233",@"BusinessmenName":@"胡大饭馆（东直门总店）",@"BusinessmenNeedTime":@"步行约8分钟",@"BusinessmenDistance":@"432m",@"coupons":@[@"faxianshangjia",@"faxianshangjia",@"faxianshangjia"]};
        NSDictionary *dic8=@{@"BusinessmenAddress":@"东城区东直门内大街233",@"BusinessmenName":@"胡大饭馆（东直门总店）",@"BusinessmenNeedTime":@"步行约8分钟",@"BusinessmenDistance":@"432m",@"coupons":@[@"faxianshangjia",@"faxianshangjia",@"faxianshangjia"]};
    
    NSDictionary *dic9=@{@"BusinessmenAddress":@"东城区东直门内大街东城区东直门内大街区东直门内大街233",@"BusinessmenName":@"胡大饭馆胡大饭馆（东直门总店）",@"BusinessmenNeedTime":@"步行约8分步行约8分钟",@"BusinessmenDistance":@"432m",@"coupons":@[@"faxianshangjia",@"faxianshangjia",@"faxianshangjia",@"faxianshangjia",@"faxianshangjia",@"faxianshangjia",@"faxianshangjia",@"faxianshangjia"]};
    
    FindBusinessmenModel *model = [FindBusinessmenModel statusWithDictionary:dic];
    FindBusinessmenModel *model2= [FindBusinessmenModel statusWithDictionary:dic2];
    FindBusinessmenModel *model3= [FindBusinessmenModel statusWithDictionary:dic3];
    FindBusinessmenModel *model4= [FindBusinessmenModel statusWithDictionary:dic4];
    FindBusinessmenModel *model5= [FindBusinessmenModel statusWithDictionary:dic5];
    FindBusinessmenModel *model6= [FindBusinessmenModel statusWithDictionary:dic6];
    FindBusinessmenModel *model7= [FindBusinessmenModel statusWithDictionary:dic7];
    FindBusinessmenModel *model8= [FindBusinessmenModel statusWithDictionary:dic8];
    FindBusinessmenModel *model9= [FindBusinessmenModel statusWithDictionary:dic9];
    [_status addObject:model];
    [_status addObject:model2];
    [_status addObject:model3];
    [_status addObject:model4];
    [_status addObject:model5];
    [_status addObject:model6];
    [_status addObject:model7];
    [_status addObject:model8];
     [_status addObject:model9];

//    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"OTWFindBusinessmen.plist" ofType:nil];
//    NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
//    _status = [NSMutableArray arrayWithArray:dictArray];
}
- (void)getShopsList
{
    [self fetchARShops:self.arShopSearchParams.mj_keyValues completion:^(id result) {
        
        if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
            NSArray *arr = [NSArray arrayWithArray:[[result objectForKey:@"body"] objectForKey:@"content"]];
            if (arr.count == 0) {
                [self MBProgressHUDErrorTips:@"抱歉，未找到结果"];
            }
            if (self.arShopSearchParams.number == 0) {
                [_status removeAllObjects];
            }else{
            }
            for (NSDictionary * dic in arr) {
                FindBusinessmenModel *model = [FindBusinessmenModel statusWithDictionary:dic];
                [_status addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (arr.count == 0 || arr.count < self.arShopSearchParams.size) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableView.mj_footer endRefreshing];
                }
                [_tableView.mj_header endRefreshing];
                [_tableView reloadData];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                [self errorTips:@"服务端繁忙，请稍后再试" userInteractionEnabled:YES];
            });
        }
    }];
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
//            self.ifFirstLoadData = NO;
        }
    } responseCache:^(id responseCache) {
        self.reponseCacheData = responseCache;
    }];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

-(void)buildUI
{
    //设置标题
//    self.title = @"1234个商家";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    [self.customNavigationBar addSubview:self.searchButton];
//    [self setRightNavigationImage:[UIImage imageNamed:@"ar_shaixuan_2"]];
    [self setCustomNavigationRightView:self.siftButton];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //筛选view
//    [self.view addSubview:self.siftButton];
//    [self.view addSubview:self.siftView];
    [self.view insertSubview:self.siftView aboveSubview:_tableView];
    [self.siftView addSubview:self.searchView];
    [self.siftView addSubview:self.cancelButton];
    [self.siftView addSubview:self.siftSortTableView];
    [self.siftView addSubview:self.siftDetailTableView];
    
    [self.view addSubview:self.cameraButton];
    [self.view addSubview:self.arButton];
    [self.view addSubview:self.planeMapButton];

}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
        return _status.count;
    }
}

#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return 36.5;
    }else
    {
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36.5)];
        headView.backgroundColor = [UIColor color_f4f4f4];
        UILabel * all = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 12)];
        all.textColor = [UIColor color_979797];
        all.text = @"全部";
        all.font = [UIFont systemFontOfSize:12];
        [headView addSubview:all];
        return headView;
    }else
    {
        return nil;
    }

}

#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        return 70;
    }else
    {
        return 44;
    }
}
#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
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
                [self getShopsList];
            }
        }
        [_siftSortTableView reloadData];
        [_siftDetailTableView reloadData];
        _siftView.hidden = YES;
    }else{
        OTWBusinessDetailViewController *businessVC = [[OTWBusinessDetailViewController alloc] init];
        FindBusinessmenModel *status=_status[indexPath.row];
        businessVC.latitude = self.location.latitude;
        businessVC.longitude = self.location.longitude;
        [businessVC setOpData:[NSString stringWithFormat:@"%@",status.businessId]];
        [self.navigationController pushViewController:businessVC animated:YES];
    }

}

#pragma mark 返回第indexPath这行对应的内容
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
                if (model.children.count > indexPath.row) {
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
        }
        return cell;
    }else
    {
        static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
        OTWFindBusinessmenViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell){
            cell=[[OTWFindBusinessmenViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            //cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //在此模块，以便重新布局
        FindBusinessmenModel *status=_status[indexPath.row];
        cell.status=status;
        return cell;
    }


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
                    if ([[NSString stringWithFormat:@"%@",model.typeId] isEqualToString:self.firstID]) {
                        model.selected = YES;
                    }else
                    {
                        model.selected = NO;
                    }
                    for (OTWBusinessDetailSortModel * result in model.children) {
                        if ([[NSString stringWithFormat:@"%@",result.typeId] isEqualToString:self.sortId]) {
                            result.selected = YES;
                        }else{
                            result.selected = NO;
                        }
                    }
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
                    if ([[NSString stringWithFormat:@"%@",model.typeId] isEqualToString:self.firstID]) {
                        model.selected = YES;
                    }else
                    {
                        model.selected = NO;
                    }
                    for (OTWBusinessDetailSortModel * result in model.children) {
                        if ([[NSString stringWithFormat:@"%@",result.typeId] isEqualToString:self.sortId]) {
                            result.selected = YES;
                        }else{
                            result.selected = NO;
                        }
                    }
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
- (void)searchButtonClick
{
    OTWBusinessListSearchViewController *findSearchVC = [[OTWBusinessListSearchViewController alloc] init];
    findSearchVC.delegate = self;
    [self.navigationController pushViewController:findSearchVC animated:NO];
}
#pragma mark OTWBusinessListSearchViewControllerDelegate

- (void)searchWithStr:(NSString *)searchText
{
    _arShopSearchParams.type = @"list";
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
    
    _arShopSearchParams.currentTime = nil;
    
    _arShopSearchParams.q = searchText;
    
    [self getShopsList];
}

- (void)cancelButtonClick
{
    [UIView beginAnimations:nil context:nil];
    _siftView.frame = CGRectMake(0, -415, SCREEN_WIDTH, 415);
    [UIView commitAnimations];
    _siftView.hidden = YES;
}
- (void)toSearchBusiness
{
    [self cancelButtonClick];
    OTWBusinessListSearchViewController *findSearchVC = [[OTWBusinessListSearchViewController alloc] init];
    findSearchVC.delegate = self;
    findSearchVC.isFromAR = YES;
    [self.navigationController pushViewController:findSearchVC animated:NO];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//-(UIView*)ARdituImageView{
//    if(!_ARdituImageView){
//        _ARdituImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50, SCREEN_HEIGHT-30-49, 50, 50)] ;
//        _ARdituImageView.backgroundColor = [UIColor clearColor];
//        [(UIControl *)_ARdituImageView addTarget:self action:@selector(ARdituClick) forControlEvents:UIControlEventTouchUpInside];
//        UIImageView *imgARditu=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//        imgARditu.image=[UIImage imageNamed:@"ar_ARditu"];
//        [_ARdituImageView addSubview:imgARditu];
//    }
//    return _ARdituImageView;
//}
//
//-(UIView*)fabuImageView{
//    if(!_fabuImageView){
//        _fabuImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50-50-15, SCREEN_HEIGHT-30-49, 50, 50)] ;
//        _fabuImageView.backgroundColor = [UIColor clearColor];
//        [(UIControl *)_fabuImageView addTarget:self action:@selector(fubuClick) forControlEvents:UIControlEventTouchUpInside];
//        UIImageView *imgfabu=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//        imgfabu.image=[UIImage imageNamed:@"ar_fabu"];
//        [_fabuImageView addSubview:imgfabu];
//    }
//    return _fabuImageView;
//}

- (UIButton*)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.backgroundColor = [UIColor clearColor];
        CGFloat cameraButtonX = SCREEN_WIDTH - 50*3 - 15 - 7*2;
        CGFloat cameraButtonY = SCREEN_HEIGHT - 15*2 - 50;
        self.cameraButton.frame = CGRectMake(cameraButtonX, cameraButtonY, 50, 50);
        [_cameraButton setImage:[UIImage imageNamed:@"ar_fabu"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(fubuClick) forControlEvents:UIControlEventTouchUpInside];
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
        [_arButton addTarget:self action:@selector(ARdituClick) forControlEvents:UIControlEventTouchUpInside];
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

- (UIButton *)siftButton
{
    if (!_siftButton) {
        _siftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _siftButton.frame = CGRectMake(SCREEN_WIDTH - 52, 22, 52, 40);
        _siftButton.backgroundColor = [UIColor clearColor];
        [_siftButton setImage:[UIImage imageNamed:@"ar_shaixuan_2"] forState:UIControlStateNormal];
        [_siftButton addTarget:self action:@selector(siftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _siftButton;
}

- (UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(SCREEN_WIDTH - 52 - 36, 22, 36, 40);
        _searchButton.backgroundColor = [UIColor clearColor];
        [_searchButton setImage:[UIImage imageNamed:@"ar_sousuo_3"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
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
//- (NSMutableArray *)siftSortArr
//{
//    if (!_siftSortArr) {
//        _siftSortArr = @[].mutableCopy;
//    }
//    return _siftSortArr;
//}

#pragma mark 初始化商家list查询参数
-(OTWFootprintSearchParams *)arShopSearchParams
{
    if (!_arShopSearchParams) {
        _arShopSearchParams = [[OTWFootprintSearchParams alloc] init];
        //列表查询
        _arShopSearchParams.type = @"list";
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
- (BMKLocationService *) locService
{
    if(!_locService){
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    }
    return _locService;
}

//-(UIView*)pingmianImageView{
//    if(!_pingmianImageView){
//        _pingmianImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50, SCREEN_HEIGHT-30-49, 50, 50)] ;
//        _pingmianImageView.backgroundColor = [UIColor clearColor];
//        [(UIControl *)_pingmianImageView addTarget:self action:@selector(pingmianClick) forControlEvents:UIControlEventTouchUpInside];
//        UIImageView *imgpingmian=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//        imgpingmian.image=[UIImage imageNamed:@"ar_pingmian"];
//        [_pingmianImageView addSubview:imgpingmian];
//        
//    }
//    return _pingmianImageView;
//}
#pragma mark - BMKLocationServiceDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    self.location = coordinate;
    self.arShopSearchParams.latitude = coordinate.latitude;
    self.arShopSearchParams.longitude = coordinate.longitude;
    [self getShopsList];
    [self.locService stopUserLocationService];
}

-(void)ARdituClick{
    DLog(@"我点击了ARdituClick");
    if (_isFromAR) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexAR];
    }
}

-(void)fubuClick{
   DLog(@"我点击了fubuClick");
    OTWFootprintReleaseViewController * FootprintRelease = [[OTWFootprintReleaseViewController alloc] init];
    [self.navigationController pushViewController:FootprintRelease animated:NO];
}
- (void)planeMapButtonClick
{
    
}
- (void)leftNavigaionButtonClicked
{
    [self.navigationController popViewControllerAnimated:NO];
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
//-(void)pingmianClick{
//    DLog(@"我点击了pingmianClick");
//}
@end
