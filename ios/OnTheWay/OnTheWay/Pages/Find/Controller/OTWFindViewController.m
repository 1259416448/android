//
//  OTWFindViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWCustomNavigationBar.h"
#import "OTWFindViewCell.h"
#import "OTWFindViewController.h"
#import "OTWFindModel.h"

@interface OTWFindViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_status;
}
@end

@implementation OTWFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    [self initData];
    
    [self buildUI];
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    [self.view addSubview:_tableView];
    
}

#pragma mark 构造数据
-(void)initData{

    _status = [[NSMutableArray alloc] init];
    NSDictionary *dic=@{@"Id":@(1),@"FindTpyeBackgroundImageUrl":@"http://img04.tooopen.com/thumbnails/20130701/x_20083555.jpg",@"FindTpyeName":@"餐饮",@"FindTpyeContentList":@[@[@"自助餐",@"zizhucan"],@[@"咖啡",@"kafei"],@[@"火锅",@"huoguo"]]};
    
    NSDictionary *dic2=@{@"Id":@(2),@"FindTpyeBackgroundImageUrl":@"http://img02.tooopen.com/images/20141229/sl_107003776898.jpg",@"FindTpyeName":@"商店",@"FindTpyeContentList":@[@[@"购物",@"gouwu"],@[@"书店",@"shudian"],@[@"便利店",@"bianlidian"]]};
    
    NSDictionary *dic3=@{@"Id":@(2),@"FindTpyeBackgroundImageUrl":@"http://img05.tooopen.com/images/20150201/sl_109938035874.jpg",@"FindTpyeName":@"文娱",@"FindTpyeContentList":@[@[@"电影院",@"dianyingyuan"],@[@"博物馆",@"bowuguan"]]};
    
    NSDictionary *dic4=@{@"Id":@(2),@"FindTpyeBackgroundImageUrl":@"http://img06.tooopen.com/images/20170514/tooopen_sl_210122172463.jpg",@"FindTpyeName":@"交通",@"FindTpyeContentList":@[@[@"巴士",@"bashi"],@[@"地铁",@"ditie"],@[@"出租",@"chuzu"],@[@"飞机",@"feiji"]]};
    
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
    
    self.title = @"首页";
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];

}

#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _status.count;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    OTWFindViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWFindViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //在此模块，以便重新布局
    OTWFindStatus *status=_status[indexPath.row];
    cell.status=status;
    return cell;
}

#pragma mark - 代理方法
#pragma mark 重新设置单元格高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
