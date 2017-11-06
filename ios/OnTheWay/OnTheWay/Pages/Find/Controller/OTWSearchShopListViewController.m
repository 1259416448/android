//
//  OTWSearchShopListViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/10.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWSearchShopListViewController.h"
#import "OTWSearchShopListViewCell.h"
#import "OTWCustomNavigationBar.h"
#import "CHCustomSearchBar.h"
#import "OTWAddNewShopViewController.h"
#import "OTWSearchShopModel.h"
#import "OTWSearchShopParameter.h"
#import "OTWAddNewShopNextViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface OTWSearchShopListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UISearchBarDelegate,BMKLocationServiceDelegate>{

}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CHCustomSearchBar *footprintSearchAddress;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView *noResultView;
@property (nonatomic,strong) UIImageView *noResultImage;
@property (nonatomic,strong) UILabel *noResultLabelOne;
@property (nonatomic,strong) UILabel *noResultLabelTwo;
@property (nonatomic,strong) UIButton *addClaimShopBtn;
@property (nonatomic,strong) OTWSearchShopParameter *Parameter;
@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation OTWSearchShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locService startUserLocationService];
    _dataArr = @[].mutableCopy;
    [self buildUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:NO];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)buildUI{
    //设置标题 搜索--商家详情
    //[self.customNavigationBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.customNavigationBar.frame=CGRectMake(0, 0, SCREEN_WIDTH, 65);
    [self.customNavigationBar addSubview:self.footprintSearchAddress];
    self.customNavigationBar.backgroundColor=[UIColor whiteColor];
    [self.customNavigationBar addSubview:self.cancelBtn];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    //有搜索结果
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    //无搜索结果
//    [self.view addSubview:self.noResultView];
    for (UIView *view in self.footprintSearchAddress.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *searchTextField = (UITextField*)view;
            searchTextField.clearButtonMode = UITextFieldViewModeNever;
        }
    }
}
#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OTWSearchShopModel * model = _dataArr[indexPath.row];
    OTWAddNewShopNextViewController * AddNewShopNextVc = [[OTWAddNewShopNextViewController alloc] init];
    AddNewShopNextVc.model = model;
    AddNewShopNextVc.isFromSearchShop = YES;
    [self.navigationController pushViewController:AddNewShopNextVc animated:YES];
}
#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OTWSearchShopListViewCellIdentifierKey";
    OTWSearchShopListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OTWSearchShopListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OTWSearchShopModel * model = _dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    OTWSearchShopListViewCell *cell = (OTWSearchShopListViewCell *)[self tableView:tableView
//                                                       cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    return 110;
}
//获取数据
- (void)loadData
{
    NSString * url = @"/app/business/claim/search";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [OTWNetworkManager doGET:url parameters:self.Parameter.mj_keyValues success:^(id responseObject) {
            if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
                NSArray *arr = [NSArray arrayWithArray:[[responseObject objectForKey:@"body"] objectForKey:@"content"]];
                if (self.Parameter.number == 0) {
                    [_dataArr removeAllObjects];
                }
                for (NSDictionary *result in arr)
                {
                    OTWSearchShopModel * model = [OTWSearchShopModel mj_objectWithKeyValues:result];
                    [_dataArr addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_dataArr.count == 0) {
                        self.tableView.hidden = YES;
                        [self.view addSubview:self.noResultView];
                    }else{
                        self.tableView.hidden = NO;
                        [self.noResultView removeFromSuperview];
                        [_tableView reloadData];
                    }
                    [_tableView.mj_header endRefreshing];
                    if (arr.count == 0 || arr == nil) {
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_tableView.mj_footer endRefreshing];
                    }
                });
            }
        } failure:^(NSError *error) {
            
        }]; 
    });
}
#pragma mark - BMKLocationServiceDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    self.Parameter.latitude = coordinate.latitude;
    self.Parameter.longitude = coordinate.longitude;
    [self.locService stopUserLocationService];
}


-(CHCustomSearchBar*)footprintSearchAddress{
    if(!_footprintSearchAddress){
        _footprintSearchAddress=[[CHCustomSearchBar alloc] initWithFrame:CGRectMake(15, 25.5, SCREEN_WIDTH-45-35, 34)];
        [_footprintSearchAddress setPlaceholder:@"搜索附近的美食、商城"];
        [_footprintSearchAddress setContentMode:UIViewContentModeCenter];
        _footprintSearchAddress.layer.cornerRadius = 20;
        _footprintSearchAddress.layer.masksToBounds = YES;
        
        
        //自定义搜索框的大小
        _footprintSearchAddress.textFieldInset=UIEdgeInsetsMake(0,0,0,0);
        
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
        searchField.layer.cornerRadius = 30;
        searchField.layer.masksToBounds = YES;
        searchField.layer.borderColor = [UIColor clearColor].CGColor;
        searchField.backgroundColor=[[UIColor color_f4f4f4]colorWithAlphaComponent:0.9f];
        searchField.layer.borderWidth = 0.5;
        [searchField becomeFirstResponder];
        [searchField setClearButtonMode:UITextFieldViewModeNever];
        //设置图标
        UIImage *image = [UIImage imageNamed: @"sousuo_1"];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        iView.frame = CGRectMake(0, 0, 15 , 15);
        UIView *myview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15 , 15)];
        [myview addSubview: iView];
        searchField.leftView = myview;
        
        _footprintSearchAddress.delegate = self;

        UIButton * clearSearchBar = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        clearSearchBar.frame =CGRectMake(_footprintSearchAddress.Witdh-15-15, 19/2, 15, 15);
        clearSearchBar.layer.cornerRadius = clearSearchBar.frame.size.width /2;
        clearSearchBar.clipsToBounds = YES;
        [clearSearchBar setBackgroundImage:[UIImage imageNamed:@"fx_guanbi"] forState:(UIControlStateNormal)];
        [clearSearchBar addTarget:self action:@selector(clearSearchBarClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_footprintSearchAddress addSubview:clearSearchBar];
        
    }
    return _footprintSearchAddress;
}

-(void)clearSearchBarClick{
    DLog(@"点击了清除");
}
#pragma mark searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"点击了搜索");
    self.tableView.hidden = NO;
    self.Parameter.number = 0;
    [_dataArr removeAllObjects];
    [self.footprintSearchAddress resignFirstResponder];
    self.Parameter.q = searchBar.text;
    [self loadData];
}

-(UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_cancelBtn setTitle: @"取消" forState: UIControlStateNormal];
        _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cancelBtn setTitleColor:[UIColor color_202020]forState:UIControlStateNormal];
        
        _cancelBtn.frame =CGRectMake(self.footprintSearchAddress.Witdh+30, 25.5+6, 35, 22.5);

        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.Parameter.number = 0;
            [self loadData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.Parameter.number++;
            [self loadData];
        }];
    }
    return _tableView;
}

-(UIView*)noResultView{
    if(!_noResultView){
        _noResultView=[[UIView alloc] initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
        _noResultView.backgroundColor=[UIColor whiteColor];
        [_noResultView addSubview:self.noResultImage];
        [_noResultView addSubview:self.noResultLabelOne];
        [_noResultView addSubview:self.noResultLabelTwo];
        [_noResultView addSubview:self.addClaimShopBtn];
    }
    return _noResultView;
}
-(UIImageView*)noResultImage{
    if(!_noResultImage){
        _noResultImage=[[UIImageView alloc]init];
        _noResultImage.frame=CGRectMake((SCREEN_WIDTH-151)/2, 130, 151, 109);
        _noResultImage.image=[UIImage imageNamed:@"qs_wusousuo"];
    }
    return _noResultImage;
}

-(UILabel*)noResultLabelOne{
    if(!_noResultLabelOne){
        _noResultLabelOne=[[UILabel alloc]init];
        _noResultLabelOne.text=@"小主，您搜索的词太高端了";
        _noResultLabelOne.font=[UIFont systemFontOfSize:13];
        _noResultLabelOne.textColor=[UIColor color_979797];
        [_noResultLabelOne sizeToFit];
        _noResultLabelOne.frame=CGRectMake(0, self.noResultImage.MaxY+15, SCREEN_WIDTH, _noResultLabelOne.Height);
        _noResultLabelOne.textAlignment=NSTextAlignmentCenter;
    }
    return _noResultLabelOne;
}

-(UILabel*)noResultLabelTwo{
    if(!_noResultLabelTwo){
        _noResultLabelTwo=[[UILabel alloc]init];
        _noResultLabelTwo.text=@"我们都没有搜索到呢~";
        _noResultLabelTwo.font=[UIFont systemFontOfSize:13];
        _noResultLabelTwo.textColor=[UIColor color_979797];
        [_noResultLabelTwo sizeToFit];
        _noResultLabelTwo.frame=CGRectMake(0, self.noResultLabelOne.MaxY+10, SCREEN_WIDTH, _noResultLabelTwo.Height);
        _noResultLabelTwo.textAlignment=NSTextAlignmentCenter;
    }
    return _noResultLabelTwo;
}
-(UIButton*)addClaimShopBtn{
    if(!_addClaimShopBtn){
        _addClaimShopBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_addClaimShopBtn setTitle: @"添加商家并认领" forState: UIControlStateNormal];
        _addClaimShopBtn.titleLabel.font=[UIFont systemFontOfSize:17];
        _addClaimShopBtn.backgroundColor=[UIColor color_e50834];
        _addClaimShopBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_addClaimShopBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        
        _addClaimShopBtn.frame =CGRectMake((SCREEN_WIDTH-200)/2,self.noResultLabelTwo.MaxY+50,200,44);
        
        [_addClaimShopBtn addTarget:self action:@selector(addClaimShopBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addClaimShopBtn.layer.cornerRadius = 3;
        _addClaimShopBtn.layer.masksToBounds = YES;
    }
    return _addClaimShopBtn;
}
- (OTWSearchShopParameter *)Parameter
{
    if (!_Parameter) {
        _Parameter = [[OTWSearchShopParameter alloc] init];
        _Parameter.number = 0;
        _Parameter.size = 15;
        _Parameter.currentTime = nil;
    }
    return _Parameter;
}
- (BMKLocationService *) locService
{
    if(!_locService){
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    }
    return _locService;
}
-(void)addClaimShopBtnClick{
    OTWAddNewShopViewController *addNewShopVC = [[OTWAddNewShopViewController alloc] init];
    [self.navigationController pushViewController:addNewShopVC animated:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
