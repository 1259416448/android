//
//  OTWNewCommentListViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewCommentListViewController.h"
#import "OTWNewsCommentModel.h"
#import "OTWNewsCommentTableCell.h"

@interface OTWNewCommentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<OTWNewsCommentModel *> *commentModels;
@property (nonatomic, strong) NSMutableArray<OTWNewsCommentTableCell *> *commentTableCells;
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic,strong) UIView *headerV;

@end

@implementation OTWNewCommentListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)setupBase
{
    self.title = @"新的评论";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor = [UIColor color_f4f4f4];
    [self.view addSubview:self.tableV];
}

- (UITableView *)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableV.dataSource = self;
        _tableV.delegate = self;
        _tableV.separatorColor = [UIColor color_f4f4f4];
        _tableV.backgroundColor = [UIColor clearColor];
        _tableV.tableHeaderView = self.headerV;
    }
    return _tableV;
}

- (UIView *)headerV
{
    if (!_headerV) {
        _headerV = [[UIView alloc] init];
        _headerV.backgroundColor = [UIColor color_f4f4f4];
        _headerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    }
    return _headerV;
}

#pragma mark 加载数据
- (void)initData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"OTWNewsCommentList.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    _commentModels = [[NSMutableArray alloc] init];
    _commentTableCells = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj=%@ idx=%ld",obj,idx);
        [_commentModels addObject:[OTWNewsCommentModel commentModelWithDictionary:obj]];
        OTWNewsCommentTableCell *cell = [[OTWNewsCommentTableCell alloc] init];
        [_commentTableCells addObject:cell];
    }];
}

#pragma mark 数据源方法
#pragma mark 返回分组数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentModels.count;
}

#pragma mark返回每行单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UINewsCommentTableViewCellIdentifierKey";
    OTWNewsCommentTableCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OTWNewsCommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    OTWNewsCommentModel  *comment = _commentModels[indexPath.row];
    cell.commentModel = comment;
    return cell;
}

#pragma mark 代理方法
#pragma mark 重新设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTWNewsCommentTableCell *cell = _commentTableCells[indexPath.row];
    cell.commentModel = _commentModels[indexPath.row];
    NSLog(@"x=%ld",(long)indexPath.row);
    NSLog(@"x=%ld",(long)_commentTableCells.count);
    if (indexPath.row == _commentTableCells.count - 1) {
        return cell.height + 20;
    }
    return cell.height;
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
