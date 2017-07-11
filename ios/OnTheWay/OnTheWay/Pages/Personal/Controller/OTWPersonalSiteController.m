//
//  OTWPerosionalSiteController.m
//  OnTheWay
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalSiteController.h"
#import "OTWCustomNavigationBar.h"

@interface OTWPersonalSiteController() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImage *arrowImge;

@property (nonatomic,strong) NSMutableArray *tableViewLabelArray;

@end

@implementation OTWPersonalSiteController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.customNavigationBar.leftButtonClicked=^{
        DLog(@"点击了关闭按钮");
    };
     _arrowImge = [UIImage imageNamed:@"arrow_right"];
    [self buildUI];
    [self initData];
    
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
    UITableView *personalSiteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65,SCREEN_WIDTH, SCREEN_HEIGHT-74) style:UITableViewStyleGrouped];
    personalSiteTableView.dataSource = self;
    personalSiteTableView.delegate = self;
    personalSiteTableView.backgroundColor = [UIColor color_f4f4f4];
    
    [self.view addSubview:personalSiteTableView];
    
    //第一条线
    UIView *underLineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 270, SCREEN_WIDTH, 0.5)];
    underLineTopView.backgroundColor = [UIColor color_d5d5d5];
    [self.view addSubview:underLineTopView];
    
    // 退出button
    UIButton *personalSiteOutButton=[UIButton buttonWithType:UIButtonTypeSystem];
    personalSiteOutButton.backgroundColor=[UIColor whiteColor];
    personalSiteOutButton.frame = CGRectMake(0, 270.5, SCREEN_WIDTH, 50);
    [personalSiteOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [personalSiteOutButton setTitleColor:[UIColor color_e50834] forState:UIControlStateNormal];
    personalSiteOutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    personalSiteOutButton.layer.cornerRadius = 4;
    [personalSiteOutButton addTarget:self action:@selector(OutButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    personalSiteOutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:personalSiteOutButton];

    //第二条线
    UIView *underLineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 271+50, SCREEN_WIDTH, 0.5)];
    underLineBottomView.backgroundColor = [UIColor color_d5d5d5];
    [self.view addSubview:underLineBottomView];
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
}

@end
