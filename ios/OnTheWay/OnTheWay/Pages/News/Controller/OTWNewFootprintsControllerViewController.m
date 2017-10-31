
//
//  OTWNewFootprintsControllerViewController.m
//  OnTheWay
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewFootprintsControllerViewController.h"

#import "OTWNewFootprintsTableViewCell.h"

#import "OTWCustomNavigationBar.h"

#import "OTWFootprintListModel.h"

@interface OTWNewFootprintsControllerViewController ()<UITableViewDataSource,UITableViewDelegate>{
        UITableView *_tableView;
       NSMutableArray *_status;
    NSInteger _page;
}
@property (nonatomic,strong) UIView *noResultView;
@property (nonatomic,strong) UIImageView *noResultImage;
@property (nonatomic,strong) UILabel *noResultLabelOne;
@property (nonatomic,strong) UILabel *noResultLabelTwo;

@end

@implementation OTWNewFootprintsControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 0;
    _status = @[].mutableCopy;
    [self buildUI];
//    [self initData];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initData
{
    _status = [[NSMutableArray alloc] init];
    NSDictionary *dic=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"他家菜的味道不错，量也很大就是有点小贵，下次考虑还来",@"footprintPhotoArray":@[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg"],@"dateCreatedStr":@"13:09",@"footprintAddress":@"北大街连回路33号"};
    NSDictionary *dic2=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"他家菜的味道不错，量也很大就是有点小贵，下次考虑还来",@"footprintPhotoArray":@[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg"],@"dateCreatedStr":@"13:09",@"footprintAddress":@"北大街连回路33号"};
    NSDictionary *dic3=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"围绕着我的卑微 也许能消退 其实我并不在意 有很多机会像巨人一样的无畏放纵我心里的鬼",@"footprintPhotoArray":@[],@"dateCreatedStr":@"13:09",@"footprintAddress":@"北大街连回路33号"};
    NSDictionary *dic4=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"围绕着我的卑微 也",@"footprintPhotoArray":@[],@"dateCreatedStr":@"13:09",@"footprintAddress":@"北大街连回路33号"};
    OTWFootprintListModel *model = [OTWFootprintListModel statusWithDictionary:dic];
    OTWFootprintListModel *model2= [OTWFootprintListModel statusWithDictionary:dic2];
    OTWFootprintListModel *model3= [OTWFootprintListModel statusWithDictionary:dic3];
    OTWFootprintListModel *model4= [OTWFootprintListModel statusWithDictionary:dic4];
    [_status addObject:model];
    [_status addObject:model2];
    [_status addObject:model3];
    [_status addObject:model4];
    //获取用户数据
}
-(void)buildUI {
    //设置标题
    self.title = @"新的足迹动态";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT - 65) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self loadData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self loadData];
    }];
    
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
    OTWFootprintListModel * model = _status[indexPath.row];
    OTWFootprintDetailController *VC =  [[OTWFootprintDetailController alloc] init];
    [VC setFid:[NSString stringWithFormat:@"%@",model.footprintId]];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"OTWNewFootprintsTableViewCellCellIdentifierK";
    OTWNewFootprintsTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWNewFootprintsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
    }
    if (_status.count > 0) {
        [cell setData:_status[indexPath.row]];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OTWNewFootprintsTableViewCell *cell = (OTWNewFootprintsTableViewCell *)[self tableView:tableView
                                                       cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (void)loadData
{
    NSString * url = @"/app/attention/footprint";
    NSDictionary * dic = @{@"number":@(_page),
                               @"size":@(15)};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       [OTWNetworkManager doGET:url parameters:dic responseCache:^(id responseCache) {
           if([[NSString stringWithFormat:@"%@",responseCache[@"code"]] isEqualToString:@"0"]){
               NSArray * arr = [[responseCache objectForKey:@"body"] objectForKey:@"content"];
               if (_page == 0) {
                   [_status removeAllObjects];
                   for (NSDictionary * result in arr) {
                       OTWFootprintListModel *model = [OTWFootprintListModel mj_objectWithKeyValues:result];
                       [_status addObject: model];
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [_tableView reloadData];
                       [_tableView.mj_header endRefreshing];
                       [_tableView.mj_footer endRefreshing];
                   });
               }
           }
       } success:^(id responseObject) {
           if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
               if (_page == 0) {
                   [_status removeAllObjects];
               }
               NSArray * arr = [[responseObject objectForKey:@"body"] objectForKey:@"content"];
               for (NSDictionary * result in arr) {
                   OTWFootprintListModel *model = [OTWFootprintListModel mj_objectWithKeyValues:result];
                   [_status addObject: model];
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                   if (arr.count == 0 && _page == 0) {
                       [self.view addSubview:self.noResultView];
                   }
                   if (_page == 0 && arr.count == 0) {
//                       [self.view addSubview:self.noResultView];
                   }
                   if (arr.count == 0 || arr.count < 15) {
                       [_tableView.mj_footer endRefreshingWithNoMoreData];
                   }else{
                       [_tableView.mj_footer endRefreshing];
                   }
                   [_tableView reloadData];
                   [_tableView.mj_header endRefreshing];
               });
           }
       } failure:^(NSError *error) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [OTWUtils alertFailed:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO target:self];
               [_tableView.mj_header endRefreshing];
               [_tableView.mj_footer endRefreshing];
           });
       }];
    });
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
        _noResultImage.image=[UIImage imageNamed:@"qx_wuzujidongtai"];
    }
    return _noResultImage;
}

-(UILabel*)noResultLabelOne{
    if(!_noResultLabelOne){
        _noResultLabelOne=[[UILabel alloc]init];
        _noResultLabelOne.text = @"您还有任何足迹动态哦";
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
        _noResultLabelTwo.text = @"那就去关注更多小伙伴吧";
        _noResultLabelTwo.font=[UIFont systemFontOfSize:13];
        _noResultLabelTwo.textColor=[UIColor color_979797];
        [_noResultLabelTwo sizeToFit];
        _noResultLabelTwo.frame=CGRectMake(0, self.noResultLabelOne.MaxY+10, SCREEN_WIDTH, _noResultLabelTwo.Height);
        _noResultLabelTwo.textAlignment=NSTextAlignmentCenter;
    }
    return _noResultLabelTwo;
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
