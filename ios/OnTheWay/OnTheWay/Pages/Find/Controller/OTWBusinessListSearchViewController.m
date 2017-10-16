//
//  OTWBusinessListSearchViewController.m
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/10/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessListSearchViewController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWBusinessARViewController.h"
#import "TagViewCell.h"
#import "OTWUserModel.h"

@interface OTWBusinessListSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,TagViewCellDelegate>

@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation OTWBusinessListSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[];
    // Do any additional setup after loading the view.
    [self buildUI];
    [self readSearchHistory];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
    [self.searchTF becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[OTWLaunchManager sharedManager].mainTabController showTabBarWithAnimation:YES];
}
- (void)readSearchHistory
{
    //读取搜索历史记录
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if ([[OTWUserModel shared].mobilePhoneNumber isEqualToString:@""] || [OTWUserModel shared].mobilePhoneNumber == nil) {
    }else{
        NSArray * arr = [userDefault objectForKey:[NSString stringWithFormat:@"%@%@",searchHistory,[OTWUserModel shared].mobilePhoneNumber]];
        if (arr.count == 0 || arr == nil) {
        }else
        {
            _dataArray = [NSArray arrayWithArray:[userDefault objectForKey:[NSString stringWithFormat:@"%@%@",searchHistory,[OTWUserModel shared].mobilePhoneNumber]]];
            _dataArray = [[[_dataArray reverseObjectEnumerator] allObjects] copy];
            [_tableView reloadData];
        }
    }
    
}
- (void)buildUI
{
    [self.customNavigationBar addSubview:self.searchTF];
    [self.customNavigationBar addSubview:self.cancelBtn];
    //大背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TagViewCell cellHeightTextArray:_dataArray Row:indexPath.section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel * headLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 100, 12)];
    headLabel.font = [UIFont systemFontOfSize:12];
    headLabel.textColor = [UIColor color_979797];
    headLabel.text = @"历史搜索";
    [headView addSubview:headLabel];
    UIButton * deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 18.5, 45, 35)];
    [deleteBtn setImage:[UIImage imageNamed:@"ar_ss_shanchu"] forState:UIControlStateNormal];
    [headView addSubview:deleteBtn];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TagViewCell.class)];
    cell.delegate = self;
    if (_dataArray.count > 10) {
        [cell setTextArray:[_dataArray subarrayWithRange:NSMakeRange(0, 10)] row:indexPath.section];
    }else
    {
        [cell setTextArray:_dataArray row:indexPath.section];
    }
    return cell;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT - 65) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[TagViewCell class] forCellReuseIdentifier:NSStringFromClass(TagViewCell.class)];
    }
    return _tableView;
}
- (UITextField *)searchTF
{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 25, SCREEN_WIDTH - 77, 33)];
        _searchTF.layer.cornerRadius = 20;
        _searchTF.placeholder = @"搜索附近的美食、商城";
        _searchTF.returnKeyType = UIReturnKeySearch;//变为搜索按钮
        _searchTF.delegate = self;
        _searchTF.font = [UIFont systemFontOfSize:14];
        _searchTF.layer.masksToBounds = YES;
        _searchTF.layer.borderColor = [UIColor clearColor].CGColor;
        _searchTF.backgroundColor=[[UIColor color_f4f4f4]colorWithAlphaComponent:0.9f];
        _searchTF.layer.borderWidth = 0.5;
        //设置图标
        UIImage *image = [UIImage imageNamed: @"sousuo_1"];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        iView.contentMode = UIViewContentModeCenter;
        iView.frame = CGRectMake(0, 0, 40 , 33);
        _searchTF.leftView = iView;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTF;
}

-(UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_cancelBtn setTitle: @"取消" forState: UIControlStateNormal];
        _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cancelBtn setTitleColor:[UIColor color_202020]forState:UIControlStateNormal];
        
        _cancelBtn.frame =CGRectMake(self.searchTF.Witdh+30, 25.5+6, 35, 22.5);
        
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.showsTouchWhenHighlighted = NO;
        
    }
    return _cancelBtn;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //保存搜索历史记录
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if ([[OTWUserModel shared].mobilePhoneNumber isEqualToString:@""] || [OTWUserModel shared].mobilePhoneNumber == nil) {
    }else{
        NSMutableArray * arr = [[userDefault objectForKey:[NSString stringWithFormat:@"%@%@",searchHistory,[OTWUserModel shared].mobilePhoneNumber]] mutableCopy];
        if (arr.count == 0 || arr == nil) {
            arr = @[].mutableCopy;
        }
        [arr addObject:textField.text];
        
        [userDefault setObject:[arr copy] forKey:[NSString stringWithFormat:@"%@%@",searchHistory,[OTWUserModel shared].mobilePhoneNumber]];
    }
    
    if (_isFromFind) {
        [OTWLaunchManager sharedManager].BusinessARVC.searchText = textField.text;
        [OTWLaunchManager sharedManager].BusinessARVC.isFromFind = YES;
        [self.navigationController pushViewController:[OTWLaunchManager sharedManager].BusinessARVC animated:NO];
        return YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(searchWithStr:)]) {
        [_delegate searchWithStr:textField.text];
    }
    if (_isFromAR) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"点击了搜索");
    return YES;
}
-(void)cancelBtnClick{
    DLog(@"点击了取消");
    if (_isFromAR) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)selectedAtIndex:(NSInteger)index
{
    NSString * str = [_dataArray objectAtIndex:index];

    if (_isFromFind) {
        [OTWLaunchManager sharedManager].BusinessARVC.searchText = str;
        [OTWLaunchManager sharedManager].BusinessARVC.isFromFind = YES;
        [self.navigationController pushViewController:[OTWLaunchManager sharedManager].BusinessARVC animated:NO];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(searchWithStr:)]) {
        [_delegate searchWithStr:str];
    }
    if (_isFromAR) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
