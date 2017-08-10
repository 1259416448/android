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

@interface OTWSearchShopListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
}

@end

@implementation OTWSearchShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI{
    //设置标题 搜索--商家详情
    self.title = @"搜索出来的商家列表";
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65-20) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    [self.view addSubview:_tableView];
    
}
#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}
#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
}
#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"OTWSearchShopListViewCellIdentifierKey";
    OTWSearchShopListViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWSearchShopListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
    }
    
    return cell;
}

#pragma mark - 代理方法
#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OTWSearchShopListViewCell *cell = (OTWSearchShopListViewCell *)[self tableView:tableView
                                                       cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
