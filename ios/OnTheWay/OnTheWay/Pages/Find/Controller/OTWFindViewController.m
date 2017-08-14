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


@interface OTWFindViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_status;
}
@property (nonatomic,strong) CHCustomSearchBar *SearchBar;
@end

@implementation OTWFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化数据
    [self initData];
    
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
    OTWFindBusinessmenViewController *FindBusinessmenVC = [[OTWFindBusinessmenViewController alloc] init];
    [self.navigationController pushViewController:FindBusinessmenVC animated:YES];
    
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


-(CHCustomSearchBar*)SearchBar{
    if(!_SearchBar){
        _SearchBar=[[CHCustomSearchBar alloc] initWithFrame:CGRectMake(15, 25.5, SCREEN_WIDTH-30, 34)];
        [_SearchBar setPlaceholder:@"搜索附近的美食、商城"];
        [_SearchBar setContentMode:UIViewContentModeCenter];
        _SearchBar.layer.cornerRadius = 20;
        _SearchBar.layer.masksToBounds = YES;
        
        //自定义搜索框的大小
        _SearchBar.textFieldInset=UIEdgeInsetsMake(0,0,0,0);
        
        //替换搜索图标
        [_SearchBar setImage:[UIImage imageNamed:@"sousuo_1"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        //这个枚举可以对searchBar进行修改
        _SearchBar.searchBarStyle = UISearchBarStyleProminent;
        
        
        UITextField *searchField = nil;
        for (UIView *subview in  _SearchBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIView")]&&subview.subviews.count>0) {
                subview.backgroundColor = [UIColor color_f4f4f4];
                [[subview.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        //的到搜索框 并设置他的属性
        searchField = [[[_SearchBar.subviews firstObject] subviews] lastObject];
        searchField.layer.cornerRadius = 30;
        searchField.layer.masksToBounds = YES;
        searchField.layer.borderColor = [UIColor clearColor].CGColor;
        searchField.backgroundColor=[[UIColor color_f4f4f4]colorWithAlphaComponent:0.9f];
        searchField.layer.borderWidth = 0.5;
        _SearchBar.delegate = self;
        
    }
    return _SearchBar;
}


@end
