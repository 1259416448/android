//
//  OTWShopActiveViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWShopActiveViewController.h"
#import "OTWShopActiveViewCell.h"
#import "OTWCustomNavigationBar.h"
#import "OTWShopActiveDetailsViewCellViewController.h"
#import "OTWAddNewActivityViewController.h"

@interface OTWShopActiveViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_status;
}
@property(nonatomic,strong) UIButton *addBtn;


@end

@implementation OTWShopActiveViewController

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
    self.title = @"商家活动";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];

    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    [self.view addSubview:_tableView];
    
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
   
     OTWShopActiveDetailsViewCellViewController *ShopActiveDetailsViewVC = [[ OTWShopActiveDetailsViewCellViewController alloc] init];
    [self.navigationController pushViewController:ShopActiveDetailsViewVC animated:YES];
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"OTWShopActiveViewCellIdentifierK";
    OTWShopActiveViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWShopActiveViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OTWShopActiveViewCell *cell =(OTWShopActiveViewCell *)[self tableView:tableView
    cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
//添加活动
- (void)addBtnClick
{
    OTWAddNewActivityViewController * addNew = [[OTWAddNewActivityViewController alloc] init];
    [self.navigationController pushViewController:addNew animated:YES];
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(SCREEN_WIDTH - 52, 22, 52, 40);
        _addBtn.backgroundColor = [UIColor clearColor];
        [_addBtn setImage:[UIImage imageNamed:@"wd_zengjia"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
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
