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
#import <MJRefresh.h>

@interface OTWFootprintsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *footprintTableView;
@property (nonatomic,strong) NSMutableArray *footprintFrames;
@property (nonatomic,assign) NSInteger selectedIndex;

@end

@implementation OTWFootprintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController showTabBarWithAnimation:YES];
}

-(void)buildUI
{
    //设置标题
    self.title = @"足迹列表";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //默认【下拉刷新】
    self.footprintTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    //默认【上拉加载】
    self.footprintTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    [self.view addSubview:self.footprintTableView];
    
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
    //跳转
    [self.navigationController pushViewController:[[OTWLaunchManager sharedManager] footprintDetailController:self.selectedIndex != indexPath.row] animated:YES];
    _selectedIndex = indexPath.row;
    DLog(@"我点击了：%ld",indexPath.row);
}

#pragma mark 返回第indexPath这行对应的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OTWFootprintListTableViewCell cellWithTableView:tableView footprintListFrame:self.footprintFrames[indexPath.row]];
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
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"OTWFootprintList.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
        for (NSDictionary *dict in dictArray) {
            // 创建模型
            OTWFootprintListModel *model = [OTWFootprintListModel initWithDict:dict];
            // 根据模型数据创建frame模型
            OTWFootprintListFrame *frame = [[OTWFootprintListFrame alloc] init];
            [frame setFootprint:model];
            [models addObject:frame];
        }
        self.footprintFrames = [models copy];
        
    }
    return _footprintFrames;
}

-(UITableView*)footprintTableView{
    if(!_footprintTableView){
        _footprintTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
        _footprintTableView.dataSource = self;
        _footprintTableView.delegate = self;
        _footprintTableView.separatorStyle  = UITableViewCellSelectionStyleNone;
        _footprintTableView.backgroundColor = [UIColor clearColor];
    }
    return _footprintTableView;
}

@end
