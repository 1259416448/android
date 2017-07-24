//
//  OTWPersonalFootprintsListController.m
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalFootprintsListController.h"
#import "OTWPersonalFootprintsListModel.h"
#import "OTWPersonalFootprintsListTableViewCell.h"
#import "OTWFootprintReleaseViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface OTWPersonalFootprintsListController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<OTWPersonalFootprintsListModel *> *status;
@property (nonatomic,strong) UIView *personalFootprintsListTableViewHeader;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UIView *headerImgBg;
@property (nonatomic,strong) UIImageView *headerImg;
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UILabel *fansNum;
@property (nonatomic,strong) UIView *fansView;
@property (nonatomic,strong) UILabel *centerCell;
@property (nonatomic,strong) UILabel *zanNum;
@property (nonatomic,strong) UIView *zanView;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIView *likeView;
@property (nonatomic,strong) UIView *myInfoView;
@property (nonatomic,assign) CGFloat cellViewWidth;

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
    
    //初始化数据
    [self initData];
    
    [self buildUI];
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

-(void)initData{
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"OTWUserFootprintList.plist" ofType:nil];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fullPath];
    _status = [[NSMutableArray alloc] init];
    if(array && array.count>0){
        for (NSDictionary *dict in array) {
            [_status addObject:[OTWPersonalFootprintsListModel initWithDict:dict]];
            //计算所有cell高
            for (OTWPersonalFootprintsListModel *one in _status) {
                for (OTWPersonalFootprintMonthDataModel *two in one.monthData) {
                    //如果包含图片 每条数据等于 80 不包含图片，需要计算文字的高度，每条数据不超过 80  地址 12
                    two.cellHeight = 0;
                    for (OTWFootprintListModel *three in two.dayData) {
                        if(three.footprintPhotoArray && three.footprintPhotoArray.count>0){
                            two.cellHeight += 95;
                        }else{
                            CGSize textSize = [self sizeWithString:three.footprintContent font:contentLabelFont maxSize:CGSizeMake(self.cellViewWidth, 60)];
                            if(textSize.height == 60){
                                two.cellHeight += 95;
                            }else{
                                two.cellHeight += textSize.height + 35;
                            }
                        }
                    }
                    if([two.day isEqualToString:@"0"] && _ifMyFootprint){
                        two.cellHeight += 95;
                    }
                }
            }
        }
    }
}

-(void)buildUI{
    //设置标题
    //    self.title = @"商家详情";
    [self setLeftNavigationImage:[UIImage imageNamed:@"wd_back_wirte"]];
    [self setNavigationImage:[UIImage imageNamed:@"wd_bg"]];
    
    if(!_ifMyFootprint){
        //关注
        [self setCustomNavigationRightView:self.likeView];
    }
    //[self setRightNavigationTitle:@"+ 关注"];
    //大背景
    self.view.backgroundColor=[UIColor whiteColor];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.navigationHeight - 1, SCREEN_WIDTH, SCREEN_HEIGHT- self.navigationHeight - 1) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    [self.view addSubview:_tableView];
    
    //设置tableview的第一行显示内容
    _tableView.tableHeaderView=self.personalFootprintsListTableViewHeader;
    
    
    [self.view addSubview:self.button];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _status.count;
}

#pragma mark 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _status[section].monthData.count;
}

#pragma mark 自定义cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier=[@"findViewCellI" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    OTWPersonalFootprintsListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWPersonalFootprintsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WeakSelf(self);
        cell.tapOne = ^(NSString *opId){
            OTWFootprintDetailController *detailVC = [[OTWFootprintDetailController alloc] init];
            detailVC.fid = opId;
            [weakself.navigationController pushViewController:detailVC animated:YES];
        };
        cell.ifMyFootprint = _ifMyFootprint;
        if(_ifMyFootprint){
            cell.tapRelease=^(){
                OTWFootprintReleaseViewController *releaseVC = [[OTWFootprintReleaseViewController alloc] init];
                [weakself.navigationController pushViewController:releaseVC animated:YES];
            };
        }
        [cell setData:_status[indexPath.section].monthData[indexPath.row]];
    }
    return cell;
}
#pragma mark - 代理方法
#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _status[indexPath.section].monthData[indexPath.row].cellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 0;
    }else{
        return 30;
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
    
    UIView * sectionHeader=[[UIView alloc] init];
    
    if(section!=0){
        sectionHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH,30);
        sectionHeader .backgroundColor=[UIColor clearColor];
        
        //月份的左边线条
        UILabel *sectionHeaderLeft=[[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 1,30)];
        sectionHeaderLeft.backgroundColor=[UIColor color_d5d5d5];
        [sectionHeader addSubview:sectionHeaderLeft];
        
        //月份的左边圆点
        UILabel *sectionHeaderCil=[[UILabel alloc] initWithFrame:CGRectMake(20, 4.5, 6,6)];
        sectionHeaderCil.backgroundColor=[UIColor color_202020];
        sectionHeaderCil.layer.cornerRadius = 3;
        sectionHeaderCil.layer.masksToBounds = YES;
        [sectionHeader addSubview:sectionHeaderCil];
        
        //月份的名称
        UIView *sectionHeaderTextView = [[UIView alloc] initWithFrame:CGRectMake(36, 0, 40, 15)];
        sectionHeaderTextView.backgroundColor = [UIColor whiteColor];
        UILabel *sectionHeaderText=[[UILabel alloc] init];
        sectionHeaderText.text=[_status[section].month stringByAppendingString:@"月"];
        sectionHeaderText.frame=CGRectMake(0, 0, 40, 15);
        sectionHeaderText.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        sectionHeaderText.textColor=[UIColor color_202020];
        sectionHeaderText.backgroundColor=[UIColor whiteColor];
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

-(UIView*)personalFootprintsListTableViewHeader{
    if(!_personalFootprintsListTableViewHeader){
        _personalFootprintsListTableViewHeader=[[UIView alloc]init];
        _personalFootprintsListTableViewHeader.backgroundColor=[UIColor whiteColor];
        _personalFootprintsListTableViewHeader.frame=CGRectMake(0, 0,SCREEN_WIDTH, 238 + 23);
        
        //背景图片
        [_personalFootprintsListTableViewHeader addSubview:self.bgImg];
        
        //头像背景
        [_personalFootprintsListTableViewHeader addSubview:self.headerImgBg];
        //头像
        [self.headerImgBg addSubview:self.headerImg];
        //名称
        [_personalFootprintsListTableViewHeader addSubview:self.userName];
        if(!_ifMyFootprint){
            //粉丝
            [_personalFootprintsListTableViewHeader addSubview:self.fansView];
            //中间阻隔线
            [_personalFootprintsListTableViewHeader addSubview:self.centerCell];
            //被赞
            [_personalFootprintsListTableViewHeader addSubview:self.zanView];
        }else{
            //粉丝
            //关注
            //被赞
            [_personalFootprintsListTableViewHeader addSubview:self.myInfoView];
        }
    }
    return _personalFootprintsListTableViewHeader;
}

-(UILabel*)userName{
    if(!_userName){
        _userName=[[UILabel alloc] initWithFrame:CGRectMake(0,self.headerImgBg.MaxY+10 , SCREEN_WIDTH, 22.5)];
        _userName.text=@"想起一个很长的名字";
        _userName.textColor=[UIColor whiteColor];
        _userName.textAlignment=NSTextAlignmentCenter;
        _userName.font=[UIFont systemFontOfSize:16];
    }
    return _userName;
}
-(UIView*)headerImgBg{
    if(!_headerImgBg){
        _headerImgBg=[[UIView alloc] init];
        _headerImgBg.frame=CGRectMake((SCREEN_WIDTH-90)/2, 1, 90, 90);
        _headerImgBg.layer.cornerRadius=90/2;
        _headerImgBg.layer.masksToBounds = YES;
        _headerImgBg.backgroundColor=[UIColor whiteColor];
    }
    return _headerImgBg;
}

-(UIImageView*)headerImg{
    if(!_headerImg){
        _headerImg=[[UIImageView alloc]init];
        _headerImg.frame=CGRectMake(4, 4, 82, 82);
        [_headerImg setImageWithURL:[NSURL URLWithString:@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg?imageView2/1/w/180/h/180"]];
        _headerImg.layer.cornerRadius=82/2;
        _headerImg.layer.masksToBounds = YES;
    }
    return _headerImg;
}

-(UIImageView*)bgImg{
    if(!_bgImg){
        _bgImg=[[UIImageView alloc]init];
        _bgImg.frame=CGRectMake(0, 0, SCREEN_WIDTH, 238);
        _bgImg.contentMode = UIViewContentModeBottom;
        _bgImg.clipsToBounds  = YES;
        _bgImg.image=[UIImage imageNamed:@"wd_bg"];
    }
    return _bgImg;
}

-(UIView *) fansView
{
    if(!_fansView){
        _fansView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userName.MaxY+30, (SCREEN_WIDTH-1)/2, 13+15+7)];
        _fansView.backgroundColor = [UIColor clearColor];
        [_fansView addSubview:self.fansNum];
        UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.fansNum.MaxY + 7, _fansView.Witdh, 13)];
        fansLabel.text = @"粉丝";
        fansLabel.textColor = [UIColor color_ffc6c8];
        fansLabel.font = [UIFont systemFontOfSize:12];
        fansLabel.textAlignment=NSTextAlignmentCenter;
        [_fansView addSubview:fansLabel];
    }
    return _fansView;
}

-(UILabel*)fansNum{
    if(!_fansNum){
        _fansNum=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.fansView.Witdh , 15)];
        _fansNum.text=@"4321" ;
        _fansNum.textColor=[UIColor whiteColor];
        _fansNum.font=[UIFont systemFontOfSize:18];
        _fansNum.textAlignment=NSTextAlignmentCenter;
    }
    return _fansNum;
}

-(UIView *) zanView
{
    if(!_zanView){
        _zanView = [[UIView alloc] initWithFrame:CGRectMake(self.fansView.MaxX+1, self.fansView.MinY, self.fansView.Witdh, self.fansView.Height)];
        _zanView.backgroundColor = [UIColor clearColor];
        [_zanView addSubview:self.zanNum];
        UILabel *zanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.fansNum.MaxY + 7, _fansView.Witdh, 13)];
        zanLabel.text = @"被赞";
        zanLabel.textColor = [UIColor color_ffc6c8];
        zanLabel.font = [UIFont systemFontOfSize:12];
        zanLabel.textAlignment=NSTextAlignmentCenter;
        [_zanView addSubview:zanLabel];
    }
    return _zanView;
}

-(UILabel*)zanNum{
    if(!_zanNum){
        _zanNum=[[UILabel alloc]initWithFrame:CGRectMake(0 , 0, self.zanView.Witdh , 15)];
        _zanNum.text=@"887" ;
        _zanNum.textColor=[UIColor whiteColor];
        _zanNum.font=[UIFont systemFontOfSize:18];
        _zanNum.textAlignment=NSTextAlignmentCenter;
    }
    return _zanNum;
}
-(UILabel*)centerCell{
    if(!_centerCell){
        _centerCell=[[UILabel alloc]initWithFrame:CGRectMake(self.fansView.MaxX,  self.userName.MaxY+37.5, 1, 20)];
        _centerCell.backgroundColor=[UIColor color_ffc6c8];
    }
    return _centerCell;
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

-(UIView *) likeView
{
    if(!_likeView){
        _likeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 21 - 64, 0, 64, 25)];
        _likeView.backgroundColor = [UIColor whiteColor];
        _likeView.layer.cornerRadius = 2;
        //增加关注信息 或者 是 取消关注信息
        if(YES){
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
            likeTitle.text = @"取消关注";
            likeTitle.textColor = [UIColor color_f3715a];
            likeTitle.font = [UIFont systemFontOfSize:14];
            likeTitle.textAlignment = NSTextAlignmentCenter;
            [_likeView addSubview:likeTitle];
        }
    }
    return _likeView;
}

-(UIView *) myInfoView
{
    if(!_myInfoView){
        _myInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userName.MaxY + 30, SCREEN_WIDTH, 13+15+7)];
        
        //粉丝
        UIView *myFansView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 2)/3, _myInfoView.Height)];
        UILabel *myFansLabel = [self getMyInfoLabel:myFansView];
        myFansLabel.text=@"4321";
        UILabel *myFansTitleLabel = [self getMyInfoTitleLabel:myFansLabel title:@"粉丝"];
        [myFansView addSubview:myFansLabel];
        [myFansView addSubview:myFansTitleLabel];
        [_myInfoView addSubview:myFansView];
        
        UILabel *centerCellOne=[[UILabel alloc]initWithFrame:CGRectMake(myFansView.MaxX + 1, 7.5 , 1, 20)];
        centerCellOne.backgroundColor=[UIColor color_ffc6c8];
        [_myInfoView addSubview:centerCellOne];
        
        //关注
        UIView *myLikeView = [[UIView alloc] initWithFrame:CGRectMake(myFansView.MaxX +1, 0, myFansView.Witdh, myFansView.Height)];
        UILabel *myLikeLabel = [self getMyInfoLabel:myLikeView];
        myLikeLabel.text=@"456";
        UILabel *myLikeTitleLabel = [self getMyInfoTitleLabel:myLikeLabel title:@"关注"];
        [myLikeView addSubview:myLikeLabel];
        [myLikeView addSubview:myLikeTitleLabel];
        [_myInfoView addSubview:myLikeView];
        UILabel *centerCellTwo=[[UILabel alloc]initWithFrame:CGRectMake(myLikeView.MaxX + 1, 7.5 , 1, 20)];
        centerCellTwo.backgroundColor=[UIColor color_ffc6c8];
        [_myInfoView addSubview:centerCellTwo];
        
        //被赞
        UIView *myZanView = [[UIView alloc] initWithFrame:CGRectMake(myLikeView.MaxX +1, 0, myFansView.Witdh, myFansView.Height)];
        UILabel *myZanLabel = [self getMyInfoLabel:myZanView];
        myZanLabel.text=@"887";
        UILabel *myZanTitleLabel = [self getMyInfoTitleLabel:myZanLabel title:@"被赞"];
        [myZanView addSubview:myZanLabel];
        [myZanView addSubview:myZanTitleLabel];
        [_myInfoView addSubview:myZanView];
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

//cell 可视宽度
-(CGFloat) cellViewWidth
{
    if(!_cellViewWidth || _cellViewWidth == 0){
        _cellViewWidth = SCREEN_WIDTH - 15 - 80;
    }
    return _cellViewWidth;
}

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

-(void) dealloc
{
    DLog(@"OTWPersonalFootprintsListController dealloc");
}

@end
