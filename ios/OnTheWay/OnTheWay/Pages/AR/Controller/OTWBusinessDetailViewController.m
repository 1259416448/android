//
//  OTWBusinessDetailViewController.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/5.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessDetailViewController.h"
#import "OTWBusinessDetailView.h"
#import "OTWBusinessModel.h"
#import "OTWBusinessDetailService.h"
#import "OTWCustomNavigationBar.h"
#import "OTWNotCommentView.h"

#import <MJExtension.h>

@interface OTWBusinessDetailViewController () <UITableViewDelegate,UITableViewDataSource,OTWBusinessDetailViewDelegate>

//第一次进入页面时，加载提示View
@property (nonatomic,strong) UIView *firstLoadingView;

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong) UILabel *errorTipsLabel;

@property (nonatomic,strong) UIView *customRightNavigationBarView;

//收藏button
@property (nonatomic,strong) UIButton *collectBtn;

//分享button
@property (nonatomic,strong) UIButton *shareBtn;


@property (nonatomic,strong) OTWBusinessModel *businessModel;


@property (nonatomic,strong) NSString *opId;

//Service
@property (nonatomic,strong) OTWBusinessDetailService *service;

//视图信息保存位置
@property (nonatomic,strong) UITableView *businessDetailTableView;

@property (nonatomic,strong) UIView *tableViewHeaderBG;

@property (nonatomic,strong) OTWBusinessDetailView *detailView;

@property (nonatomic,strong) OTWNotCommentView *notCommentView;

@property (nonatomic,strong) NSMutableArray *footprints;

@end

@implementation OTWBusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) buildUI
{
    self.title = @"商家详情";
    
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    //右侧信息需要自定义
    [self.customRightNavigationBarView addSubview:self.collectBtn];
    
    [self.customRightNavigationBarView addSubview:self.shareBtn];
    
    [self setCustomNavigationRightView:self.customRightNavigationBarView];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    [self.view addSubview:self.firstLoadingView];
}

/**
 * 点击了收藏
 */
#pragma mark - collectBtnClick 点击了收藏
- (void) collectBtnClick{
    DLog(@"点击了收藏");
}

/**
 * 点击了分享
 */
#pragma mark - shareBtnClick 点击了分享
- (void) shareBtnClick {
    DLog(@"点击了分享");
}

/**
 * 加载商家数据，视图展示都需要在数据加载成功之后才展现
 */
- (void) loadBusinessData
{
    [self.service fetchBusinessDetail:self.opId completion:^(id result, NSError *error) {
        if(result){
            [self loadDataSuccess:result];
        }else{
            [self loadDataError:error];
        }
    }];
}

/**
 * 数据加载成功处理
 */
- (void) loadDataSuccess:(id)result
{
    if ([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]) {
        [self.indicatorView stopAnimating];
        self.businessModel = [OTWBusinessModel mj_objectWithKeyValues:result[@"body"]];
        //虚拟展示一些数据
        NSArray *array = @[@{
                               @"name":@"送优惠券",
                               @"colorStr":@"FF5959",
                               @"typeName":@"券",
                               @"url":@""
                               },@{
                               @"name":@"促销大瓶果粒橙",
                               @"colorStr":@"61CB60",
                               @"typeName":@"促",
                               @"url":@""
                               },@{
                               @"name":@"支持团购",
                               @"colorStr":@"FB903E",
                               @"typeName":@"团",
                               @"url":@""
                               }];
        NSMutableArray<OTWBusinessActivityModel *> *activitys = [OTWBusinessActivityModel mj_objectArrayWithKeyValuesArray:array];
        self.businessModel.activitys = activitys;
        
        NSArray *array1 = @[
                            @"http://osx4pwgde.bkt.clouddn.com/2A685CCB9BA44C2EB24B8ABDCF14FD77",
                            @"http://osx4pwgde.bkt.clouddn.com/E9EEECD8DFD54FFEB7E013629E8C6D33",
                            @"http://osx4pwgde.bkt.clouddn.com/EDE74BBCCA644B7EB9DDE9DB463D66FD",
                            ];
        
        NSArray<NSString *> *photoUrls = [NSString mj_objectArrayWithKeyValuesArray:array1];
        self.businessModel.photoUrls = photoUrls;
        self.businessModel.businessPhotoNum = 4;
        
        [self buildTableView];
    }else{
        if([result[@"messageCode"] isEqualToString:@"000405"]){
            [self.indicatorView stopAnimating];
            self.errorTipsLabel.text = @"商家信息不存在或已被删除";
            //发出商家删除通知
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.opId,@"businessId", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"businessAlreadyDeleted" object:nil userInfo:dict];
        }else{
            [OTWUtils alertFailed:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO target:self];
        }
    }
}

//数据加载成功后构建UI界面
- (void) buildTableView
{
    //创建头部TableView
    [self.view addSubview:self.businessDetailTableView];
    [self.view bringSubviewToFront:self.customNavigationBar];
    //设置 tableViewHeaderBG height
    [self setTableViewHeaderBGViewFrame];
    self.businessDetailTableView.tableHeaderView = self.tableViewHeaderBG;
}

//设置大家说标题
- (void) setTableViewHeaderBGViewFrame
{
    [self.tableViewHeaderBG addSubview:self.detailView];
    [self.tableViewHeaderBG addSubview:self.notCommentView];
    [self changeCommentStatus];
}

/**
 * 设置缺省信息
 */
- (void) changeCommentStatus
{
    [self.notCommentView hiddenDefaultView:self.footprints.count != 0];
    self.tableViewHeaderBG.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.notCommentView.MaxY);
}


#pragma mark - UITableViewDelegate
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

/**
 * 数据加载失败处理
 */
- (void) loadDataError:(NSError *) error
{
    [self netWorkErrorTips:error];
}

- (void) changeCollectStauts
{
    if(self.businessModel.ifLike){
        [self.collectBtn setImage:[UIImage imageNamed:@"ar_shoucang_click"] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"ar_shoucang"] forState:UIControlStateNormal];
    }
}


#pragma mark - OTWBusinessDetailViewDelegate
- (void)businessTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"点击了优惠信息");
}

#pragma mark - Setter Getter

- (UIView *) firstLoadingView
{
    if(!_firstLoadingView){
        _firstLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, 50)];
        _firstLoadingView.backgroundColor = [UIColor clearColor];
        [_firstLoadingView addSubview:self.indicatorView];
        [_firstLoadingView addSubview:self.errorTipsLabel];
    }
    return _firstLoadingView;
}

- (UIActivityIndicatorView *) indicatorView
{
    if(!_indicatorView){
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 15, 0, 30, 30)];
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}

- (UILabel *) errorTipsLabel
{
    if(!_errorTipsLabel){
        _errorTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _errorTipsLabel.textColor = [UIColor color_757575];
        _errorTipsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _errorTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _errorTipsLabel;
}

- (UIView *) customRightNavigationBarView
{
    if(!_customRightNavigationBarView){
        _customRightNavigationBarView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 85, 20, 80, 44)];
        _customRightNavigationBarView.backgroundColor = [UIColor clearColor];
    }
    return _customRightNavigationBarView;
}

- (UIButton *) collectBtn
{
    if(!_collectBtn){
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectBtn.frame = CGRectMake(0, 0, 40, 44);
        [_collectBtn setImage:[UIImage imageNamed:@"ar_shoucang"] forState:UIControlStateNormal];
        _collectBtn.imageEdgeInsets = UIEdgeInsetsMake(12,10,12,10);
        [_collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}

- (UIButton *) shareBtn
{
    if(!_shareBtn){
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(40, 0, 40, 44);
        [_shareBtn setImage:[UIImage imageNamed:@"ar_fenxiang_blue"] forState:UIControlStateNormal];
        _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(12,10,12,10);
        [_shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (OTWBusinessDetailService *) service
{
    if(!_service){
        _service = [[OTWBusinessDetailService alloc] init];
    }
    return _service;
}

- (UITableView *) businessDetailTableView
{
    if(!_businessDetailTableView){
        _businessDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationHeight) style:UITableViewStyleGrouped];
        _businessDetailTableView.backgroundColor = [UIColor clearColor];
        _businessDetailTableView.delegate = self;
        _businessDetailTableView.dataSource = self;
    }
    return _businessDetailTableView;
}

- (OTWBusinessDetailView *) detailView
{
    if(!_detailView){
        _detailView = [[OTWBusinessDetailView alloc] initWithBusinessDetailModel:self.businessModel];
        _detailView.delegate = self;
    }
    return _detailView;
}

- (UIView *) tableViewHeaderBG
{
    if(!_tableViewHeaderBG){
        _tableViewHeaderBG = [[UIView alloc] init];
        _tableViewHeaderBG.backgroundColor = [UIColor clearColor];
    }
    return _tableViewHeaderBG;
}

- (OTWNotCommentView *) notCommentView
{
    if(!_notCommentView){
        _notCommentView = [[OTWNotCommentView alloc] initWithTitleName:@"大家说"];
        _notCommentView.frame = CGRectMake(0, self.detailView.MaxY + 10, self.notCommentView.Witdh, self.notCommentView.Height);
    }
    return _notCommentView;
}

- (NSMutableArray *) footprints
{
    if(!_footprints){
        _footprints = [[NSMutableArray alloc] init];
    }
    return _footprints;
}

/**
 * 设置商家数据，加载数据
 */
- (void) setOpData:(NSString *)opId
{
    self.opId = opId;
    [self loadBusinessData];
}

@end
