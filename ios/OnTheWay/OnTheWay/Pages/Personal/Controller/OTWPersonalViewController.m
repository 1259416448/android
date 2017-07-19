//
//  OTWPersonalMyController.m
//  OnTheWay
//
//  Created by apple on 2017/7/11.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalViewController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWUserModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OTWPersonalInfoController.h"
#import "OTWPersonalSiteController.h"
#import "OTWLoginViewController.h"
#import "OTWRootViewController.h"
#import "OTWTabBarController.h"
#import "OTWPersonalFootprintsListController.h"

@interface OTWPersonalViewController() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImage *arrowImge;

@property (nonatomic,strong) NSMutableArray *tableViewLabelArray;

@property (nonatomic,strong) UITableView *personalMyTableView;
@property (nonatomic,strong) UIView *personalMyTableViewHeader;
@property (nonatomic,strong) UIImageView * personalHeadImageView;
@property (nonatomic,strong) UIImageView * backImageView;
@property(nonatomic,strong) UIView * contentView;
@property(nonatomic,strong) UILabel * userName;
@property (nonatomic,strong) UIView *underLineBottomView;
@property (nonatomic,strong) UIView *underLineTopView;
@end

@implementation OTWPersonalViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    _arrowImge = [UIImage imageNamed:@"arrow_right"];
    [self buildUI];
    [self initData];
}

#pragma mark - initData
- (void) initData
{
    _tableViewLabelArray = [[NSMutableArray alloc] init];
    [_tableViewLabelArray addObject:@[@"我的足迹",@"wodezuji"]];
    [_tableViewLabelArray addObject:@[@"我的收藏",@"wodeshoucang"]];
    [_tableViewLabelArray addObject:@[@"我发现的商家",@"faxianshangjia"]];
    [_tableViewLabelArray addObject:@[@"我的卡券",@"wodekaquan"]];
    [_tableViewLabelArray addObject:@[@"设置",@"shezhi"]];
    //获取用户数据
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController showTabBarWithAnimation:YES];
    [self buildPersonalInfo];
}

-(void)buildPersonalInfo
{
    [[OTWUserModel shared] load];
    NSURL *url ;
    if(![OTWUserModel shared].headImg){
        url = [NSURL URLWithString:@"https://sources.cc520.me/share/img/o_1b4t0srq81sm31g699lk1ob1e7r3t4.jpg?imageView2/1/w/78/h/78"];
    }else{
        url = [NSURL URLWithString:[OTWUserModel shared].headImg];
    }
    [self.personalHeadImageView setImageWithURL:url];
    self.userName.text=[OTWUserModel shared].name;
}

-(void)buildUI {
    //设置标题
    self.title = @"我的";
//    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //UITableView 列表
    [self.view addSubview:self.personalMyTableView];
    
    //设置tableview的第一行显示内容
    self.personalMyTableView.tableHeaderView=self.personalMyTableViewHeader;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableViewLabelArray.count;
}

#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
    if(indexPath.row==4){
        OTWPersonalSiteController *personalSiteVC = [[OTWPersonalSiteController alloc] init];
        [self.navigationController pushViewController:personalSiteVC animated:YES];
    }
    if(indexPath.row==0){
        OTWPersonalFootprintsListController *personalSiteVC = [[OTWPersonalFootprintsListController alloc] init];
        [self.navigationController pushViewController:personalSiteVC animated:YES];

    }
}

#pragma mark 返回第indexPath这行对应的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        //设置行的icon图片
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        UIImage * icon = [UIImage imageNamed:_tableViewLabelArray[indexPath.row][1]];
        CGSize itemSize = CGSizeMake(17, 17);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        cell.textLabel.text =_tableViewLabelArray[indexPath.row][0];
        cell.textLabel.textColor = [UIColor color_202020];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 8, 15)];
        [backImageView setImage: _arrowImge ];
        cell.accessoryView =backImageView;
    
    }
    
    return cell;
}

-(UITableView*)personalMyTableView{
    if(!_personalMyTableView){
        _personalMyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65,SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
        _personalMyTableView.dataSource = self;
        _personalMyTableView.delegate = self;
        _personalMyTableView.backgroundColor = [UIColor clearColor];
        // 设置边框颜色
        _personalMyTableView.separatorColor= [UIColor color_d5d5d5];
    }
    return _personalMyTableView;
}

-(UIView*)personalMyTableViewHeader{
    if(!_personalMyTableViewHeader){
        //设置header的背景
        _personalMyTableViewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 96)];
        _personalMyTableViewHeader.backgroundColor=[UIColor clearColor];
        
         UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_personalMyTableViewHeader addGestureRecognizer:tapGesturRecognizer];
        
         //设置header 内容的背景
        [_personalMyTableViewHeader addSubview:self.contentView];
        
        [_personalMyTableViewHeader addSubview:self.underLineTopView];
        
        //header 内容的中头像
        [self.contentView addSubview:self.personalHeadImageView];

        //header 内容的中的左箭头
        [self.contentView addSubview:self.backImageView];
        
        //header 内容的中名称
        [self.contentView addSubview:self.userName];

        //header 内容的中的下边框
        [_personalMyTableViewHeader addSubview:self.underLineBottomView];
        
        
    }
      return _personalMyTableViewHeader;
}

-(void)tapAction
{
    OTWPersonalInfoController *personalInfoVC = [[OTWPersonalInfoController alloc] init];
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

-(UIImageView*)personalHeadImageView{
    if(!_personalHeadImageView){
        NSURL *url ;
        if(![OTWUserModel shared].headImg){
            url = [NSURL URLWithString:@"https://sources.cc520.me/share/img/o_1b4t0srq81sm31g699lk1ob1e7r3t4.jpg?imageView2/1/w/78/h/78"];
        }else{
            url = [NSURL URLWithString:[OTWUserModel shared].headImg];
        }
        _personalHeadImageView = [[UIImageView alloc] init];
        _personalHeadImageView.frame = CGRectMake(15, 15, 55, 55);
        _personalHeadImageView.layer.cornerRadius = _personalHeadImageView.Witdh/2.0;
        _personalHeadImageView.layer.masksToBounds = YES;
        [_personalHeadImageView setImageWithURL:url];
    }
    return _personalHeadImageView;
}

-(UIImageView*)backImageView{
    if(!_backImageView){
       _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-8, (self.contentView.Height-15)/2, 8, 15)];
        [_backImageView setImage: _arrowImge ];
    }
    return _backImageView;
}

-(UIView*)contentView{
    if(!_contentView){
        _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 10.5, SCREEN_WIDTH, 85)];
        _contentView.backgroundColor=[UIColor whiteColor];
    }
    return _contentView;
}

-(UILabel*)userName{
    if(!_userName){
       _userName = [[UILabel alloc] initWithFrame:CGRectMake(self.personalHeadImageView.Witdh+15+9.5, 30.4, SCREEN_WIDTH-85-19-23, 24)];
        _userName.text=[OTWUserModel shared].name;
        _userName.textColor=[UIColor color_202020];
        _userName.font = [UIFont systemFontOfSize:17];
    }
    return _userName;
}

-(UIView*)underLineBottomView{
    if(!_underLineBottomView){
        _underLineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 95.5, SCREEN_WIDTH, 0.5)];
        _underLineBottomView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineBottomView;
}

-(UIView*)underLineTopView{
    if(!_underLineTopView){
        _underLineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 0.5)];
        _underLineTopView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineTopView;
}
@end
