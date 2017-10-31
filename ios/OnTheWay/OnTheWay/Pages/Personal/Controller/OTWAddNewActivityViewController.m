//
//  OTWAddNewActivityViewController.m
//  OnTheWay
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWAddNewActivityViewController.h"
#import "OTWAddNewActiveTableViewCellOne.h"
#import "OTWAddNewActiveTableViewCellTwo.h"
#import "OTWAddNewActiveTableViewCellThree.h"
#import "OTWAddNewActiveTableViewCellFour.h"
#import "OTWActiveTypeChooseView.h"

@interface OTWAddNewActivityViewController ()<UITableViewDelegate,UITableViewDataSource,OTWActiveTypeChooseViewDelegate>

@property (nonatomic, strong) UITableView * tableview;

@property (nonatomic, strong) UIView * footView;
@property (nonatomic,strong) UIButton *submitButton;
@property (nonatomic,strong) UILabel *tipsLabel;

@property (nonatomic, strong) NSArray * titleArr;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) OTWActiveTypeChooseView *activeChooseView;



@end

@implementation OTWAddNewActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布活动";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    _titleArr = @[@"活动名称*",@"开始时间*",@"结束时间*",@"活动类型*",@"活动网址",@"活动简介"];
    [self buildUI];
    
}
- (void)buildUI
{
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.datePicker];
    [[UIApplication sharedApplication].keyWindow addSubview:self.activeChooseView];
}
- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.tableFooterView = self.footView;
    }
    return _tableview;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

#pragma mark - 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        return 185;
    }else
    {
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 4) {
        static NSString *flag=@"OTWAddNewActiveTableViewCellOne";
        OTWAddNewActiveTableViewCellOne *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell == nil) {
            cell=[[OTWAddNewActiveTableViewCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_titleArr[indexPath.row]];
        if (attrStr.length == 5) {
            //添加文字颜色
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor color_e50834] range:NSMakeRange(4, 1)];
            cell.titleLabel.attributedText = attrStr;
            cell.detailTF.placeholder = @"请输入活动名称";
        }else{
            cell.titleLabel.text = _titleArr[indexPath.row];
            cell.detailTF.placeholder = @"例：www.iidsf.com";
        }

        return cell;
    }else if (indexPath.row == 1 || indexPath.row == 2)
    {
        static NSString *flag=@"OTWAddNewActiveTableViewCellTwo";
        OTWAddNewActiveTableViewCellTwo *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell == nil) {
            cell=[[OTWAddNewActiveTableViewCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_titleArr[indexPath.row]];
        if (attrStr.length == 5) {
            //添加文字颜色
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor color_e50834] range:NSMakeRange(4, 1)];
            cell.titleLabel.attributedText = attrStr;
        }else{
            cell.titleLabel.text = _titleArr[indexPath.row];
        }
        return cell;
    }else if (indexPath.row == 3)
    {
        static NSString *flag=@"OTWAddNewActiveTableViewCellThree";
        OTWAddNewActiveTableViewCellThree *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell == nil) {
            cell=[[OTWAddNewActiveTableViewCellThree alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_titleArr[indexPath.row]];
        if (attrStr.length == 5) {
            //添加文字颜色
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor color_e50834] range:NSMakeRange(4, 1)];
            cell.titleLabel.attributedText = attrStr;
        }else{
            cell.titleLabel.text = _titleArr[indexPath.row];
        }
        return cell;
    }else if (indexPath.row == 5)
    {
        static NSString *flag=@"OTWAddNewActiveTableViewCellFour";
        OTWAddNewActiveTableViewCellFour *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell == nil) {
            cell=[[OTWAddNewActiveTableViewCellFour alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = _titleArr[indexPath.row];
        return cell;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 2) {
        [_datePicker setDate:[NSDate date]];
        _datePicker.hidden = NO;
    }else
    {
        _datePicker.hidden = YES;
        if (indexPath.row == 3)
        {
            _activeChooseView.hidden = NO;
        }
    }
}

- (void)valueChange:(UIDatePicker *)datePicker{
//    //创建一个日期格式
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    //设置日期的显示格式
//    fmt.dateFormat = @"yyyy-MM-dd";
//    //将日期转为指定格式显示
//    NSString *dateStr = [fmt stringFromDate:datePicker.date];
//    _birthdayField.text = dateStr;
}

- (void)selectedTitle:(NSString *)title
{
    _activeChooseView.hidden = YES;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        //创建UIDatePicker
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 180, SCREEN_WIDTH, 180)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.hidden = YES;
        //设置本地语言
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //设置日期显示的格式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        //监听datePicker的ValueChanged事件
        [_datePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}
- (UIButton*)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_submitButton setTitle:@"发布" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.backgroundColor = [UIColor color_e50834];
        _submitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        CGRect submitButtonRect = CGRectMake(30, 80, SCREEN_WIDTH - 30*2, 44);
        _submitButton.frame = submitButtonRect;
        [_submitButton addTarget:self action:@selector(submitFormData) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.layer.cornerRadius = 3;
        _submitButton.layer.masksToBounds = YES;
        
    }
    return _submitButton;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 158)];
        _footView.backgroundColor = [UIColor color_f4f4f4];
        [_footView addSubview:self.tipsLabel];
        [_footView addSubview:self.submitButton];
    }
    return _footView;
}
- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 11)];
        _tipsLabel.textColor = [UIColor color_e50834];
        _tipsLabel.font = [UIFont systemFontOfSize:11];
        _tipsLabel.text = @"* 为必填信息";
    }
    return _tipsLabel;
}
- (OTWActiveTypeChooseView *)activeChooseView
{
    if (!_activeChooseView) {
        _activeChooseView = [[OTWActiveTypeChooseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _activeChooseView.hidden = YES;
        _activeChooseView.titleArr = @[@"优惠券",@"特价",@"团购",@"外卖"];
        _activeChooseView.delegate = self;
    }
    return _activeChooseView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
