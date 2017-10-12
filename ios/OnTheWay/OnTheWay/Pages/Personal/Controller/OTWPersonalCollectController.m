//
//  OTWPersonalCollectController.m
//  OnTheWay
//
//  Created by apple on 2017/7/26.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalCollectController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWPersonalCollectTableViewCell.h"
#import "OTWPersonCollectionModel.h"
#import "OTWBusinessDetailViewController.h"

@interface OTWPersonalCollectController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView;
    NSMutableArray *_status;
}
@property (nonatomic,strong) UIView *noResultView;
@property (nonatomic,strong) UIImageView *noResultImage;
@property (nonatomic,strong) UILabel *noResultLabelOne;
@property (nonatomic,strong) UILabel *noResultLabelTwo;
@end

@implementation OTWPersonalCollectController
{
    NSInteger _pageNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _status = @[].mutableCopy;
    _pageNum = 0;
    [self buildUI];
    [self loadCollectionData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI {
    //设置标题
    self.title = @"我的收藏";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 0;
        [self loadCollectionData];
    }];
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [self loadCollectionData];
    }];
    
    //有收藏
    [self.view addSubview:tableView];
    
    //无收藏
//    [self.view addSubview:self.noResultView];
    
    //不显示底部菜单
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}
- (void)loadCollectionData
{
    NSString * url = @"/app/business/user/likes";
    NSDictionary * dic = @{@"number":@(_pageNum),
                           @"size":@(15)};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       [OTWNetworkManager doGET:url parameters:dic responseCache:^(id responseCache) {
           if([[NSString stringWithFormat:@"%@",responseCache[@"code"]] isEqualToString:@"0"]){
               NSArray * arr = [[responseCache objectForKey:@"body"] objectForKey:@"content"];
               if (_pageNum == 0) {
                   for (NSDictionary * result in arr) {
                       OTWPersonCollectionModel * model = [OTWPersonCollectionModel mj_objectWithKeyValues:result];
                       [_status addObject: model];
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [tableView reloadData];
                       [tableView.mj_header endRefreshing];
                       [tableView.mj_footer endRefreshing];
                   });
               }
           }
       } success:^(id responseObject) {
           if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
               if (_pageNum == 0) {
                   [_status removeAllObjects];
               }
               NSArray * arr = [[responseObject objectForKey:@"body"] objectForKey:@"content"];
               for (NSDictionary * result in arr) {
                   OTWPersonCollectionModel * model = [OTWPersonCollectionModel mj_objectWithKeyValues:result];
                   [_status addObject: model];
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                   [tableView reloadData];
                   [tableView.mj_header endRefreshing];
                   [tableView.mj_footer endRefreshing];
               });
           }
       } failure:^(NSError *error) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [OTWUtils alertFailed:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO target:self];
               [tableView.mj_header endRefreshing];
               [tableView.mj_footer endRefreshing];
           });
           
       }];
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _status.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
    OTWBusinessDetailViewController *businessVC = [[OTWBusinessDetailViewController alloc] init];
    OTWPersonCollectionModel * model = _status[indexPath.row];
    [businessVC setOpData:[NSString stringWithFormat:@"%@",model.businessId]];
    [self.navigationController pushViewController:businessVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"OTWPersonalCollectTableViewCellCellIdentifierK";
    OTWPersonalCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWPersonalCollectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
        cell.model = _status[indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
        _noResultImage.frame=CGRectMake((SCREEN_WIDTH-151)/2, 130, 151, 109);
        _noResultImage.image=[UIImage imageNamed:@"wd_wushoucang"];
    }
    return _noResultImage;
}

-(UILabel*)noResultLabelOne{
    if(!_noResultLabelOne){
        _noResultLabelOne=[[UILabel alloc]init];
        _noResultLabelOne.text=@"你还没有任何收藏呢";
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
        _noResultLabelTwo.text=@"赶快行动起来吧";
        _noResultLabelTwo.font=[UIFont systemFontOfSize:13];
        _noResultLabelTwo.textColor=[UIColor color_979797];
        [_noResultLabelTwo sizeToFit];
        _noResultLabelTwo.frame=CGRectMake(0, self.noResultLabelOne.MaxY+10, SCREEN_WIDTH, _noResultLabelTwo.Height);
        _noResultLabelTwo.textAlignment=NSTextAlignmentCenter;
    }
    return _noResultLabelTwo;
}
@end
