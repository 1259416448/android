//
//  OTWPersonalClaimViewController.m
//  OnTheWay
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalClaimViewController.h"
#import "OTWPersonalClaimTableViewCell.h"
#import "OTWCustomNavigationBar.h"
#import "OTWShopActiveViewController.h"
#import "OTWShopDetailsController.h"
#import "OTWPersonalClaimModel.h"
#import "OTWMyShopTableHeadView.h"

@interface OTWPersonalClaimViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_status;
}
@property (nonatomic,strong) NSMutableArray *tableViewLabelArray;
@end

@implementation OTWPersonalClaimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        [self buildUI];
    [self initData];
    
}
-(void)initData{
    _tableViewLabelArray = [[NSMutableArray alloc] init];
     NSDictionary *dic1=@{@"claimShopOtherInfoIcon":@"wd_guanli",@"claimShopOtherInfoName":@"商家管理"};
    NSDictionary *dic2=@{@"claimShopOtherInfoIcon":@"wd_zhaopian",@"claimShopOtherInfoName":@"上传图片"};
    NSDictionary *dic3=@{@"claimShopOtherInfoIcon":@"wd_huodong",@"claimShopOtherInfoName":@"商家活动"};
    OTWPersonalClaimModel *model = [OTWPersonalClaimModel statusWithDictionary:dic1];
    OTWPersonalClaimModel *model2= [OTWPersonalClaimModel statusWithDictionary:dic2];
    OTWPersonalClaimModel *model3= [OTWPersonalClaimModel statusWithDictionary:dic3];
    
    [_tableViewLabelArray addObject:model];
    [_tableViewLabelArray addObject:model2];
    [_tableViewLabelArray addObject:model3];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI {
    //设置标题
    self.title = @"我的认领";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65+10, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tableViewLabelArray.count;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _tableViewLabelArray.count;
}
#pragma mark 组高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 145;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1)
    {
        
    }else{
        DLog(@"点击了活动");
        OTWShopActiveViewController *ShopActiveViewVC = [[OTWShopActiveViewController alloc] init];
        [self.navigationController pushViewController:ShopActiveViewVC animated:YES];
    }
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *sectionHeaderLeft=[[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 1,5)];
    sectionHeaderLeft.backgroundColor=[UIColor redColor];
    [view addSubview:sectionHeaderLeft];
    return view;
}

#pragma mark - 自定义分组头
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[OTWMyShopTableHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 145)];
    return headView;
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OTWPersonalClaimTableViewCellCellIdentifierK";
    OTWPersonalClaimTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OTWPersonalClaimTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //在此模块，以便重新布局
    OTWPersonalClaimModel *status=_tableViewLabelArray[indexPath.row];
    cell.status=status;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    OTWPersonalClaimTableViewCell *cell = (OTWPersonalClaimTableViewCell *)[self tableView:tableView
//                                                                     cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    return 50;
}

-(void)activeClick{
    
    DLog(@"点击了活动");
    OTWShopActiveViewController *ShopActiveViewVC = [[OTWShopActiveViewController alloc] init];
    [self.navigationController pushViewController:ShopActiveViewVC animated:YES];
}

-(void)detailClick{
    DLog(@"点击了商家详情");
    OTWShopDetailsController *ShopDetailsViewVC = [[OTWShopDetailsController alloc] init];
    [self.navigationController pushViewController:ShopDetailsViewVC animated:YES];}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
