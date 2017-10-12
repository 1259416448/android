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
#import "OTWBusinessFootprintFrame.h"
#import "OTWBusinessFootprintTableViewCell.h"
#import "OTWPersonalFootprintsListController.h"
#import "OTWUserModel.h"
#import "OTWFootprintService.h"
#import "OTWFootprintReleaseViewController.h"
#import "OTWBusinessAlbumViewController.h"

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

@property (nonatomic,strong) NSMutableArray<OTWBusinessFootprintFrame *> *footprints;

//底部发布button
@property(nonatomic,strong) UIButton *fabiaoButton;

@end

@implementation OTWBusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
    
    //增加通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedFootprint:) name:@"foorprintAlreadyDeleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshBusinessFootprint:) name:@"refleshFootprint" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addReleasedFootprint:) name:@"releasedFoorprint" object:nil];
    
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
 * 通知的形式更新一个商户足迹详情信息
 * 为了防止点击详情后，足迹信息与列表中的回复数据不一致
 */
- (void) refleshBusinessFootprint:(NSNotification*)sender
{
    NSDictionary *dict = sender.userInfo;
    if(!dict) return;
    if(!dict[@"footprintId"]) return;
    
    NSString *footprintId = dict[@"footprintId"];
    OTWFootprintListModel *footprintDetail;
    for (OTWBusinessFootprintFrame *one in self.footprints) {
        if([footprintId isEqualToString:one.footprintDetail.footprintId.description]){
            footprintDetail = one.footprintDetail;
            break;
        }
    }
    
    NSNumber *footprintLikeNum = dict[@"footprintLikeNum"];
    NSNumber *footprintCommentNum = dict[@"footprintCommentNum"];
    NSNumber *ifLike = dict[@"ifLike"];
    footprintDetail.footprintLikeNum = footprintLikeNum.integerValue;
    footprintDetail.footprintCommentNum = footprintCommentNum.integerValue;
    footprintDetail.ifLike = ifLike.boolValue;
    [self.businessDetailTableView reloadData];
}

/**
 * 详情页面中发现有被删除的足迹
 */
- (void) deletedFootprint:(NSNotification*)sender
{
    NSDictionary *dict = sender.userInfo;
    for (int i = 0; i<self.footprints.count; i++) {
        if([self.footprints[i].footprintDetail.footprintId.description isEqualToString:dict[@"footprintId"]]){
            [self.footprints removeObjectAtIndex:i];
            [self changeCommentStatus];
            [self.businessDetailTableView reloadData];
            break;
        }
    }
}

/**
 * 发布足迹后同步一下商家详情页
 */
- (void) addReleasedFootprint:(NSNotification*)sender
{
    [self changeCommentStatus];
    OTWFootprintListModel *footprintDetail = [OTWFootprintListModel initWithDict:sender.userInfo];
    if([footprintDetail.business.description isEqualToString:_opId]){
        footprintDetail.userId = [NSNumber numberWithInt:[[OTWUserModel shared].userId intValue]];
        footprintDetail.userHeadImg = [OTWUserModel shared].headImg;
        footprintDetail.userNickname = [OTWUserModel shared].name;
        OTWBusinessFootprintFrame *footprintFrame = [[OTWBusinessFootprintFrame alloc] initWithFootprint:footprintDetail];
        [self.footprints insertObject:footprintFrame atIndex:0];
        [self changeCommentStatus];
        [self.businessDetailTableView reloadData];
    }
}

/**
 * 点击了收藏
 */
#pragma mark - collectBtnClick 点击了收藏
- (void) collectBtnClick{
    DLog(@"点击了收藏");
    _collectBtn.selected = !_collectBtn.selected;
    NSString * tips = @"";
    if (_collectBtn.selected) {
        tips = @"收藏成功";
    }else{
        tips = @"取消收藏";
    }
    [ALiProgressHUD showImage:[UIImage imageNamed:@"ar_chenggongtishi"] status:tips];
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
        
        //构建足迹信息
        if(self.businessModel.footprints && self.businessModel.footprints.count > 0 ){
            for (OTWFootprintListModel *one in self.businessModel.footprints) {
                OTWBusinessFootprintFrame *footprintFrame = [[OTWBusinessFootprintFrame alloc] initWithFootprint:one];
                [self.footprints addObject:footprintFrame];
            }
        }
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
    
    //设置上拉刷新
    self.businessDetailTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFootprint)];
    
    //判断 如果 footprints.count == 0 没有评论数据
    
    if(self.footprints.count < [self.service getDefaultPageSize]){
        [self.businessDetailTableView.mj_footer endRefreshingWithNoMoreData];
        self.businessDetailTableView.mj_footer.hidden = YES;
    }
    
    [self.view bringSubviewToFront:self.customNavigationBar];
    //设置 tableViewHeaderBG height
    [self setTableViewHeaderBGViewFrame];
    self.businessDetailTableView.tableHeaderView = self.tableViewHeaderBG;
    
    [self.view addSubview:self.fabiaoButton];
}

//加载更多足迹
- (void)loadMoreFootprint
{
    [self.service fetchBusinessFootprints:self.opId currentTime:self.businessModel.currentTime completion:^(id result, NSError *error) {
        if(result){
            if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
                //请求成功，处理结果
                NSDictionary *body = result[@"body"];
                NSArray *content = body[@"content"];
                if(content && content.count > 0){
                    //构建数据
                    for (NSDictionary *dict in content) {
                        OTWFootprintListModel *footprintModel = [OTWFootprintListModel mj_objectWithKeyValues:dict];
                        OTWBusinessFootprintFrame *footprintFrame = [[OTWBusinessFootprintFrame alloc] initWithFootprint:footprintModel];
                        [self.footprints addObject:footprintFrame];
                    }
                    //判断是否请求结束
                    [self.businessDetailTableView reloadData];
                    if(content.count < self.service.getDefaultPageSize){
                        self.businessDetailTableView.mj_footer.hidden = YES;
                        [self.businessDetailTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        int currentPageNumber = self.service.getDefaultPageNumber;
                        currentPageNumber ++;
                        [self.service  setNumber:currentPageNumber];
                        [self.businessDetailTableView.mj_footer endRefreshing];
                    }
                } else { //无请求结果
                    self.businessDetailTableView.mj_footer.hidden = YES;
                    [self.businessDetailTableView.mj_footer endRefreshingWithNoMoreData];
                    [self.businessDetailTableView reloadData];
                }
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
        }else{
            [self netWorkErrorTips:error];
        }
    }];
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
    return self.footprints.count;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到足迹详情，当前的足迹详情不能跳转商圈信息
    OTWFootprintDetailController *VC =  [[OTWFootprintDetailController alloc] init];
    VC.ifBusiness = YES;
    [VC setFid:self.footprints[indexPath.row].footprintDetail.footprintId.description];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BusinessFootprintCell";
    OTWBusinessFootprintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [OTWBusinessFootprintTableViewCell cellWithTableView:tableView identifier:identifier];
        WeakSelf(self);
        cell.block = ^(UITableViewCell *cell){
            //然后使用indexPathForCell方法，就得到indexPath了~
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            OTWBusinessFootprintFrame *footprintFrame = weakself.footprints[indexPath.row];
            OTWPersonalFootprintsListController *personalSiteVC = [OTWPersonalFootprintsListController initWithIfMyFootprint:[[OTWUserModel shared].userId.description isEqualToString:footprintFrame.footprintDetail.userId.description]];
            personalSiteVC.userId = footprintFrame.footprintDetail.userId.description;
            personalSiteVC.userNickname = footprintFrame.footprintDetail.userNickname;
            personalSiteVC.userHeaderImg = footprintFrame.footprintDetail.userHeadImg;
            [weakself.navigationController pushViewController:personalSiteVC animated:YES];
        };
        
        cell.likeBlock= ^(UITableViewCell *cell){
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            OTWBusinessFootprintFrame *footprintFrame = weakself.footprints[indexPath.row];
            //设置了一个3秒内不能重复提交
            if(footprintFrame.likeTime - [NSDate date].timeIntervalSince1970 > - 3 ) return;
            if(footprintFrame.ifSubLike) return;
            footprintFrame.likeTime = [NSDate date].timeIntervalSince1970;
            [weakself likeFootprint:footprintFrame];
        };
    }
    [cell setData:self.footprints[indexPath.row]];
    return cell;
}

#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.footprints[indexPath.row].cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.f;
}

/**
 * 数据加载失败处理
 */
- (void) loadDataError:(NSError *) error
{
    [self netWorkErrorTips:error];
}

/**
 * 点赞操作
 */
-(void)likeFootprint:(OTWBusinessFootprintFrame *)footprintFrame
{
    if(!footprintFrame) return;
    OTWFootprintListModel *footprint = footprintFrame.footprintDetail;
    [OTWFootprintService likeFootprint:footprint.footprintId.description completion:^(id result, NSError *error) {
        if (result) {
            if ([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]) {
                NSString *tips = @"取消赞";
                if(footprint.ifLike){
                    footprint.ifLike = NO;
                    footprint.footprintLikeNum -- ;
                    [OTWUtils alertSuccess:tips userInteractionEnabled:NO target:self];
                }else{
                    tips = @"已点赞";
                    footprint.ifLike = YES;
                    footprint.footprintLikeNum ++ ;
                }
                [self.businessDetailTableView reloadData];
            }else{
                //判断是否被删除
                if([result[@"messageCode"] isEqualToString:@"000202"]){
                    for (int i = 0; i<self.footprints.count; i++) {
                        if([self.footprints[i].footprintDetail.footprintId.description isEqualToString:footprint.footprintId.description]){
                            [self.footprints removeObjectAtIndex:i];
                            [self.businessDetailTableView reloadData];
                            break;
                        }
                    }
                    [OTWUtils alertFailed:@"足迹已被删除" userInteractionEnabled:NO target:self];
                }else{
                    [OTWUtils alertFailed:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO target:self];
                }
            }
        }else{
            [self netWorkErrorTips:error];
        }
        footprintFrame.ifSubLike = NO;
    }];
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

- (void)morePhotoClick:(OTWBusinessDetailView *)detailView businessModel:(OTWBusinessModel *)businessModel
{
    DLog(@"点击了更多照片，需要跳转至相册页");
    OTWBusinessAlbumViewController * album = [[OTWBusinessAlbumViewController alloc] init];
    [self.navigationController pushViewController:album animated:YES];
}

- (void)goMapClick:(OTWBusinessDetailView *)detailView businessModel:(OTWBusinessModel *)businessModel
{
    DLog(@"点击了到这里");
}

- (void)checkInClick:(OTWBusinessDetailView *)detailView businessModel:(OTWBusinessModel *)businessModel
{
    DLog(@"点击了签到按钮");
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
        [_collectBtn setImage:[UIImage imageNamed:@"ar_shoucang_click"] forState:UIControlStateSelected];
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
        _businessDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

-(UIButton*)fabiaoButton{
    if(!_fabiaoButton){
        _fabiaoButton=[[UIButton alloc] init];
        _fabiaoButton.frame=CGRectMake(SCREEN_WIDTH - GLOBAL_PADDING - 69, SCREEN_HEIGHT - 69 - 12.5, 69, 69);
        [_fabiaoButton setImage:[UIImage imageNamed:@"ar_fabiao"] forState:UIControlStateNormal];
        [_fabiaoButton addTarget:self action:@selector(fabiaoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fabiaoButton;
}

/**
 * 点击了发布足迹按钮
 */
-(void)fabiaoButtonClick{
    if(![[OTWLaunchManager sharedManager] showLoginViewWithController:self completion:nil]){
        OTWFootprintReleaseViewController *releaseVC = [[OTWFootprintReleaseViewController alloc] init];
        [releaseVC setBusinessIdData:_opId];
        [self.navigationController pushViewController:releaseVC animated:YES];
    };
}

/**
 * 设置商家数据，加载数据
 */
- (void) setOpData:(NSString *)opId
{
    self.opId = opId;
    [self loadBusinessData];
}

- (void) dealloc
{
    //处理一些通知移除操作
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"foorprintAlreadyDeleted" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refleshFootprint" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"releasedFoorprint" object:nil];
}

@end
