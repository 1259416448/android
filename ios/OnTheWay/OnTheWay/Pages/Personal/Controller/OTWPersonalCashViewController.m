//
//  OTWPersonalCashViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/28.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalCashViewController.h"

#import "OTWPersonalCashTVTableViewCell.h"
#import "OTWPersonalCashTFPERSONALViewCell.h"
#import "OTWPersonalCashTFViewCell.h"
#import <MJExtension.h>
@interface OTWPersonalCashViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *tableViewData;
@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UIButton *submitButton;
@property (nonatomic,strong) OTWPersonalCashFormModel *OTWPersonalCashFormModel;
@property (nonatomic,strong) UIView *tableviewFooter;

@end

@implementation OTWPersonalCashViewController

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
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
    
    self.title = @"提现";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor = [UIColor color_f4f4f4];
    [self.view addSubview:self.tableV];
    [self initDataSource];
    
}

-(void)initDataSource{
    OTWPersonalCashModel *nameModel = [[OTWPersonalCashModel alloc] init];
    nameModel.title = @"姓名";
    nameModel.placeholder = @"收款人姓名";
    nameModel.key = @"name";
    nameModel.cellType = PersonalCashCellType_TF_PERSONAL;
    nameModel.maxInputLenth = 30;
    [self.tableViewData addObject:nameModel];
    
    OTWPersonalCashModel *bankCardModel = [[OTWPersonalCashModel alloc] init];
    bankCardModel.title = @"卡号";
    bankCardModel.placeholder = @"收款人储蓄卡号";
    bankCardModel.key = @"bankCard";
    bankCardModel.cellType = PersonalCashCellType_TF;
    bankCardModel.maxInputLenth = 30;
    [self.tableViewData addObject:bankCardModel];
    
    OTWPersonalCashModel *bankNameModel = [[OTWPersonalCashModel alloc] init];
    bankNameModel.title = @"银行";
    bankNameModel.placeholder = @"请选择银行卡";
    bankNameModel.key = @"bankName";
    bankNameModel.cellType = PersonalCashCellType_TV_BACK;
    [self.tableViewData addObject:bankNameModel];

    if (self.tableV) {
        [self.tableV reloadData];
    }
}
#pragma mark 设置分组标题内容高度
    -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 10;
    }
    
#pragma mark 返回分组数
    - (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
    {
        return 1;
    }
    
#pragma mark 返回每组行数
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return self.tableViewData.count;
    }
    
#pragma mark 设置每行高度
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        return 50.f;
    }



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTWPersonalCashModel *createModel = self.tableViewData[indexPath.row];
    if (createModel.cellType == PersonalCashCellType_TF) {
        static NSString *tfCellId = @"tfCellId";
        OTWPersonalCashTFViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tfCellId];
        if (cell == nil)
        {
            cell = [[OTWPersonalCashTFViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tfCellId];
        }
        [cell refreshContent:createModel formModel:self.OTWPersonalCashFormModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (createModel.cellType == PersonalCashCellType_TF_PERSONAL) {
        static NSString *tfpersonalCellId = @"tfpersonalCellId";
        OTWPersonalCashTFPERSONALViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tfpersonalCellId];
        if (cell == nil)
        {
            cell = [[OTWPersonalCashTFPERSONALViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tfpersonalCellId];
        }
        [cell refreshContent:createModel formModel:self.OTWPersonalCashFormModel control:self.navigationController];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (createModel.cellType == PersonalCashCellType_TV_BACK) {
        static NSString *tvCellId = @"tvCellId";
        OTWPersonalCashTVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tvCellId];
        if (cell == nil)
        {
            cell = [[OTWPersonalCashTVTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tvCellId];
        }
        [cell refreshContent:createModel formModel:self.OTWPersonalCashFormModel control:self.navigationController];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
  return nil;
}

- (NSMutableArray<OTWPersonalCashModel*>*)tableViewData
{
    if (!_tableViewData) {
        _tableViewData = [[NSMutableArray alloc] init];
    }
    return _tableViewData;
}

-(OTWPersonalCashFormModel*)OTWPersonalCashFormModel{
    if(!_OTWPersonalCashFormModel){
        _OTWPersonalCashFormModel= [[OTWPersonalCashFormModel alloc] init];    }
    return _OTWPersonalCashFormModel;
}

- (UITableView*)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationHeight) style:UITableViewStylePlain];
        _tableV.dataSource = self;
        _tableV.delegate = self;
        _tableV.backgroundColor = [UIColor clearColor];
        _tableV.tableFooterView=self.tableviewFooter;
    }
    return _tableV;
}
-(UIView*)tableviewFooter{
    if(!_tableviewFooter){
        _tableviewFooter=[[UIView alloc]init];
        _tableviewFooter.frame=CGRectMake(0, 10, SCREEN_WIDTH, 184);
        
        //第一条线
        UIView *firstLine=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 0.5)];
        firstLine.backgroundColor=[UIColor color_d5d5d5];
        [_tableviewFooter addSubview:firstLine];
        
        //第一行
        UIView *firstCell=[[UIView alloc]initWithFrame:CGRectMake(0, 10.5, SCREEN_WIDTH, 45.7)];
        firstCell.backgroundColor=[UIColor whiteColor];
        [_tableviewFooter addSubview:firstCell];
        
        //title
        UILabel *titleF=[[UILabel alloc]initWithFrame:CGRectMake(15, 25, 70, 20)];
        titleF.text=@"金钱";
        titleF.font=[UIFont systemFontOfSize:16];
        titleF.backgroundColor=[UIColor whiteColor];
        [_tableviewFooter addSubview:titleF];
        
        //输入框
        UITextField *textFieldF=[[UITextField alloc]initWithFrame:CGRectMake(titleF.MaxX, 20, SCREEN_WIDTH-titleF.MaxX-15, 30)];
        textFieldF.borderStyle = UITextBorderStyleNone;
        textFieldF.font = [UIFont systemFontOfSize:14];
        textFieldF.textColor = [UIColor color_979797];
        textFieldF.textAlignment = NSTextAlignmentRight;
        textFieldF.placeholder=@"输入提款金额 免手续费";
        [_tableviewFooter addSubview:textFieldF];
        
        //第二条线
        UIView *secendLine=[[UIView alloc]initWithFrame:CGRectMake(0, titleF.MaxY+13, SCREEN_WIDTH,0.5)];
        secendLine.backgroundColor=[UIColor color_d5d5d5];
        [_tableviewFooter addSubview:secendLine];
        
        //第二行
        UIView *secendCell=[[UIView alloc]initWithFrame:CGRectMake(0,  titleF.MaxY+14.45+0.5, SCREEN_WIDTH, 39)];
        secendCell.backgroundColor=[UIColor color_fafafa];
        [_tableviewFooter addSubview:secendCell];
        
        //提示语
        UILabel *total=[[UILabel alloc]init];
        total.text=@"全部金额2234.35";
        total.font=[UIFont systemFontOfSize:13];
        total.textColor=[UIColor color_979797];
        [total sizeToFit];
        total.frame=CGRectMake(15, secendLine.MaxY+0.5, total.Witdh, 39);
        [_tableviewFooter addSubview:total];
        
        //全部按钮
        UIButton *allCash=[[UIButton alloc]initWithFrame:CGRectMake(total.MaxX+10, secendLine.MaxY+9.75, 100, 20)];
        [allCash setTitle:@"全部提现" forState:UIControlStateNormal];
         [allCash setTitleColor:[UIColor color_60a8e0] forState:UIControlStateNormal];
        allCash.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [allCash addTarget:self action:@selector(allCashClick) forControlEvents:UIControlEventTouchUpInside];
        allCash.adjustsImageWhenHighlighted=NO;
            allCash.titleLabel.font = [UIFont systemFontOfSize:13];
        [_tableviewFooter addSubview:allCash];
        
        //第三条线
        UIView *thirdLine=[[UIView alloc]initWithFrame:CGRectMake(0, secendCell.MaxY, SCREEN_WIDTH,0.5)];
        thirdLine.backgroundColor=[UIColor color_d5d5d5];
        [_tableviewFooter addSubview:thirdLine];
        
        [_tableviewFooter addSubview:self.submitButton];
    }
    return _tableviewFooter;
}

- (UIButton*)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_submitButton setTitle:@"提现" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.backgroundColor = [UIColor color_d5d5d5];
        _submitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        CGRect submitButtonRect = CGRectMake(30,150 , SCREEN_WIDTH - 30*2, 44);
        _submitButton.frame = submitButtonRect;
        [_submitButton addTarget:self action:@selector(submitFormData) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.layer.cornerRadius = 6;
        _submitButton.layer.masksToBounds = YES;
        
    }
    return _submitButton;
}

- (void)submitFormData
{
    DLog(@"form表单数据为:%@",self.OTWPersonalCashFormModel.mj_keyValues);
}

-(void)allCashClick{
    DLog(@"点击了全部提现");
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
