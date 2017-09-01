//
//  OTWPersonalHistroyPayeeViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/28.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalHistroyPayeeViewController.h"
#import "OTWPersonalHistroyPayeeViewCell.h"

@interface OTWPersonalHistroyPayeeViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView;
}

@end

@implementation OTWPersonalHistroyPayeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI{
    //设置标题
    self.title = @"历史收款人";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    //创建一个分组样式的UITableView
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationHeight) style:UITableViewStyleGrouped];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    tableView.tag=10000;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:tableView];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  5;
    
}
#pragma mark 组高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DLog(@"我点击了：%ld",indexPath.row);
    
}
//section底部视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
//    view.backgroundColor = [UIColor clearColor];
//    UILabel *sectionHeaderLeft=[[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 1,5)];
//    sectionHeaderLeft.backgroundColor=[UIColor color_d5d5d5];
//    [view addSubview:sectionHeaderLeft];
//    return view;
//}
#pragma mark - 自定义分组头
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * sectionHeader=[[UIView alloc] init];
    sectionHeader.backgroundColor=[UIColor color_f4f4f4];
    
    UILabel *month=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 40)];
    month.text=@"历史收款人";
    month.textColor=[UIColor color_979797];
    month.font=[UIFont systemFontOfSize:12];
    [sectionHeader addSubview:month];
    
    return sectionHeader;
    
    
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"OTWPersonalHistroyPayeeViewCellCellIdentifierK";
    OTWPersonalHistroyPayeeViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWPersonalHistroyPayeeViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
    }
    return cell;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
@end
