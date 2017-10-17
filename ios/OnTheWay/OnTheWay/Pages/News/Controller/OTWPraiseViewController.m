//
//  OTWPraiseViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import "OTWPraiseViewController.h"
#import "OTWPraiseViewModel.h"
#import "OTWNewsCommentTableCell.h"
#import "OTWPraiseParameter.h"

@interface OTWPraiseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<OTWPraiseViewModel *> *hotestPraises;
@property (nonatomic, strong) NSMutableArray<OTWNewsCommentTableCell *> *hotestPraiseCells;
@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UIView *headerV;
@property (nonatomic,strong) OTWPraiseParameter *Parameter;
@property (nonatomic,strong) UIView *noResultView;
@property (nonatomic,strong) UIImageView *noResultImage;
@property (nonatomic,strong) UILabel *noResultLabelOne;
@property (nonatomic,strong) UILabel *noResultLabelTwo;
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
    
    _hotestPraises = @[].mutableCopy;
    
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
        _tableV = [[UITableView alloc] initWithFrame: CGRectMake(0, 74, SCREEN_WIDTH,SCREEN_HEIGHT - 74) style:UITableViewStylePlain];
        _tableV.dataSource = self;
        _tableV.delegate = self;
        _tableV.backgroundColor = [UIColor clearColor];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.Parameter.number = 0;
            [self initData];
        }];
        
        _tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.Parameter.number++;
            [self initData];
        }];
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
    NSString * url = @"/app/message/like/search";
    [OTWNetworkManager doGET:url parameters:self.Parameter.mj_keyValues responseCache:^(id responseCache) {
        if([[NSString stringWithFormat:@"%@",responseCache[@"code"]] isEqualToString:@"0"]){
            NSArray *arr = [NSArray arrayWithArray:[[responseCache objectForKey:@"body"] objectForKey:@"content"]];
            if (self.Parameter.number == 0 && arr.count > 0) {
                for (NSDictionary *result in arr)
                {
                    OTWPraiseViewModel * model = [OTWPraiseViewModel mj_objectWithKeyValues:result];
                    [_hotestPraises addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableV reloadData];
                    [_tableV.mj_header endRefreshing];
                    [_tableV.mj_footer endRefreshing];
                });
            }

        }
    } success:^(id responseObject) {
        if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
            if (self.Parameter.number == 0) {
                [_hotestPraises removeAllObjects];
            }
            NSArray *arr = [NSArray arrayWithArray:[[responseObject objectForKey:@"body"] objectForKey:@"content"]];
            for (NSDictionary *result in arr)
            {
                OTWPraiseViewModel * model = [OTWPraiseViewModel mj_objectWithKeyValues:result];
                [_hotestPraises addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.Parameter.number == 0 && arr.count == 0) {
                    [self.view addSubview:self.noResultView];
                }
                if (arr.count == 0 || arr.count < 15) {
                    [_tableV.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_tableV.mj_footer endRefreshing];
                }
                [_tableV reloadData];
                [_tableV.mj_header endRefreshing];
            });
        }
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self errorTips:@"网络请求失败" userInteractionEnabled:YES];
        });
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark返回每行单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UIPraiseTableViewCellIdentifierKey";
    OTWNewsCommentTableCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OTWNewsCommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    OTWPraiseViewModel  *praise = _hotestPraises[indexPath.row];
    cell.praiseModel = praise;
    return cell;
}

#pragma mark 代理方法
#pragma mark 重新设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (OTWPraiseParameter *)Parameter
{
    if (!_Parameter) {
        _Parameter = [[OTWPraiseParameter alloc] init];
        _Parameter.clear = YES;
        _Parameter.number = 0;
        _Parameter.size = 15;
        _Parameter.currentTime = nil;
    }
    return _Parameter;
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
        _noResultImage.image=[UIImage imageNamed:@"qx_wuzan"];
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
        _noResultLabelTwo.text=@"为你的足迹点赞呢";
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.userInteractionEnabled = NO;
    return hud;
}
@end
