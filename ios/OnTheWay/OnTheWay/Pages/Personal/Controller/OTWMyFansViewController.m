//
//  OTWMyFansViewController.m
//  OnTheWay
//
//  Created by apple on 2017/10/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWMyFansViewController.h"
#import "OTWMyFansTableViewCell.h"
#import "OTWMyFansModel.h"
#import "OTWMyFansParameter.h"
#import "OTWPersonalFootprintsListController.h"
#import "OTWUserModel.h"

@interface OTWMyFansViewController ()<UITableViewDelegate,UITableViewDataSource,OTWPersonalFootprintsListControllerDelegate>

@property (nonatomic, strong) UITableView * tableview;

@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, strong) OTWMyFansParameter * parameter;

@property (nonatomic,strong) UIView *noResultView;
@property (nonatomic,strong) UIImageView *noResultImage;
@property (nonatomic,strong) UILabel *noResultLabelOne;
@property (nonatomic,strong) UILabel *noResultLabelTwo;

@end

@implementation OTWMyFansViewController
{
    NSString *_imageStr;
    NSString *_tipsOne;
    NSString *_tipsTwo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isFromFans) {
        self.title = @"我的粉丝";
        _imageStr = @"qx_wufensi";
        _tipsOne = @"一个粉丝都没有";
        _tipsTwo = @"是不是有点孤单呢";
    }else
    {
        self.title = @"我的关注";
        _imageStr = @"qx_wuguanzhu";
        _tipsOne = @"一个人是不是很无聊呢";
        _tipsTwo = @"那就去关注更多小伙伴吧";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];

    _dataArr = @[].mutableCopy;
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.parameter.number = 0;
        [self loadData];
    }];
    
    _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.parameter.number++;
        [self loadData];
    }];
    [self.view addSubview:_tableview];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flag=@"OTWMyFansTableViewCell";
    OTWMyFansTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell=[[OTWMyFansTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OTWMyFansModel * model = _dataArr[indexPath.row];
    OTWPersonalFootprintsListController *personalSiteVC = [OTWPersonalFootprintsListController initWithIfMyFootprint:[[OTWUserModel shared].userId.description isEqualToString:[NSString stringWithFormat:@"%@",model.userId]]];
    personalSiteVC.userId = [NSString stringWithFormat:@"%@",model.userId];
    personalSiteVC.userNickname = model.userNickname;
    personalSiteVC.userHeaderImg = model.userHeadImg;
    personalSiteVC.isFromFans = _isFromFans;
    personalSiteVC.delegate = self;
    [self.navigationController pushViewController:personalSiteVC animated:YES];
}
- (void)loadData
{
    NSString * url = @"/app/attention/search";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       [OTWNetworkManager doGET:url parameters:self.parameter.mj_keyValues responseCache:^(id responseCache) {
           if([[NSString stringWithFormat:@"%@",responseCache[@"code"]] isEqualToString:@"0"]){
               NSArray * arr = [[responseCache objectForKey:@"body"] objectForKey:@"content"];
               if (self.parameter.number == 0) {
                   [_dataArr removeAllObjects];
                   for (NSDictionary * result in arr) {
                       OTWMyFansModel * model = [OTWMyFansModel mj_objectWithKeyValues:result];
                       model.userHeadImg = [NSString stringWithFormat:@"%@%@",model.userHeadImg,FriendsHeadImageSize];
                       [_dataArr addObject: model];
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [_tableview reloadData];
                       [_tableview.mj_header endRefreshing];
                       [_tableview.mj_footer endRefreshing];
                   });
               }
           }
       } success:^(id responseObject) {
           if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
               if (self.parameter.number == 0) {
                   [_dataArr removeAllObjects];
               }
               NSArray * arr = [[responseObject objectForKey:@"body"] objectForKey:@"content"];
               for (NSDictionary * result in arr) {
                   OTWMyFansModel * model = [OTWMyFansModel mj_objectWithKeyValues:result];
                   model.userHeadImg = [NSString stringWithFormat:@"%@%@",model.userHeadImg,FriendsHeadImageSize];
                   [_dataArr addObject: model];
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                   if (arr.count == 0 && self.parameter.number == 0) {
                       [self.view addSubview:self.noResultView];
                   }
                   if (arr.count == 0 || arr.count < 15) {
                       [_tableview.mj_footer endRefreshingWithNoMoreData];
                   }else{
                       [_tableview.mj_footer endRefreshing];
                   }
                   [_tableview reloadData];
                   [_tableview.mj_header endRefreshing];
               });
           }
           
       } failure:^(NSError *error) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [OTWUtils alertFailed:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO target:self];
               [_tableview.mj_header endRefreshing];
               [_tableview.mj_footer endRefreshing];
           });
       }];
    });
    
}
- (void)leftNavigaionButtonClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshData)]) {
        [_delegate refreshData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)refresh
{
    [_tableview.mj_header beginRefreshing];
}
- (OTWMyFansParameter *)parameter
{
    if (!_parameter) {
        _parameter = [[OTWMyFansParameter alloc] init];
        _parameter.number = 0;
        _parameter.size = 15;
        if (_isFromFans) {
            _parameter.type = @"fans";
        }else{
            _parameter.type = @"attention";
        }
    }
    return _parameter;
}

-(UIView*)noResultView{
    if(!_noResultView){
        _noResultView=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight+1, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationHeight)];
        _noResultView.backgroundColor=[UIColor whiteColor];
        [_noResultView addSubview:self.noResultImage];
        [_noResultView addSubview:self.noResultLabelOne];
        [_noResultView addSubview:self.noResultLabelTwo];
    }
    
    return _noResultView;
}
-(UIImageView*)noResultImage{
    if(!_noResultImage){
        _noResultImage=[[UIImageView alloc]init];
        _noResultImage.frame=CGRectMake((SCREEN_WIDTH-151)/2, 130 + 64, 151, 109);
        _noResultImage.image=[UIImage imageNamed:_imageStr];
    }
    return _noResultImage;
}

-(UILabel*)noResultLabelOne{
    if(!_noResultLabelOne){
        _noResultLabelOne=[[UILabel alloc]init];
        _noResultLabelOne.text = _tipsOne;
        _noResultLabelOne.font=[UIFont systemFontOfSize:13];
        _noResultLabelOne.textColor=[UIColor color_979797];
        [_noResultLabelOne sizeToFit];
        _noResultLabelOne.frame=CGRectMake(0, self.noResultImage.MaxY+15, SCREEN_WIDTH, _noResultLabelOne.Height);
        _noResultLabelOne.textAlignment=NSTextAlignmentCenter;
    }
    return _noResultLabelOne;
}

-(UILabel*)noResultLabelTwo{
    if(!_noResultLabelTwo){
        _noResultLabelTwo=[[UILabel alloc]init];
        _noResultLabelTwo.text = _tipsTwo;
        _noResultLabelTwo.font=[UIFont systemFontOfSize:13];
        _noResultLabelTwo.textColor=[UIColor color_979797];
        [_noResultLabelTwo sizeToFit];
        _noResultLabelTwo.frame=CGRectMake(0, self.noResultLabelOne.MaxY+10, SCREEN_WIDTH, _noResultLabelTwo.Height);
        _noResultLabelTwo.textAlignment=NSTextAlignmentCenter;
    }
    return _noResultLabelTwo;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
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
