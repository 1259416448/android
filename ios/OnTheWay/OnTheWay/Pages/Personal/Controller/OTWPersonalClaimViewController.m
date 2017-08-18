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

@interface OTWPersonalClaimViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView;
    NSMutableArray *status;
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
    self.title = @"我认领的商家";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65+10, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:tableView];
    
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
    sectionHeader.backgroundColor=[UIColor whiteColor];
    //认领时间的边框
    UILabel *claimShopTimeBorder=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    claimShopTimeBorder.layer.borderColor=[UIColor color_d5d5d5].CGColor;
    claimShopTimeBorder.layer.borderWidth=0.5;
    [sectionHeader addSubview:claimShopTimeBorder];
    //认领时间
    UILabel *claimShopTime=[[UILabel alloc]init];
    claimShopTime.text=@"2017-02-01";
    claimShopTime.textColor=[UIColor color_979797];
    claimShopTime.font=[UIFont systemFontOfSize:11];
    [claimShopTime sizeToFit];
    claimShopTime.frame=CGRectMake(SCREEN_WIDTH-claimShopTime.Witdh-15, 0.5,claimShopTime.Witdh, 34);
    [sectionHeader addSubview:claimShopTime];

    //[sectionHeader addSubview:self.claimShopTime];
    //认领文字
    UILabel *claimShopText=[[UILabel alloc]init];
    claimShopText.text=@"认领时间";
    claimShopText.textColor=[UIColor color_202020];
    claimShopText.font=[UIFont systemFontOfSize:13];
    [claimShopText sizeToFit];
    claimShopText.frame=CGRectMake(15, 0.5,claimShopText.Witdh, 34);
    [sectionHeader addSubview:claimShopText];

    //商家图片
    UIImageView *claimShopImg=[[UIImageView alloc]init];
    claimShopImg.frame=CGRectMake(15, claimShopTimeBorder.MaxY+10, 111, 80);
    [claimShopImg sd_setImageWithURL:[NSURL URLWithString:[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg" stringByAppendingString:@"?imageView2/1/w/222/h/160"] ]];
    [sectionHeader addSubview:claimShopImg];
    //商家名称
    UILabel *claimShopName=[[UILabel alloc] initWithFrame:CGRectMake(claimShopImg.MaxX+10, claimShopTimeBorder.MaxY+10, SCREEN_WIDTH-claimShopImg.MaxX-10-15, 20)];
    claimShopName.font=[UIFont systemFontOfSize:16];
    claimShopName.text=@"胡大饭馆（东直门总店）";
    claimShopName.textColor=[UIColor color_202020];
    [sectionHeader addSubview:claimShopName];
    //商家位置图标
    UIImageView *claimShopAddressIcon=[[UIImageView alloc] initWithFrame:CGRectMake(claimShopImg.MaxX+10, claimShopName.MaxY+10,10, 10)];
    claimShopAddressIcon.image=[UIImage imageNamed:@"dinwgei_2"];
    [sectionHeader addSubview:claimShopAddressIcon];
    //商家位置
    UILabel *claimShopAddress=[[UILabel alloc] initWithFrame:CGRectMake(claimShopAddressIcon.MaxX+5,claimShopName.MaxY+10,SCREEN_WIDTH-claimShopImg.Witdh-30-10-10-6.5, 12)];
    claimShopAddress.text=@"东城区东直门内大街233";
    claimShopAddress.font=[UIFont systemFontOfSize:13];
    claimShopAddress.textColor=[UIColor color_979797];
    [sectionHeader addSubview:claimShopAddress];
    //商家电话图标
    UIImageView *claimShopPhoneIcon=[[UIImageView alloc] initWithFrame:CGRectMake(claimShopImg.MaxX+10, claimShopAddress.MaxY+6.5,10, 10)];
    claimShopPhoneIcon.image=[UIImage imageNamed:@"dianhua"];
    [sectionHeader addSubview:claimShopPhoneIcon];
    //商家电话
    UILabel *claimShopPhone=[[UILabel alloc] initWithFrame:CGRectMake(claimShopPhoneIcon.MaxX+5,claimShopAddress.MaxY+6.5,SCREEN_WIDTH-claimShopImg.Witdh-30-10-10-6.5, 12)];
    claimShopPhone.text=@"87474993";
    claimShopPhone.font=[UIFont systemFontOfSize:11];
    claimShopPhone.textColor=[UIColor color_979797];
    [sectionHeader addSubview:claimShopPhone];
    //商家优惠活动
    UIView *claimShopQuan=[[UIView alloc]initWithFrame:CGRectMake(claimShopImg.MaxX+10, claimShopPhone.MaxY+6.5,SCREEN_WIDTH-claimShopImg.MaxX-10-15 , 15)];
    for(int i=0;i<4;i++){
        UIImageView *claimShopQuanImg=[[UIImageView alloc]initWithFrame:CGRectMake(i*22.5, 0, 15, 15)];
        claimShopQuanImg.image=[UIImage imageNamed:@"wodekaquan"];
        [claimShopQuan addSubview:claimShopQuanImg];
    }
    [sectionHeader addSubview:claimShopQuan];

    return sectionHeader;
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
        OTWPersonalClaimModel *status=_tableViewLabelArray[indexPath.row];
        cell.status=status;    }
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
