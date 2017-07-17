//
//  OTWSystemNewsViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/16.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWSystemNewsViewController.h"
#import "OTWSystemNewsModel.h"
#import "OTWSystemNewsCellFrame.h"
#import "OTWSystemNewsCell.h"

@interface OTWSystemNewsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *systemNewsTableView;
@property (nonatomic,strong) NSMutableArray *sysNewsFrames;

@end

@implementation OTWSystemNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
    
}

- (void) buildUI
{
    //设置标题
    self.title = @"系统消息";
    //设置返回图标
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    //大背景颜色
    self.view.backgroundColor=[UIColor color_f4f4f4];
    //添加到主视图
    [self.view addSubview:self.systemNewsTableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sysNewsFrames.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OTWSystemNewsCell cellWithTableView:tableView systemNewsCellframe:self.sysNewsFrames[indexPath.row]];
}

-(NSMutableArray*)sysNewsFrames
{
    if (!_sysNewsFrames) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"OTWSystemNews.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
        for (NSDictionary *dict in dictArray) {
            OTWSystemNewsModel *model = [OTWSystemNewsModel initWithDict:dict];
            NSLog(@"%@", model.newsTitle);
            OTWSystemNewsCellFrame *frame = [[OTWSystemNewsCellFrame alloc] init];
            [frame setNewsmodel:model];
            [models addObject:frame];
        }
        self.sysNewsFrames = [models copy];
    }
    return _sysNewsFrames;
}

- (UITableView*)systemNewsTableView
{
    if (!_systemNewsTableView) {
        _systemNewsTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, self.navigationHeight, self.view.width, self.view.height - self.navigationHeight) style:UITableViewStylePlain];
        _systemNewsTableView.dataSource = self;
        _systemNewsTableView.delegate = self;
        _systemNewsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _systemNewsTableView.backgroundColor = [UIColor clearColor];
    }
    return _systemNewsTableView;
}

@end
