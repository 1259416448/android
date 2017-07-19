//
//  OTWPerosionalSiteController.m
//  OnTheWay
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalSiteController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWUserModel.h"
#import "GCTokenManager.h"
#import "OTWRootViewController.h"
#import "OTWLaunchManager.h"
#import "OTWTabBarController.h"
#import <STPopup/STPopup.h>

@interface OTWPersonalSiteController() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImage *arrowImge;

@property (nonatomic,strong) NSMutableArray *tableViewLabelArray;

@property (nonatomic,strong) UITableView *personalSiteTableView;

@property (nonatomic,strong) UIView *underLineTopView;

@property (nonatomic,strong) UIView *underLineBottomView;

@property (nonatomic,strong) UIView *personalSiteTableViewFooter;

@property (nonatomic,strong) UIView *contentView;

//退出登录提示
@property (nonatomic,strong) UIAlertController *alertController;

@end

@implementation OTWPersonalSiteController
-(void)viewDidLoad {
    [super viewDidLoad];
     _arrowImge = [UIImage imageNamed:@"arrow_right"];
    [self buildUI];
    [self initData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

#pragma mark - initData
- (void) initData
{
    _tableViewLabelArray = [[NSMutableArray alloc] init];
    [_tableViewLabelArray addObject:@"用户反馈"];
    [_tableViewLabelArray addObject:@"关于我们"];
    [_tableViewLabelArray addObject:@"版本更新"];
    //获取用户数据
}

-(void)buildUI {
    //设置标题
    self.title = @"设置";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //UITableView 列表
     [self.view addSubview:self.personalSiteTableView];
    
    
    //设置tableview的第一行显示内容
    self.personalSiteTableView.tableFooterView=self.personalSiteTableViewFooter;
  
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
}

#pragma mark 返回第indexPath这行对应的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    UITableViewCell *cell;
    
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text =_tableViewLabelArray[indexPath.row] ;
        cell.textLabel.textColor = [UIColor color_202020];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row != 2){
            UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 8, 15)];
            [backImageView setImage: _arrowImge ];
            cell.accessoryView =backImageView;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}
-(void)OutButtonClick {
    DLog(@"点击退出");
    [self presentViewController:self.alertController animated:YES completion:nil];
    
    
//    [[OTWUserModel shared] logout];
//    [GCTokenManager cleanToken];
    // 退出到登录页
//    [[OTWLaunchManager sharedManager] deallocLoginViewController];
//    [[OTWLaunchManager sharedManager].mainTabController didSelectedItemByIndex:0];
//    [self.navigationController popToRootViewControllerAnimated: NO];
}

-(UIAlertController*)alertController
{
    if(!_alertController){
        _alertController = [UIAlertController alertControllerWithTitle:@"" message:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。" preferredStyle:UIAlertControllerStyleActionSheet];
        [_alertController addAction:[UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[OTWUserModel shared] logout];
            [GCTokenManager cleanToken];
            [[OTWLaunchManager sharedManager].mainTabController didSelectedItemByIndex:0];
            [self.navigationController popToRootViewControllerAnimated: NO];
            
        }]];
        [_alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _alertController;
}


-(UITableView*)personalSiteTableView{
    if(!_personalSiteTableView){
        _personalSiteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65,SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
        _personalSiteTableView.dataSource = self;
        _personalSiteTableView.delegate = self;
        _personalSiteTableView.backgroundColor = [UIColor clearColor];
        // 设置边框颜色
        _personalSiteTableView.separatorColor= [UIColor color_d5d5d5];
    }
    return _personalSiteTableView;
}

-(UIView*)underLineTopView{
    if(!_underLineTopView){
        _underLineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _underLineTopView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineTopView;
}

-(UIView*)underLineBottomView{
    if(!_underLineBottomView){
        _underLineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 0.5)];
        _underLineBottomView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineBottomView;
}

-(UIView*)personalSiteTableViewFooter{
    if(!_personalSiteTableViewFooter){
        //设置header的背景
        _personalSiteTableViewFooter=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
        _personalSiteTableViewFooter.backgroundColor=[UIColor clearColor];
        UIView *tableViewFooterContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH, 50)];
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OutButtonClick)];
        [tableViewFooterContentView addGestureRecognizer:tapGesturRecognizer];
        
        tableViewFooterContentView.backgroundColor = [UIColor whiteColor];
        UILabel *outSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 66)/2, 15+0.5, 66, 20)];
        outSizeLabel.text = @"退出登录";
        outSizeLabel.textColor = [UIColor color_e50834];
        outSizeLabel.font = [UIFont systemFontOfSize:16];
        
        [_personalSiteTableViewFooter addSubview:tableViewFooterContentView];
        
        [tableViewFooterContentView addSubview:outSizeLabel];
        //第一条线
        [tableViewFooterContentView addSubview:self.underLineTopView];
        
        //第二条线
        [tableViewFooterContentView addSubview:self.underLineBottomView];
    }
    return _personalSiteTableViewFooter;
}
@end

