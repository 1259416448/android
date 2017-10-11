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
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface OTWFindBusinessmenViewController () <UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_status;
}
@property (nonatomic,strong) UIView * ARdituImageView;
@property (nonatomic,strong) UIView * fabuImageView;
@property (nonatomic,strong) OTWFootprintSearchParams *arShopSearchParams;
@property (nonatomic,strong) NSDictionary *reponseCacheData;
@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,strong) BMKLocationService *locService;


//@property (nonatomic,strong) UIView * pingmianImageView;
@end

@implementation OTWFindBusinessmenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _status = [[NSMutableArray alloc] init];
    [self buildUI];
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
        [self getShopsList];
    }];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self.arShopSearchParams.number++;
        [self getShopsList];
    }];
    [self.view addSubview:_tableView];
    
    [self.view addSubview:self.ARdituImageView];
    
    [self.view addSubview:self.fabuImageView];
    
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
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
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
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];

}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _status.count;
}

#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36.5)];
    headView.backgroundColor = [UIColor color_f4f4f4];
    UILabel * all = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 12)];
    all.textColor = [UIColor color_979797];
    all.text = @"全部";
    all.font = [UIFont systemFontOfSize:12];
    [headView addSubview:all];
    return headView;
}

#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
    //OTWShopDetailsController  *ShopDetailsVC = [[OTWShopDetailsController alloc] init];
    OTWBusinessDetailViewController *businessVC = [[OTWBusinessDetailViewController alloc] init];
    [businessVC setOpData:@"110"];
    [self.navigationController pushViewController:businessVC animated:YES];
}

#pragma mark 返回第indexPath这行对应的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(UIView*)ARdituImageView{
    if(!_ARdituImageView){
        _ARdituImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50, SCREEN_HEIGHT-30-49, 50, 50)] ;
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
        _fabuImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50-50-15, SCREEN_HEIGHT-30-49, 50, 50)] ;
        _fabuImageView.backgroundColor = [UIColor clearColor];
        [(UIControl *)_fabuImageView addTarget:self action:@selector(fubuClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgfabu=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgfabu.image=[UIImage imageNamed:@"ar_fabu"];
        [_fabuImageView addSubview:imgfabu];
    }
    return _fabuImageView;
}
#pragma mark 初始化商家list查询参数
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
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexAR];
    }
}

-(void)fubuClick{
   DLog(@"我点击了fubuClick");
    OTWFootprintReleaseViewController * FootprintRelease = [[OTWFootprintReleaseViewController alloc] init];
    [self.navigationController pushViewController:FootprintRelease animated:YES];
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
