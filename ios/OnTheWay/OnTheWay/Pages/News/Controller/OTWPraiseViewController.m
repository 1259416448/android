//
//  OTWPraiseViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import "OTWPraiseViewController.h"
#import "OTWPraiseViewModel.h"
#import "OTWPraiseViewTableCell.h"

@interface OTWPraiseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<OTWPraiseViewModel *> *hotestPraises;
@property (nonatomic, strong) NSMutableArray<OTWPraiseViewTableCell *> *hotestPraiseCells;
@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UIView *headerV;

@end

static NSString *const praiseID = @"praise";

@implementation OTWPraiseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBase];
    
    [self initData];
    
}

- (void)setupBase
{
    //设置标题
    self.title = @"新的赞";
    //设置返回图标
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    //主背景颜色
    self.view.backgroundColor=[UIColor color_f4f4f4];
    //添加到主视图
    [self.view addSubview:self.tableV];
}

- (UITableView *)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame: CGRectMake(0, self.navigationHeight, SCREEN_WIDTH,SCREEN_HEIGHT - self.navigationHeight) style:UITableViewStylePlain];
        _tableV.dataSource = self;
        _tableV.delegate = self;
        _tableV.separatorColor  = [UIColor color_f4f4f4];
        _tableV.backgroundColor = [UIColor clearColor];
        _tableV.tableHeaderView = self.headerV;
    }
    return _tableV;
}

- (UIView *)headerV
{
    if (!_headerV) {
        _headerV = [[UIView alloc] init];
        _headerV.backgroundColor = [UIColor color_f4f4f4];
        _headerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    }
    return _headerV;
}

#pragma mark 加载数据
- (void)initData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"OTWPraise.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    _hotestPraises = [[NSMutableArray alloc] init];
    _hotestPraiseCells = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj=%@ idx=%ld",obj,idx);
        [_hotestPraises addObject:[OTWPraiseViewModel statusWithDictionary:obj]];
        OTWPraiseViewTableCell *cell = [[OTWPraiseViewTableCell alloc] init];
        [_hotestPraiseCells addObject:cell];
    }];
}

#pragma mark 数据源方法
#pragma mark 返回分组数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _hotestPraises.count;
}

#pragma mark返回每行单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UIPraiseTableViewCellIdentifierKey";
    OTWPraiseViewTableCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OTWPraiseViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    OTWPraiseViewModel  *praise = _hotestPraises[indexPath.row];
    cell.praiseModel = praise;
    return cell;
}

#pragma mark 代理方法
#pragma mark 重新设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTWPraiseViewTableCell *cell = _hotestPraiseCells[indexPath.row];
    cell.praiseModel = _hotestPraises[indexPath.row];
    NSLog(@"x=%ld",(long)indexPath.row);
    NSLog(@"x=%ld",(long)_hotestPraiseCells.count);
    if (indexPath.row == _hotestPraiseCells.count - 1) {
        NSLog(@"ok");
        return cell.height + 20;
    }
    return cell.height;
}
@end
