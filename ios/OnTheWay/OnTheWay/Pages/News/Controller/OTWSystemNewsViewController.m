//
//  OTWSystemNewsViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/16.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWSystemNewsViewController.h"
#import "OTWSystemNewsModel.h"
#import "OTWSystemNewsCellFrame.h"
#import "OTWSystemNewsCell.h"
#import "OTWSystemNewsDetailViewController.h"

@interface OTWSystemNewsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *systemNewsTableView;
@property (nonatomic,strong) NSMutableArray *sysNewsFrames;

@end

@implementation OTWSystemNewsViewController
{
    NSInteger _page;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 0;
    _sysNewsFrames = @[].mutableCopy;
    [self buildUI];
    [self loadData];
}

- (void) buildUI
{
    //设置标题
    self.title = @"系统消息";
    //设置返回图标
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    //大背景颜色
    self.view.backgroundColor=[UIColor color_f4f4f4];
    //添加到主视图
    [self.view addSubview:self.systemNewsTableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count=%ld",self.sysNewsFrames.count);
    return self.sysNewsFrames.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OTWSystemNewsCell cellWithTableView:tableView systemNewsCellframe:self.sysNewsFrames[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTWSystemNewsDetailViewController * detail = [[OTWSystemNewsDetailViewController alloc] init];
    detail.model = self.sysNewsFrames[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)loadData
{
    NSString * url = @"/app/message/system/search";
    NSDictionary * parameter = @{@"number":@(_page),
                                 @"size":@(15),
                                 @"clear":@(1)};
    [OTWNetworkManager doGET:url parameters:parameter success:^(id responseObject) {
        if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
            if (_page == 0) {
                [_sysNewsFrames removeAllObjects];
            }
            NSArray * arr = [[responseObject objectForKey:@"body"] objectForKey:@"content"];
            for (NSDictionary * result in arr) {
                OTWSystemNewsModel * model = [OTWSystemNewsModel mj_objectWithKeyValues:result];
                [self.sysNewsFrames addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_page == 0 && arr.count == 0) {
                    //                       [self.view addSubview:self.noResultView];
                }
                if (arr.count == 0 || arr.count < 15) {
                    [_systemNewsTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_systemNewsTableView.mj_footer endRefreshing];
                }
                [_systemNewsTableView reloadData];
                [_systemNewsTableView.mj_header endRefreshing];
            });
        }

    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [OTWUtils alertFailed:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO target:self];
            [_systemNewsTableView.mj_header endRefreshing];
            [_systemNewsTableView.mj_footer endRefreshing];
        });
    }];
    
}

- (UITableView*)systemNewsTableView
{
    if (!_systemNewsTableView) {
        _systemNewsTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, self.navigationHeight + 1, self.view.width, self.view.height - self.navigationHeight - 1) style:UITableViewStyleGrouped];
        _systemNewsTableView.dataSource = self;
        _systemNewsTableView.delegate = self;
        _systemNewsTableView.backgroundColor = [UIColor clearColor];
        
        _systemNewsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 0;
            [self loadData];
        }];
        
        _systemNewsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self loadData];
        }];
    }
    return _systemNewsTableView;
}

@end
