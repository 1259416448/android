//
//  OTWActiveTypeChooseView.m
//  OnTheWay
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWActiveTypeChooseView.h"
#import "OTWActiveTypeTableViewCell.h"

@interface OTWActiveTypeChooseView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * footView;

@end

@implementation OTWActiveTypeChooseView
{
    NSMutableArray<OTWBusinessActivityModel *> *_dataArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _dataArr = @[].mutableCopy;
        [self prepareData];
//        _imageArr = @[@"",@"",@"",@""];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 225, SCREEN_WIDTH, 225)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        _footView.backgroundColor = [UIColor clearColor];
        UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 44)];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor color_202020] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:cancelBtn];
        _tableView.tableFooterView = _footView;
    }
    return self;
}
- (void)cancelBtnClick
{
    self.hidden = YES;
}
- (void)prepareData
{
    NSArray *array = @[@{
                           @"name":@"优惠券",
                           @"colorStr":@"FF5959",
                           @"typeName":@"券",
                           @"url":@""
                           },@{
                           @"name":@"特价",
                           @"colorStr":@"61CB60",
                           @"typeName":@"促",
                           @"url":@""
                           },@{
                           @"name":@"团购",
                           @"colorStr":@"FB903E",
                           @"typeName":@"团",
                           @"url":@""
                           },
                             @{
                           @"name":@"外卖",
                           @"colorStr":@"3DC3EC",
                           @"typeName":@"外",
                           @"url":@""
                           }];
    _dataArr = [OTWBusinessActivityModel mj_objectArrayWithKeyValuesArray:array];
}
#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

#pragma mark - 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flag=@"OTWActiveTypeTableViewCell";
    OTWActiveTypeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell=[[OTWActiveTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = _dataArr[indexPath.row];    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectedModel:)]) {
        [_delegate selectedModel:_dataArr[indexPath.row]];
        self.hidden = YES;
    }
}



@end
