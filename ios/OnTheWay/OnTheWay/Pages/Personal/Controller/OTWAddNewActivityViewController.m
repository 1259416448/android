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

@interface OTWAddNewActivityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableview;

@end

@implementation OTWAddNewActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布活动";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
}
- (void)buildUI
{
    [self.view addSubview:self.tableview];
}
- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

//#pragma mark 这一组里面有多少行
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (tableView == _siftSortTableView) {
//        return _siftSortArr.count;
//    }else if (tableView == _siftDetailTableView)
//    {
//        NSInteger count = 0;
//        for (OTWBusinessSortModel * model in _siftSortArr) {
//            if (model.selected) {
//                count = model.children.count;
//            }
//        }
//        return count;
//    }else
//    {
//        return _status.count;
//    }
//}
//
//#pragma mark - 代理方法
//#pragma mark 设置分组标题内容高度
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (tableView == _tableView) {
//        return 36.5;
//    }else
//    {
//        return 0.01;
//    }
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (tableView == _tableView) {
//        UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36.5)];
//        headView.backgroundColor = [UIColor color_f4f4f4];
//        UILabel * all = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 12)];
//        all.textColor = [UIColor color_979797];
//        all.text = @"全部";
//        all.font = [UIFont systemFontOfSize:12];
//        [headView addSubview:all];
//        return headView;
//    }else
//    {
//        return nil;
//    }
//    
//}
//
//#pragma mark 返回分组数
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//#pragma mark 设置每行高度（每行高度可以不一样）
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView == _tableView) {
//        return 70;
//    }else
//    {
//        return 44;
//    }
//}


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
