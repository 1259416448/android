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
#import "OTWCustomNavigationBar.h"
#import <MJExtension.h>
#import <MJRefresh.h>

@interface OTWNewCommentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<OTWNewsCommentTableCell *> *commentTableCells;
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic,strong) UIView *headerV;
@property (nonatomic,strong) OTWNewsSearchParams *newsSearchParams;
@property (nonatomic,strong) NSMutableArray<OTWNewsCommentModel *> *commentArr;
@property (nonatomic,strong) NSDictionary *reponseCacheData;

@property (nonatomic,strong) UIView *noResultView;
@property (nonatomic,strong) UIImageView *noResultImage;
@property (nonatomic,strong) UILabel *noResultLabelOne;
@property (nonatomic,strong) UILabel *noResultLabelTwo;

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
    [self.view bringSubviewToFront:self.customNavigationBar];
}

- (UITableView *)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStyleGrouped];
        _tableV.dataSource = self;
        _tableV.delegate = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
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
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.commentModel = self.commentArr[indexPath.row];
    [self.commentTableCells addObject:cell];
    return cell;
}

#pragma mark 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTWNewsCommentModel * model = self.commentArr[indexPath.row];
    OTWFootprintDetailController *VC =  [[OTWFootprintDetailController alloc] init];
    [VC setFid:[NSString stringWithFormat:@"%@",model.commentId]];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark 重新设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (OTWNewsSearchParams*)newsSearchParams
{
    if (!_newsSearchParams) {
        _newsSearchParams = [[OTWNewsSearchParams alloc] init];
        _newsSearchParams.number = 0;
        _newsSearchParams.size = 15;
        _newsSearchParams.clear = YES;
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
                OTWNewsCommentModel *commentModel = [OTWNewsCommentModel mj_objectWithKeyValues:dict];
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
            [self.view addSubview:self.noResultView];
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
-(UIView *)noResultView{
    if(!_noResultView){
        _noResultView=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight+1, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationHeight)];
        _noResultView.backgroundColor=[UIColor whiteColor];
        [_noResultView addSubview:self.noResultImage];
        [_noResultView addSubview:self.noResultLabelOne];
        [_noResultView addSubview:self.noResultLabelTwo];
    }
    
    return _noResultView;
}
-(UIImageView*)noResultImage{
    if(!_noResultImage){
        _noResultImage=[[UIImageView alloc]init];
        _noResultImage.frame=CGRectMake((SCREEN_WIDTH-151)/2, 130, 151, 109);
        _noResultImage.image=[UIImage imageNamed:@"qx_wupinglun"];
    }
    return _noResultImage;
}

-(UILabel*)noResultLabelOne{
    if(!_noResultLabelOne){
        _noResultLabelOne=[[UILabel alloc]init];
        _noResultLabelOne.text=@"还没有小伙伴";
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
        _noResultLabelTwo.text=@"评论你的足迹呢";
        _noResultLabelTwo.font=[UIFont systemFontOfSize:13];
        _noResultLabelTwo.textColor=[UIColor color_979797];
        [_noResultLabelTwo sizeToFit];
        _noResultLabelTwo.frame=CGRectMake(0, self.noResultLabelOne.MaxY+10, SCREEN_WIDTH, _noResultLabelTwo.Height);
        _noResultLabelTwo.textAlignment=NSTextAlignmentCenter;
    }
    return _noResultLabelTwo;
}
-(MBProgressHUD *) addLoadingHud
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableV animated:YES];
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.userInteractionEnabled = NO;
    return hud;
}

@end
