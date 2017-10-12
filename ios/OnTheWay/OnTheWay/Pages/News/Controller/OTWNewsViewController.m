//
//  OTWNewsViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewsViewController.h"
#import "OTWSystemNewsViewController.h"
#import "OTWNoSystemNewViewController.h"
#import "OTWPraiseViewController.h"
#import "OTWNoPraiseViewController.h"
#import "OTWNewCommentListViewController.h"
#import "OTWNewFootprintsControllerViewController.h"
#import "OTWNoFootprintViewController.h"
#import "OTWNewsCell.h"
#import "OTWFootprintService.h"
#import "OTWFootprintSearchParams.h"
#import "OTWSystemNewService.h"

@interface OTWNewsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) OTWNewsModel *newsModel;
@end

@implementation OTWNewsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController showTabBarWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchSystemNews];
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
    
    self.icons = @[@"news_xitong", @"news_xindezan", @"news_xindepinglun",@"xx_dongtai"];
    self.titles = @[@"系统消息", @"新的赞", @"新的评论",@"新的足迹动态"];
    
    [self.view addSubview:self.tableView];
    
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationHeight + 1, self.view.width, self.view.height-self.navigationHeight) style:UITableViewStylePlain];
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
    cell.iconImageView.image = [UIImage imageNamed:self.icons[indexPath.row]];
    cell.subTitleLabel.hidden = NO;
    switch (indexPath.row) {
        case 0: // 系统消息
        {
            cell.subTitleLabel.text = self.newsModel.systemNum;
            if ([self.newsModel.systemNum isEqualToString:@"0"]) {
                cell.subTitleLabel.hidden = YES;
            }
        }
            break;
        case 1: // 新的赞
        {
            cell.subTitleLabel.text = self.newsModel.likeNum;
            if ([self.newsModel.likeNum isEqualToString:@"0"]) {
                cell.subTitleLabel.hidden = YES;
            }
        }
            break;
        case 2: // 新的评论
        {
            cell.subTitleLabel.text = self.newsModel.CommentNum;
            if ([self.newsModel.CommentNum isEqualToString:@"0"]) {
                cell.subTitleLabel.hidden = YES;
            }
        }
            break;
            
        case 3://新的足迹动态
        {
            cell.subTitleLabel.text = self.newsModel.footprintNum;
            if ([self.newsModel.footprintNum isEqualToString:@"0"]) {
                cell.subTitleLabel.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: // 系统消息
        {
            if (![self.newsModel.systemNum isEqualToString:@"0"]) {
                OTWSystemNewsViewController *systemNewsVC = [[OTWSystemNewsViewController alloc] init];
                [self.navigationController pushViewController:systemNewsVC animated:YES];
            } else {
                OTWNoSystemNewViewController *noSystemNewsVC = [[OTWNoSystemNewViewController alloc] init];
                [self.navigationController pushViewController:noSystemNewsVC animated:YES];
            }

        }
            break;
        case 1: // 新的赞
        {
            if (![self.newsModel.likeNum isEqualToString:@"0"]) {
                OTWPraiseViewController *praiseVC = [[OTWPraiseViewController alloc] init];
                [self.navigationController pushViewController:praiseVC animated:YES];
            } else {
                OTWNoPraiseViewController *noPraiseVC = [[OTWNoPraiseViewController alloc] init];
                [self.navigationController pushViewController:noPraiseVC animated:YES];
            }
        }
            break;
        case 2: // 新的评论
        {
            
            OTWNewCommentListViewController *newsCommentVC = [[OTWNewCommentListViewController alloc] init];
            [self.navigationController pushViewController:newsCommentVC animated:YES];
        }
            break;
            
        case 3://新的足迹动态
        {
        
            if (![self.newsModel.footprintNum isEqualToString:@"0"]) {
                OTWNewFootprintsControllerViewController *newsFootprintsVC = [[OTWNewFootprintsControllerViewController alloc] init];
                [self.navigationController pushViewController:newsFootprintsVC animated:YES];
            } else {
                OTWNoFootprintViewController *noFootprintsVC = [[OTWNoFootprintViewController alloc] init];
                [self.navigationController pushViewController:noFootprintsVC animated:YES];
            }
        }
        break;
        default:
            
            break;
    }
}

-(OTWNewsModel*)newsModel
{
    if (!_newsModel) {
        _newsModel = [[OTWNewsModel alloc] init];
        _newsModel.footprintNum = @"0";
        _newsModel.systemNum = @"0";
        _newsModel.CommentNum = @"0";
        _newsModel.likeNum = @"0";
    }
    return _newsModel;
}


-(void)fetchSystemNews
{
    [OTWSystemNewService loadAllSystemNews:nil completion:^(id result, NSError *error) {
        if(result){
            if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
                self.newsModel = [OTWNewsModel initWithDict:result[@"body"]];
                [self.tableView reloadData];
            }else{
                DLog(@"message - %@  messageCode - %@",result[@"message"],result[@"messageCode"]);
                [self errorTips:@"发布失败，请检查您的网络是否连接" userInteractionEnabled:YES];
            }
        }else{
            [self netWorkErrorTips:error];
        }
    }];
}

@end
