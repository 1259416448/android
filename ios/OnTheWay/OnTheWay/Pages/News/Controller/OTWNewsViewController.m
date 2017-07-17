//
//  OTWNewsViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewsViewController.h"
#import "OTWSystemNewsViewController.h"
#import "OTWNewsCell.h"

@interface OTWNewsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation OTWNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildUI
{
    self.title = @"消息";
    self.view.backgroundColor = [UIColor color_f4f4f4];
    
    self.icons = @[@"news_xitong", @"news_xindezan", @"news_xindepinglun"];
    self.titles = @[@"系统消息", @"新的赞", @"新的评论"];
    
    [self.view addSubview:self.tableView];
    
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, self.view.width, self.view.height-self.navigationHeight) style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.separatorColor = [UIColor color_f4f4f4];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentSize = CGSizeMake(self.view.width, self.view.height - self.navigationHeight);
    }
    
    return _tableView;
}

#pragma mark - UITableViewDelegate & UITableViewDatasoure

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTWNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OTWNewsCell"];
    if (!cell) {
        cell = [[OTWNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OTWNewsCell"];
        [cell setFrame:CGRectMake(0, 0, self.view.width, 50)];
        [cell addContentView];
    }
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.subTitleLabel.text = @"99";
    cell.iconImageView.image = [UIImage imageNamed:self.icons[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: // 系统消息
        {
            DLog(@"我点击了：%ld",indexPath.row);
            OTWSystemNewsViewController *personalSiteVC = [[OTWSystemNewsViewController alloc] init];
            [self.navigationController pushViewController:personalSiteVC animated:YES];
        }
            break;
        case 1: // 新的赞
        {
            
        }
            break;
        case 2: // 新的评论
        {
            
            
        }
            break;
        default:
            
            break;
    }
}

@end
