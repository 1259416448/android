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

@interface OTWPersonalClaimViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView;
    NSMutableArray *status;
}

@end

@implementation OTWPersonalClaimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI {
    //设置标题
    self.title = @"我认领的商家";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    [self.view addSubview:tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"OTWPersonalClaimTableViewCellCellIdentifierK";
    OTWPersonalClaimTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWPersonalClaimTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
        
    }
    [cell.claimShopActiveBtn addTarget:self action:@selector(activeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.claimShopDetailBtn addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OTWPersonalClaimTableViewCell *cell = (OTWPersonalClaimTableViewCell *)[self tableView:tableView
                                                                     cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
