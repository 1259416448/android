//
//  OTWPersonalFootprintsListController.m
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalFootprintsListController.h"
#import "OTWPersonalFootprintTableViewCell.h"
#import "OTWFootprintReleaseViewController.h"
#import "OTWPersonalFootprintService.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OTWCustomNavigationBar.h"
#import "OTWPersonalStatisticsModel.h"
#import "OTWMyInfoView.h"

@interface OTWPersonalFootprintsListController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIView *personalFootprintsListTableViewHeader;
@property (nonatomic,strong) OTWMyInfoView *myInfoView;
@property (nonatomic,strong) UIView *likeView;
@property (nonatomic,strong) UIButton *attentionBtn;
@property (nonatomic,strong) UIImageView *addImg;

@property (nonatomic,strong) OTWPersonalFootprintService *service;
@property (nonatomic,strong) OTWPersonalStatisticsModel *statisticsModel;
@property (nonatomic,assign) BOOL ifChangedOne;
@property (nonatomic,assign) BOOL ifChangedTwo;

@end

#define contentLabelFont [UIFont systemFontOfSize:15]

@implementation  OTWPersonalFootprintsListController

+(instancetype) initWithIfMyFootprint: (BOOL) ifMyFootprint
{
    OTWPersonalFootprintsListController *VC = [[OTWPersonalFootprintsListController alloc] init];
    VC.ifMyFootprint = ifMyFootprint;
    return VC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
    
    self.ifChangedOne = YES;
    
    self.ifChangedTwo = NO;
    
    self.ifInsertCreateCell = NO;
    
    if(_ifMyFootprint){ //增加一个发布通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addReleasedFootprint:) name:@"releasedFoorprint" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedFootprint:) name:@"foorprintAlreadyDeleted" object:nil];
    }
    
    [self.view bringSubviewToFront:self.customNavigationBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) insertCreateCell
{
    if(_ifMyFootprint){
        OTWPersonalFootprintsListModel *model = [[OTWPersonalFootprintsListModel alloc] init];
        model.month = @"0";
        model.monthData = [[NSMutableArray alloc] init];
        OTWFootprintListModel *footprintDetail = [[OTWFootprintListModel alloc] init];
        footprintDetail.footprintContent = @"";
        footprintDetail.footprintAddress = @"";
        footprintDetail.day = @"今天";
        OTWPersonalFootprintFrame *footprintFrame = [OTWPersonalFootprintFrame initWithFootprintDetail:footprintDetail];
        footprintFrame.hasRelease = YES;
        footprintFrame.leftContent = @"今天";
        [footprintFrame initData];
        [model.monthData addObject:footprintFrame];
        [self.status addObject:model];
        self.ifInsertCreateCell = YES;
    }
}

-(void)buildUI{

    //设置标题
    [self setLeftNavigationImage:[UIImage imageNamed:@"wd_back_wirte"]];
    [self setNavigationImage:[UIImage imageNamed:@"wd_bg"]];
    [self.customNavigationBar clearShadowColor];
    
    [self.customNavigationBar addSubview:self.myInfoView];
    
    if(!_ifMyFootprint){
        //关注
        [self setCustomNavigationRightView:self.attentionBtn];
    }
    //大背景
    self.view.backgroundColor=[UIColor whiteColor];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.navigationHeight - 20, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    [self.view addSubview:_tableView];
    
    //设置tableview的第一行显示内容
    //_tableView.tableHeaderView=self.personalFootprintsListTableViewHeader;
    
    [self.view addSubview:self.button];
    
    [_tableView.mj_footer beginRefreshing];
    
    [self changeNavigationViewFrameOne];
    
    [self.view addSubview:self.notFundFootprintView];
    
    self.notFundFootprintView.hidden = YES;
    
    [self.view bringSubviewToFront:self.customNavigationBar];
    
}

/**
 * 设置顶部 Navigation 为初始化样子
 */
- (void) changeNavigationViewFrameOne
{
    [self.customNavigationBar setNavigationBarFrame:CGRectMake(self.customNavigationBar.MinX, self.customNavigationBar.MinY, self.customNavigationBar.Witdh, 266)];
    [self.customNavigationBar setBackgroundColor:[UIColor clearColor]];
    self.tableView.frame = CGRectMake(0, self.customNavigationBar.Height - 34, SCREEN_WIDTH, SCREEN_HEIGHT - self.customNavigationBar.Height + 34 + 49);
    [self.myInfoView changeFrameOne];
//    self.ifChangedOne = YES;
//    self.ifChangedTwo = NO;
}

/**
 * 设置顶部 Navigation 为向下滑动样式
 */
- (void) changeNavigationViewFrameTwo
{
    [self.customNavigationBar setNavigationBarFrame:CGRectMake(self.customNavigationBar.MinX, self.customNavigationBar.MinY, self.customNavigationBar.Witdh, 150)];
    [self.customNavigationBar setBackgroundColor:[UIColor clearColor]];
    //[self setNavigationImage:[UIImage imageNamed:@"wd_bg2"]];
    self.tableView.frame = CGRectMake(0, self.customNavigationBar.Height - 21, SCREEN_WIDTH, SCREEN_HEIGHT - self.customNavigationBar.Height + 21 + 49);
    [self.myInfoView changeFrameTwo];
//    self.ifChangedOne = NO;
//    self.ifChangedTwo = YES;
}

- (void) addReleasedFootprint:(NSNotification*)sender
{
    OTWFootprintListModel *footprintDetail = [OTWFootprintListModel initWithDict:sender.userInfo];
    OTWPersonalFootprintFrame *footprintFrame = [OTWPersonalFootprintFrame initWithFootprintDetail:footprintDetail];
    footprintFrame.leftContent = @"";
    [footprintFrame initData];
    [self.status[0].monthData insertObject:footprintFrame atIndex:1];
    if(!self.notFundFootprintView.hidden){
        self.notFundFootprintView.hidden = YES;
        self.button.hidden = NO;
        self.tableView.hidden = NO;
    }
    [_tableView reloadData];
}

- (void) deletedFootprint:(NSNotification*)sender
{
    NSDictionary *dict = sender.userInfo;
    for (int i = 0; i<self.status.count; i++) {
        NSMutableArray<OTWPersonalFootprintFrame *> *monthDate = self.status[i].monthData;
        BOOL remove = NO;
        for (int n = 0;n< monthDate.count; n++) {
            if([monthDate[n].footprintDetal.footprintId.description isEqualToString:dict[@"footprintId"]]){
                [monthDate removeObjectAtIndex:n];
                remove = YES;
                break;
            }
        }
        if(remove && monthDate.count == 0){
            [self.status removeObjectAtIndex:i];
            break;
        }
    }
    [_tableView reloadData];
    if(self.status.count == 0 || [self.service checkIfNotFund:self]){
        self.notFundFootprintView.hidden = NO;
        self.button.hidden = YES;
        self.tableView.hidden = YES;
    }
}

-(void) loadMore
{
    [self.service userFootprintList:nil userId:_userId viewController:self completion:nil];
}
//关注
- (void)attentionBtnClick
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.status.count;
}

//滚动事件监听
#pragma mark 滚动时间监听
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y<= 0 && !self.ifChangedOne){
        [UIView animateWithDuration:0.5f animations:^{
           [self changeNavigationViewFrameOne];
            self.ifChangedOne = YES;
        } completion:^(BOOL finished){
            self.ifChangedTwo = NO;
        }];
    }else if(scrollView.contentOffset.y>0 && !self.ifChangedTwo){
        [UIView animateWithDuration:0.5f animations:^{
            [self changeNavigationViewFrameTwo];
            self.ifChangedTwo = YES;
        } completion:^(BOOL finished){
            self.ifChangedOne = NO;
        }];
    }
}

#pragma mark 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.status[section].monthData.count;
}

#pragma mark 自定义cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"OTWPersonalFootprintListCell";
    OTWPersonalFootprintTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWPersonalFootprintTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData:self.status[indexPath.section].monthData[indexPath.row]];
    return cell;
}
#pragma mark - 代理方法
#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.status[indexPath.section].monthData[indexPath.row].cellHeight;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断点击行是否是创建
    OTWPersonalFootprintFrame *footprintFrame = self.status[indexPath.section].monthData[indexPath.row];
    if(footprintFrame.hasRelease){ //发布
        OTWFootprintReleaseViewController *releaseVC = [[OTWFootprintReleaseViewController alloc] init];
        [self.navigationController pushViewController:releaseVC animated:YES];
    }else{ //跳转
        OTWFootprintDetailController *VC =  [[OTWFootprintDetailController alloc] init];
        [VC setFid:footprintFrame.footprintDetal.footprintId.description];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0 && self.status.count>0 && [self.status[0].month isEqualToString:@"0"]){
        return 10;
    }else{
        if(section == 0){
            return 40;
        }else{
            return 30;
        }
    }
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *sectionHeaderLeft=[[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 1,5)];
    sectionHeaderLeft.backgroundColor=[UIColor color_d5d5d5];
    [view addSubview:sectionHeaderLeft];
    return view;
}

#pragma mark - 自定义分组头
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    BOOL check = YES;
    if(section==0 && self.status.count>0 && [self.status[0].month isEqualToString:@"0"]){
        check = NO;
    }
    
    UIView * sectionHeader=[[UIView alloc] init];
    
    if(check){
        
        CGFloat y = 0;
        
        if(section == 0){
            y = 10;
            sectionHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH,40);
        }else{
            sectionHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH,30);
        }
        sectionHeader .backgroundColor=[UIColor clearColor];
        
        //月份的左边线条
        UILabel *sectionHeaderLeft=[[UILabel alloc] initWithFrame:CGRectMake(22.5, y + 0, 1,30)];
        sectionHeaderLeft.backgroundColor=[UIColor color_d5d5d5];
        [sectionHeader addSubview:sectionHeaderLeft];
        
        //月份的左边圆点
        UILabel *sectionHeaderCil=[[UILabel alloc] initWithFrame:CGRectMake(20, y + 4.5, 6,6)];
        sectionHeaderCil.backgroundColor=[UIColor color_202020];
        sectionHeaderCil.layer.cornerRadius = 3;
        sectionHeaderCil.layer.masksToBounds = YES;
        [sectionHeader addSubview:sectionHeaderCil];
        
        //月份的名称
        UIView *sectionHeaderTextView = [[UIView alloc] initWithFrame:CGRectMake(36,y + 0, 40, 15)];
        sectionHeaderTextView.backgroundColor = [UIColor whiteColor];
        UILabel *sectionHeaderText=[[UILabel alloc] init];
        sectionHeaderText.text=[self.status[section].month stringByAppendingString:@"月"];
        sectionHeaderText.frame=CGRectMake(0, 0, 40, 15);
        sectionHeaderText.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        sectionHeaderText.textColor=[UIColor color_202020];
        sectionHeaderText.backgroundColor=[UIColor clearColor];
        [sectionHeaderTextView addSubview:sectionHeaderText];
        [sectionHeader addSubview:sectionHeaderTextView];
        
    }else{
        sectionHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH,0);
    }
    return sectionHeader;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton*)button{
    if(!_button){
        _button=[[UIButton alloc] init];
        _button.frame=CGRectMake(SCREEN_WIDTH-15-69, SCREEN_HEIGHT-69 - 15, 69 , 69 );
        [_button setImage:[UIImage imageNamed:@"wd_qiehuanpingmian"] forState:UIControlStateNormal];
        
        [_button addTarget:self action:@selector(_ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (UIButton *)attentionBtn
{
    if (!_attentionBtn) {
        _attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 21 - 64, 0, 65, 25)];
        _attentionBtn.layer.masksToBounds = YES;
        _attentionBtn.layer.cornerRadius = 2;
        _attentionBtn.backgroundColor = [UIColor whiteColor];
        [_attentionBtn setTitle:@"   关注" forState:UIControlStateNormal];
        [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_attentionBtn setTitleColor:[UIColor color_f3715a] forState:UIControlStateNormal];
        _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_attentionBtn addSubview:self.addImg];
        [_attentionBtn addTarget:self action:@selector(attentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}
- (UIImageView *)addImg
{
    if (!_addImg) {
        _addImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 11, 11)];
        _addImg.image = [UIImage imageNamed:@"wd_guanzhu"];
    }
    return _addImg;
}
-(UIView *) likeView
{
    if(!_likeView){
        _likeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 21 - 64, 0, 64, 25)];
        _likeView.backgroundColor = [UIColor whiteColor];
        _likeView.layer.cornerRadius = 2;
        //增加关注信息 或者 是 取消关注信息
        if(/* DISABLES CODE */ (YES)){
            UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 11, 11)];
            likeImageView.image = [UIImage imageNamed:@"wd_guanzhu"];
            [_likeView addSubview:likeImageView];
            UILabel *likeTitle = [[UILabel alloc] initWithFrame:CGRectMake(likeImageView.MaxX + 5, 5 , 29, 15)];
            likeTitle.text = @"关注";
            likeTitle.textColor = [UIColor color_f3715a];
            likeTitle.font = [UIFont systemFontOfSize:14];
            [_likeView addSubview:likeTitle];
        }else{
            UILabel *likeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 , _likeView.Witdh, 15)];
            likeTitle.text = @"已关注";
            likeTitle.textColor = [UIColor color_f3715a];
            likeTitle.font = [UIFont systemFontOfSize:14];
            likeTitle.textAlignment = NSTextAlignmentCenter;
            [_likeView addSubview:likeTitle];
        }
    }
    return _likeView;
}

-(OTWMyInfoView *) myInfoView
{
    if(!_myInfoView){
        _myInfoView = [OTWMyInfoView initWithUserInfo:self.userNickname userId:self.userId userHeaderImg:self.userHeaderImg ifMy:self.ifMyFootprint];
        _myInfoView.statistics = self.statisticsModel;
        //[_myInfoView changeFrameTwo];
        [_myInfoView refleshData];
    }
    return _myInfoView;
}

-(UILabel *) getMyInfoLabel:(UIView *) view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.Witdh, 15)];
    label.text=@"4321";
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:18];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}

-(UILabel *) getMyInfoTitleLabel:(UIView *) view title:(NSString *) title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.MaxY + 7, view.Witdh, 13)];
    label.text = title;
    label.textColor = [UIColor color_ffc6c8];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}

-(void)_ButtonClick{
    DLog(@"点击了按钮");
}

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

- (OTWPersonalFootprintService *) service
{
    if(!_service){
        _service = [[OTWPersonalFootprintService alloc] init];
    }
    return _service;
}

- (OTWPersonalStatisticsModel *)statisticsModel
{
    if(!_statisticsModel){
        _statisticsModel = [[OTWPersonalStatisticsModel alloc] init];
        _statisticsModel.likeNum = 45654;
        _statisticsModel.fansNum = 99999;
    }
    return _statisticsModel;
}

- (OTWNotFundFootprintView *) notFundFootprintView
{
    if(!_notFundFootprintView){
        _notFundFootprintView = [OTWNotFundFootprintView initWithIfMy:self.ifMyFootprint];
        WeakSelf(self);
        _notFundFootprintView.block = ^(){
            OTWFootprintReleaseViewController *releaseVC = [[OTWFootprintReleaseViewController alloc] init];
            [weakself.navigationController pushViewController:releaseVC animated:YES];
        };
    }
    return _notFundFootprintView;
}

- (NSMutableArray<OTWPersonalFootprintsListModel *> *) status
{
    if(!_status){
        _status = [[NSMutableArray alloc] init];
    }
    return _status;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"releasedFoorprint" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"foorprintAlreadyDeleted" object:nil];
    DLog(@"OTWPersonalFootprintsListController dealloc");
}

@end
