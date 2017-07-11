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

@property (nonatomic,strong) UITableView *personalSiteTableView;

@property (nonatomic,strong) UIView *underLineTopView;

@property (nonatomic,strong) UIButton *personalSiteOutButton;

@property (nonatomic,strong) UIView *underLineBottomView;

@property(nonatomic,strong) UIView *personalSiteTableViewFooter;

@property(nonatomic,strong) UIView *contentView;
@end

@implementation OTWPersonalSiteController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.customNavigationBar.leftButtonClicked=^{
        DLog(@"点击了后退按钮");
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
}

-(UITableView*)personalSiteTableView{
    if(!_personalSiteTableView){
        _personalSiteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65,SCREEN_WIDTH, SCREEN_HEIGHT-74) style:UITableViewStyleGrouped];
        _personalSiteTableView.dataSource = self;
        _personalSiteTableView.delegate = self;
        _personalSiteTableView.backgroundColor = [UIColor color_f4f4f4];
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

-(UIButton*)personalSiteOutButton{
    if(!_personalSiteOutButton){
        _personalSiteOutButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _personalSiteOutButton.backgroundColor = [UIColor whiteColor];
        _personalSiteOutButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        [_personalSiteOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_personalSiteOutButton setTitleColor:[UIColor color_e50834] forState:UIControlStateNormal];
        _personalSiteOutButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _personalSiteOutButton.layer.cornerRadius = 4;
        [_personalSiteOutButton addTarget:self action:@selector(OutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _personalSiteOutButton;
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
        _personalSiteTableViewFooter=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _personalSiteTableViewFooter.backgroundColor=[UIColor color_f4f4f4];
        
        //设置header 内容的背景
        [_personalSiteTableViewFooter addSubview:self.contentView];
        
        // 退出button
        [self.contentView addSubview:self.personalSiteOutButton];
        
        //第一条线
        [self.contentView addSubview:self.underLineTopView];
        
        //第二条线
        [self.contentView addSubview:self.underLineBottomView];
    }
    return _personalSiteTableViewFooter;
}

-(UIView*)contentView{
    if(!_contentView){
        _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _personalSiteTableViewFooter.backgroundColor=[UIColor whiteColor];
    }
    return _contentView;
}
@end

