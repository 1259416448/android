//
//  OTWFindViewController.m
//  OnTheWay
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFindViewController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWFindViewCell.h"
#import "OTWFindModel.h"
#import "OTWFindBusinessmenController.h"
#import "CHCustomSearchBar.h"
#import "findSearchViewController.h"
#import "OTWBusinessListSearchViewController.h"
#import "OTWBusinessARViewController.h"

@interface OTWFindViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,OTWBusinessListSearchViewControllerDelegate,OTWFindViewCellDelegate>{
    UITableView *_tableView;
    NSMutableArray *_status;
}
@property (nonatomic,strong) UIView *SearchBar;

@end

@implementation OTWFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _status = [[NSMutableArray alloc] init];

    //初始化数据
//    [self initData];
    [self getbusinessSortData];
    [self buildUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController showTabBarWithAnimation:YES];
}
#pragma mark 构造数据
-(void)initData{
    
    _status = [[NSMutableArray alloc] init];
    NSDictionary *dic=@{@"Id":@(1),@"FindTpyeBackgroundImageUrl":@"fx_cy_bg",@"FindTpyeName":@"餐饮",@"FindTpyeContentList":@[@[@"自助餐",@"zizhucan"],@[@"咖啡",@"kafei"],@[@"火锅",@"huoguo"]]};
    
    NSDictionary *dic2=@{@"Id":@(2),@"FindTpyeBackgroundImageUrl":@"fx_sd_bg",@"FindTpyeName":@"商店",@"FindTpyeContentList":@[@[@"购物",@"gouwu"],@[@"书店",@"shudian"],@[@"便利店",@"bianlidian"]]};
    NSDictionary *dic3=@{@"Id":@(2),@"FindTpyeBackgroundImageUrl":@"fx_wy_bg",@"FindTpyeName":@"文娱",@"FindTpyeContentList":@[@[@"电影院",@"dianyingyuan"],@[@"博物馆",@"bowuguan"]]};
    
    NSDictionary *dic4=@{@"Id":@(2),@"FindTpyeBackgroundImageUrl":@"fx_jt_bg",@"FindTpyeName":@"交通",@"FindTpyeContentList":@[@[@"巴士",@"bashi"],@[@"地铁",@"ditie"],@[@"出租",@"chuzu"],@[@"飞机",@"feiji"]]};
    
    OTWFindStatus *model = [OTWFindStatus statusWithDictionary:dic];
    OTWFindStatus *model2= [OTWFindStatus statusWithDictionary:dic2];
    OTWFindStatus *model3= [OTWFindStatus statusWithDictionary:dic3];
    OTWFindStatus *model4= [OTWFindStatus statusWithDictionary:dic4];
    [_status addObject:model];
    [_status addObject:model2];
    [_status addObject:model3];
    [_status addObject:model4];
    
    //    _status = [[NSMutableArray alloc] init];
    //    [_status addObject:@[@"1",@"wodezuji",@"餐饮",@"333"]];
    //    [_status addObject:@[@"2",@"wodeshoucang",@"商店"]];
    //    [_status addObject:@[@"3",@"faxianshangjia",@"文娱"]];
    //    [_status addObject:@[@"3",@"wodekaquan",@"交通"]];
}
- (void)getbusinessSortData
{
    NSString * url = @"/app/business/type/all";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [OTWNetworkManager doGET:url parameters:nil responseCache:^(id responseCache) {
            if([[NSString stringWithFormat:@"%@",responseCache[@"code"]] isEqualToString:@"0"]){
                NSArray *arr = [NSArray arrayWithArray:[responseCache objectForKey:@"body"]];
                for (NSDictionary *result in arr)
                {
                    if ([[result objectForKey:@"ifTop"] boolValue]) {
                        OTWFindStatus *model = [OTWFindStatus statusWithDictionary:result];
                        [_status addObject:model];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
        } success:^(id responseObject) {
            if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
                [_status removeAllObjects];
                NSArray *arr = [NSArray arrayWithArray:[responseObject objectForKey:@"body"]];
                
                for (NSDictionary *result in arr)
                {
                    if ([[result objectForKey:@"ifTop"] boolValue]) {
                        OTWFindStatus *model = [OTWFindStatus statusWithDictionary:result];
                        [_status addObject:model];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
        } failure:^(NSError *error) {
            
        }];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)buildUI{
    
    self.customNavigationBar.frame=CGRectMake(0, 0, SCREEN_WIDTH, 65);
    [self.customNavigationBar addSubview:self.SearchBar];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationHeight-49) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:_tableView];
    
}

#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _status.count;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
    OTWBusinessARViewController *BusinessARVC = [[OTWBusinessARViewController alloc] init];
    OTWFindStatus *status=_status[indexPath.row];
    BusinessARVC.typeId = [NSString stringWithFormat:@"%@",status.typeId];
    BusinessARVC.firstID = [NSString stringWithFormat:@"%@",status.typeId];
    BusinessARVC.isFromFind = YES;
    [self.navigationController pushViewController:BusinessARVC animated:YES];
    
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"findViewCellIdentifierKey1";
    OTWFindViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWFindViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.indexPath = indexPath;
        //在此模块，以便重新布局
        OTWFindStatus *status=_status[indexPath.row];
        cell.status=status;
    }
    return cell;
}

#pragma mark - 代理方法
#pragma mark 重新设置单元格高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}


-(UIView*)SearchBar{
    if(!_SearchBar){
        _SearchBar=[[UIView alloc] initWithFrame:CGRectMake(15, 25.5, SCREEN_WIDTH-30, 34)];
        _SearchBar.layer.cornerRadius = 20;
        _SearchBar.layer.masksToBounds = YES;
        _SearchBar.backgroundColor=[UIColor color_f4f4f4];
        
        UITapGestureRecognizer  *tapGesturSearch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForSearch)];
        [_SearchBar addGestureRecognizer:tapGesturSearch];
        
        UILabel *searchText=[[UILabel alloc]init];
        searchText.text=@"搜索附近的美食，商场";
        searchText.textColor=[UIColor color_979797];
        searchText.font=[UIFont systemFontOfSize:14];
        [searchText sizeToFit];
        searchText.frame=CGRectMake((SCREEN_WIDTH-(searchText.Witdh+15+10))/2, (_SearchBar.Height-searchText.Height)/2, searchText.Witdh, searchText.Height);
        
        UIImageView *searchIcon=[[UIImageView alloc]initWithFrame:CGRectMake(searchText.MaxX-15-10-searchText.Witdh,(_SearchBar.Height-15)/2 , 15, 15)];
        searchIcon.image=[UIImage imageNamed:@"sousuo_1"];
        
        [_SearchBar addSubview:searchText];
        [_SearchBar addSubview:searchIcon];
        
    }
    return _SearchBar;
}

-(void)tapActionForSearch{
    
    OTWBusinessListSearchViewController *findSearchVC = [[OTWBusinessListSearchViewController alloc] init];
    findSearchVC.delegate = self;
    findSearchVC.isFromFind = YES;
    [self.navigationController pushViewController:findSearchVC animated:NO];

}
#pragma mark OTWFindViewCellDelegate

- (void)selectedWithTypeId:(NSNumber *)typeId andIndexpath:(NSIndexPath *)indexpath
{
    OTWBusinessARViewController *BusinessARVC = [[OTWBusinessARViewController alloc] init];
    OTWFindStatus *status=_status[indexpath.row];
    BusinessARVC.typeId = [NSString stringWithFormat:@"%@,%@",status.typeId,typeId];
    BusinessARVC.sortId = [NSString stringWithFormat:@"%@",typeId];
    BusinessARVC.firstID = [NSString stringWithFormat:@"%@",status.typeId];
    BusinessARVC.isFromFind = YES;

    [self.navigationController pushViewController:BusinessARVC animated:YES];
}
#pragma mark OTWBusinessListSearchViewControllerDelegate

- (void)searchWithStr:(NSString *)searchText
{

}

@end
