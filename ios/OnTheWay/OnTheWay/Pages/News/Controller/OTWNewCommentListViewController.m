//
//  OTWNewCommentListViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewCommentListViewController.h"
#import "OTWNewsCommentModel.h"
#import "OTWNewsCommentTableCell.h"
#import "OTWSystemNewService.h"
#import "OTWNewsSearchParams.h"
#import <MJExtension.h>
#import <MJRefresh.h>

@interface OTWNewCommentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<OTWNewsCommentTableCell *> *commentTableCells;
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic,strong) UIView *headerV;
@property (nonatomic,strong) OTWNewsSearchParams *newsSearchParams;
@property (nonatomic,strong) NSMutableArray<OTWNewsCommentModel *> *commentArr;
@property (nonatomic,strong) NSDictionary *reponseCacheData;

@end

@implementation OTWNewCommentListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupBase];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchNewComments:YES];
}

- (void)setupBase
{
    self.title = @"新的评论";
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullComments)];
    self.tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor = [UIColor color_f4f4f4];
    [self.view addSubview:self.tableV];
}

- (UITableView *)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableV.dataSource = self;
        _tableV.delegate = self;
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

- (NSMutableArray<OTWNewsCommentModel*>*)commentArr
{
    if (!_commentArr) {
        _commentArr = [[NSMutableArray alloc] init];
    }
    return _commentArr;
}

- (NSMutableArray<OTWNewsCommentTableCell*>*)commentTableCells
{
    if (!_commentTableCells) {
        _commentTableCells = [[NSMutableArray alloc] init];
    }
    return _commentTableCells;
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
    return self.commentArr.count;
}

#pragma mark返回每行单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UINewsCommentTableViewCellIdentifierKey";
    OTWNewsCommentTableCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OTWNewsCommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.commentModel = self.commentArr[indexPath.row];
    [self.commentTableCells addObject:cell];
    return cell;
}

#pragma mark 代理方法
#pragma mark 重新设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTWNewsCommentTableCell *cell = (OTWNewsCommentTableCell *)[self tableView:tableView
                                                                     cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (OTWNewsSearchParams*)newsSearchParams
{
    if (!_newsSearchParams) {
        _newsSearchParams = [[OTWNewsSearchParams alloc] init];
        _newsSearchParams.number = 0;
        _newsSearchParams.size = 2;
        _newsSearchParams.clear = false;
    }
    return _newsSearchParams;
}

- (void)loadMoreComments
{
    [self fetchNewComments:NO];
}

- (void)pullComments
{
    self.newsSearchParams.number = 0;
    self.newsSearchParams.currentTime = nil;
    [self fetchNewComments:YES];
}

#pragma mark 加载新的评论 reflesh是否清空所有数据
-(void)fetchNewComments:(BOOL)reflesh
{
    [self sendRequest:self.newsSearchParams.mj_keyValues completion:^(id result) {
        self.newsSearchParams.currentTime = result[@"currentTime"];
        NSArray *dataArr = result[@"body"][@"content"];
        if (dataArr && dataArr.count > 0) {
            if (reflesh) {
                [self.commentArr removeAllObjects];
            }
            for (NSDictionary *dict in dataArr) {
                OTWNewsCommentModel *commentModel = [OTWNewsCommentModel commentModelWithDictionary:dict];
                [self.commentArr addObject:commentModel];
            }
            DLog(@"模型数组%@",[OTWNewsCommentModel mj_keyValuesArrayWithObjectArray:self.commentArr]);
            [self.tableV reloadData];
            if (dataArr.count < self.newsSearchParams.size) {
                [self.tableV.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.newsSearchParams.number += 1;
                [self.tableV.mj_footer endRefreshing];
            }
        } else {
            [self.tableV.mj_footer endRefreshingWithNoMoreData];
        }
        self.tableV.mj_footer.hidden = NO;
        [self.tableV.mj_header endRefreshing];
    }];
}

-(void)sendRequest:(NSDictionary *)params completion:(requestBackBlock)block
{
    [OTWSystemNewService loadAllNewComments:params completion:^(id result, NSError *error) {
        if (result) {
            if ([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]) {
                if (block) {
                    block(result);
                }
            } else {
                [self errorTips:@"服务器繁忙，请稍后再试" userInteractionEnabled:NO];
                [self.tableV.mj_footer endRefreshing];
                [self.tableV.mj_header endRefreshing];
                if (self.reponseCacheData) {
                    if (block) {
                        block(self.reponseCacheData);
                    }
                }
            }
        } else {
            [self netWorkErrorTips:error];
            [self.tableV.mj_footer endRefreshing];
            [self.tableV.mj_header endRefreshing];
            if(self.reponseCacheData){
                if (block) {
                    block(self.reponseCacheData);
                }
            }
        }
    } responseCacheFun:^(id responseCache) {
        self.reponseCacheData = responseCache;
    }];
}

@end
