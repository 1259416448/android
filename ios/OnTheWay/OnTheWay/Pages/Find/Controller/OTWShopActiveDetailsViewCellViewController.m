//
//  OTWShopActiveDetailsViewCellViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/1.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWShopActiveDetailsViewCellViewController.h"

#import "OTWCustomNavigationBar.h"

#import "OTWShopActiveDetailsViewCell.h"

@interface OTWShopActiveDetailsViewCellViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView;
}

@property (nonatomic,assign) NSString *status;
@property (nonatomic,strong) UIView *shopActiveDetailsFooter;
@property (nonatomic,strong) NSMutableArray *tableViewLabelArray;

@end

@implementation OTWShopActiveDetailsViewCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _status=@"going";
    // Do any additional setup after loading the view.
    [self buildUI];
    [self initData];
    
}
- (void) initData
{
    _tableViewLabelArray = [[NSMutableArray alloc]init];
    [_tableViewLabelArray addObject:@"活动名称"];
    [_tableViewLabelArray addObject:@"活动时间"];
    [_tableViewLabelArray addObject:@"活动类型"];
    [_tableViewLabelArray addObject:@"活动网址"];
    [_tableViewLabelArray addObject:@"活动简介"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI {
    //设置标题
    self.title = @"优惠券";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    if([_status isEqualToString:@"start"]){
        [self setRightNavigationImage:[UIImage imageNamed:@"wd_bianji"]];
    }
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorColor= [UIColor color_d5d5d5];
    
    [self.view addSubview:tableView];
    
    if([_status isEqualToString:@"going"] || [_status isEqualToString:@"start"]){
        tableView.tableFooterView=self.shopActiveDetailsFooter;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _tableViewLabelArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row != 4){
        UITableViewCell *cell;
        static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
        if(!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text =_tableViewLabelArray[indexPath.row] ;
        cell.textLabel.textColor = [UIColor color_202020];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    
        if([_status isEqualToString:@"end"]){
              cell.backgroundColor = [UIColor color_f9f9f9];
            cell.contentView.backgroundColor = [UIColor color_f9f9f9];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor color_202020];
        if(indexPath.row == 0){
            cell.detailTextLabel.text =@"优惠券";
        }else if(indexPath.row==1){
            cell.detailTextLabel.text =@"2017.02.12-2019.02.09";
        }else if(indexPath.row==2){
            UIImageView *activeStatusImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
            activeStatusImg.image=[UIImage imageNamed:@"wd_qianbao"];
            cell.accessoryView=activeStatusImg;
        }else if(indexPath.row==3){
            cell.detailTextLabel.text =@"http://www.baidu.comjljljljljdfjaldjfklajd";
        }
        return cell;
    }else {
        UITableViewCell *cell;
        static NSString *cellIdentifier=@"UITableViewCellIdentifierKey2";
        if(!cell){
            cell=[[OTWShopActiveDetailsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            if([_status isEqualToString:@"end"]){
                cell.backgroundColor = [UIColor color_f9f9f9];
                cell.contentView.backgroundColor = [UIColor color_f9f9f9];

            }else{
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        
        return cell;
        }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==4){
        return 185;
    }
    return 50;
}



-(UIView*)shopActiveDetailsFooter{
    if(!_shopActiveDetailsFooter){
        _shopActiveDetailsFooter=[[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 80)];
        
        UIView *tabelFooterBorder=[[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 50)];
        
        tabelFooterBorder.backgroundColor=[UIColor whiteColor];
        tabelFooterBorder.layer.borderWidth=0.5;
        tabelFooterBorder.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        
        UILabel *deleteText=[[UILabel alloc]init];
        deleteText.text=@"删除";
        deleteText.textColor=[UIColor color_e50834];
        deleteText.font=[UIFont systemFontOfSize:15];
        deleteText.textAlignment=NSTextAlignmentCenter;
        deleteText.frame=CGRectMake(0, 0.5, SCREEN_WIDTH, 49);
        
        [tabelFooterBorder addSubview:deleteText];
        
        UITapGestureRecognizer  *tapGesturFootprints=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForFootprints)];
        
        [tabelFooterBorder addGestureRecognizer:tapGesturFootprints];
        
        [_shopActiveDetailsFooter addSubview:tabelFooterBorder];
    }
    return _shopActiveDetailsFooter;
}

-(void)tapActionForFootprints{
    DLog(@"点击了删除");
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
