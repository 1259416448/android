//
//  OTWSelectBarViewController.m
//  OnTheWay
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWSelectBarViewController.h"
#import "LinkageMenuView.h"
#import "OneView.h"
#import "TwoView.h"
#import "OneCollectionViewCell.h"
#import "OTWBusinessARSiftTableViewCell.h"
#import "OTWBusinessSortModel.h"
#import "OTWBusinessARSiftDetailTableViewCell.h"
#define FUll_VIEW_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define FUll_VIEW_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)
#define NAVIGATION_HEIGHT 64  //navigationbar height
#define TABBAR_HEIGHT 49  //tabbar height

@interface OTWSelectBarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *siftSortTableView;
@property(nonatomic,strong) UITableView *siftDetailTableView;
@property(nonatomic,strong) UIButton *sureBtn;

@property (nonatomic, copy) NSString * selectedStr;

//筛选分类数据
@property(nonatomic,strong) NSMutableArray *siftSortArr;


@end

@implementation OTWSelectBarViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setBase
{
    self.title = @"商家类型";
    _siftSortArr = @[].mutableCopy;
    _selectedStr = @"";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    [self setCustomNavigationRightView:self.sureBtn];
    self.view.backgroundColor = [UIColor color_f4f4f4];
    [self.view addSubview:self.siftSortTableView];
    [self.view addSubview:self.siftDetailTableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBase];
    [self getbusinessSortData];
}

#pragma mark tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _siftSortTableView) {
        return _siftSortArr.count;
    }else if (tableView == _siftDetailTableView)
    {
        NSInteger count = 0;
        for (OTWBusinessSortModel * model in _siftSortArr) {
            if (model.selected) {
                count = model.children.count;
            }
        }
        return count;
    }else
    {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _siftSortTableView) {
        static NSString *flag=@"OTWBusinessARSiftTableViewCell";
        OTWBusinessARSiftTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell == nil) {
            cell=[[OTWBusinessARSiftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        OTWBusinessSortModel * model = _siftSortArr[indexPath.row];
        cell.titleLabel.text = model.name;
        if (model.selected) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.textColor = [UIColor colorWithHexString:model.colorCode];
            cell.redLine.hidden = NO;
        }else
        {
            cell.backgroundColor = [UIColor color_f4f4f4];
            cell.titleLabel.textColor = [UIColor color_202020];
            cell.redLine.hidden = YES;
        }
        return cell;
    }else if (tableView == _siftDetailTableView)
    {
        static NSString *flag=@"OTWBusinessARSiftDetailTableViewCell";
        OTWBusinessARSiftDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell == nil) {
            cell=[[OTWBusinessARSiftDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        for (OTWBusinessSortModel * model in _siftSortArr) {
            if (model.selected) {
                OTWBusinessDetailSortModel * detailModel = model.children[indexPath.row];
                cell.titleLabel.text = detailModel.name;
                if (detailModel.selected) {
                    cell.selectedImg.hidden = NO;
                }else
                {
                    cell.selectedImg.hidden = YES;
                }
            }
        }
        return cell;
    }else
    {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _siftSortTableView) {
        for (OTWBusinessSortModel * model in _siftSortArr) {
            model.selected = NO;
        }
        OTWBusinessSortModel * model = _siftSortArr[indexPath.row];
        model.selected = YES;
        [_siftSortTableView reloadData];
        [_siftDetailTableView reloadData];
    }else if (tableView == _siftDetailTableView)
    {
        for (OTWBusinessSortModel * models in _siftSortArr) {
            for (OTWBusinessDetailSortModel * result in models.children) {
                result.selected = NO;
            }
        }
        for (OTWBusinessSortModel * model in _siftSortArr) {
            if (model.selected) {
                OTWBusinessDetailSortModel * detailModel = model.children[indexPath.row];
                detailModel.selected = YES;
                _selectedStr = detailModel.name;
                //                [self startPoiSearch];
            }
        }
        [_siftSortTableView reloadData];
        [_siftDetailTableView reloadData];
    }else{
    }
}

#pragma mark 获取店家分类信息

- (void)getbusinessSortData
{
    NSString * url = @"/app/business/type/all";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [OTWNetworkManager doGET:url parameters:nil responseCache:^(id responseCache) {
            if([[NSString stringWithFormat:@"%@",responseCache[@"code"]] isEqualToString:@"0"]){
                NSArray *arr = [NSArray arrayWithArray:[responseCache objectForKey:@"body"]];
                for (NSDictionary *result in arr)
                {
                    OTWBusinessSortModel * model = [OTWBusinessSortModel mj_objectWithKeyValues:result];
                    model.selected = NO;
                    [_siftSortArr addObject:model];
                }
                [self reloadTableView];
            }
        } success:^(id responseObject) {
            if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
                [_siftSortArr removeAllObjects];
                NSArray *arr = [NSArray arrayWithArray:[responseObject objectForKey:@"body"]];
                
                for (NSDictionary *result in arr)
                {
                    OTWBusinessSortModel * model = [OTWBusinessSortModel mj_objectWithKeyValues:result];
                    model.selected = NO;
                    [_siftSortArr addObject:model];
                }
                [self reloadTableView];
            }
        } failure:^(NSError *error) {
            
        }];
    });
    
}
- (void)reloadTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        OTWBusinessSortModel * model = _siftSortArr[0];
        model.selected = YES;
        [_siftSortTableView reloadData];
        [_siftDetailTableView reloadData];
    });
}

//点击确定
- (void)sureBtnClick
{
    if ([_selectedStr isEqualToString:@""] || _selectedStr == nil) {
        [self errorTips:@"请选择商家类型" userInteractionEnabled:YES];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(didSelected:)]) {
            [_delegate didSelected: _selectedStr];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) errorTips:(NSString *)tips userInteractionEnabled:(BOOL)userInteractionEnabled
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = tips;
    hud.label.numberOfLines = 0;
    hud.userInteractionEnabled = userInteractionEnabled;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    [hud hideAnimated:YES afterDelay:2];
}

- (UITableView *)siftSortTableView
{
    if (!_siftSortTableView) {
        _siftSortTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH * 0.36, SCREEN_HEIGHT - 65) style:UITableViewStylePlain];
        _siftSortTableView.delegate = self;
        _siftSortTableView.dataSource = self;
        _siftSortTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _siftSortTableView.backgroundColor = [UIColor color_f4f4f4];
    }
    return _siftSortTableView;
}

- (UITableView *)siftDetailTableView
{
    if (!_siftDetailTableView) {
        _siftDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.36, 65, SCREEN_WIDTH * 0.64, SCREEN_HEIGHT - 65) style:UITableViewStylePlain];
        _siftDetailTableView.delegate = self;
        _siftDetailTableView.dataSource = self;
        _siftDetailTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _siftDetailTableView.backgroundColor = [UIColor whiteColor];
    }
    return _siftDetailTableView;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 35, 0, 35, 23)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor color_202020] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


@end
