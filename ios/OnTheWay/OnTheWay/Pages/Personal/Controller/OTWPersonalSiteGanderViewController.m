//
//  OTWPersonalSiteGanderViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalSiteGanderViewController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWPersonalInfoController.h"

@interface OTWPersonalSiteGanderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *tableViewLabelArray;
@property (nonatomic,strong) UIImage *checkImge;

@end

@implementation OTWPersonalSiteGanderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _checkImge = [UIImage imageNamed:@"xuanze"];
    //检查是否登陆，否则跳转到登录界面
    [self initData];
    [self buildUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void) initData
{
    _tableViewLabelArray = [[NSMutableArray alloc]init];
    [_tableViewLabelArray addObject:@[@"男",@"check"]];
    [_tableViewLabelArray addObject:@[@"女",@"null"]];
 
}

#pragma mark - UI
-(void)buildUI
{
    //设置头部信息
    self.title=@"性别";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    self.view.backgroundColor = [UIColor color_f4f4f4];
    //使用UITableView，展示基本信息
    UITableView *personalGanderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    personalGanderTableView.dataSource = self;
    personalGanderTableView.delegate = self;
    personalGanderTableView.backgroundColor = [UIColor clearColor];
    // 设置边框颜色
    personalGanderTableView.separatorColor= [UIColor color_d5d5d5];
    [self.view addSubview:personalGanderTableView];
    
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

    OTWPersonalInfoController *PersonalInfoVC = [[OTWPersonalInfoController alloc] init];
    [self.navigationController pushViewController:PersonalInfoVC animated:YES];
    
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
        cell.textLabel.text =_tableViewLabelArray[indexPath.row][0];
        cell.textLabel.textColor = [UIColor color_202020];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if([_tableViewLabelArray[indexPath.row][1] isEqualToString:@"check"]){
            
            UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 13.13, 14)];
            [backImageView setImage: _checkImge ];
            cell.accessoryView =backImageView;
            
        }

        
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
