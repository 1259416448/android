//
//  OTWFootprintsChangeAddressController.m
//  OnTheWay
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintsChangeAddressController.h"
#import "OTWFootprintsChangeAddressModel.h"
#import "OTWFootprintsChangeAddressCellTableViewCell.h"
#import "CHCustomSearchBar.h"

@interface OTWFootprintsChangeAddressController()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray<OTWFootprintsChangeAddressModel*> *status;
}
@property (nonatomic,strong) UITableView *footprintTableView;
@property (nonatomic,strong) CHCustomSearchBar *footprintSearchAddress;
@property (nonatomic,strong) UIView *footprintTableViewTableViewHeader;
@property(nonatomic,assign) UIEdgeInsets textFieldInset;

@end

@implementation OTWFootprintsChangeAddressController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化数据
    [self initData];
    
    [self buildUI];
    
}
-(void)initData{
    
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"OTWFindprintChangeAddress.plist" ofType:nil];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fullPath];
    status = [[NSMutableArray alloc] init];
    if(array && array.count>0){
        for (NSDictionary *dict in array) {
            [status addObject:[OTWFootprintsChangeAddressModel initWithDict:dict]];
        }
    }
//     DLog(@"array:%@",array)
//      DLog(@"status:%@",status);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI
{
    //设置标题
    self.title = @"所在地址";
    [self setLeftNavigationTitle:@"取消"];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    
    [self.view addSubview:self.footprintTableView];
    
    //搜索框
    [self.footprintTableViewTableViewHeader addSubview:self.footprintSearchAddress];

}

-(UITableView *)footprintTableView{
    if(!_footprintTableView){
        _footprintTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationHeight-49) style:UITableViewStyleGrouped];
        _footprintTableView.dataSource = self;
        
        _footprintTableView.delegate = self;
        
        _footprintTableView.backgroundColor = [UIColor clearColor];
        
        _footprintTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
        //设置tableview的第一行显示内容
        _footprintTableView.tableHeaderView=self.footprintTableViewTableViewHeader;
    }
    return _footprintTableView;
}

-(UIView*)footprintTableViewTableViewHeader{
    if(!_footprintTableViewTableViewHeader){
        _footprintTableViewTableViewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 51)];
        _footprintTableViewTableViewHeader.backgroundColor=[UIColor clearColor];
        _footprintTableViewTableViewHeader.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        _footprintTableViewTableViewHeader.layer.borderWidth=0.5;
        
    }
    return _footprintTableViewTableViewHeader;
}

-(CHCustomSearchBar*)footprintSearchAddress{
    if(!_footprintSearchAddress){
        _footprintSearchAddress=[[CHCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 50)];
        [_footprintSearchAddress setPlaceholder:@"搜索附近位置"];
        [_footprintSearchAddress setContentMode:UIViewContentModeCenter];
        
       //自定义搜索框的大小
        _footprintSearchAddress.textFieldInset=UIEdgeInsetsMake(7.5, 15, 7.5, 15);
        
        //替换搜索图标
        [_footprintSearchAddress setImage:[UIImage imageNamed:@"sousuo_1"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        //这个枚举可以对searchBar进行修改
        _footprintSearchAddress.searchBarStyle = UISearchBarStyleProminent;
        
  
        UITextField *searchField = nil;
        for (UIView *subview in  _footprintSearchAddress.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIView")]&&subview.subviews.count>0) {
                subview.backgroundColor = [UIColor color_f4f4f4];
                [[subview.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        //的到搜索框 并设置他的属性
        searchField = [[[_footprintSearchAddress.subviews firstObject] subviews] lastObject];
        searchField.layer.cornerRadius = 3;
        searchField.layer.masksToBounds = YES;
        searchField.layer.borderColor = [UIColor color_d5d5d5].CGColor;
        searchField.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.9f];
        searchField.layer.borderWidth = 0.5;
    }
    return _footprintSearchAddress;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     DLog(@"我点击了：%ld",indexPath.row);
    for(int j=0;j<status.count;j++){
        for(int i=0;i<status[j].addressArray.count;i++){
            if(indexPath.row==i){
                 status[j].addressArray[i].isClick=YES;
            }else{
                status[j].addressArray[i].isClick=NO;
            }
        }
    }
    [tableView reloadData];
}

#pragma mark 返回每组行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return status.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return status[section].addressArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"findViewCellI";
    OTWFootprintsChangeAddressCellTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        
        cell=[[OTWFootprintsChangeAddressCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData:status[indexPath.section].addressArray[indexPath.row]];
    return cell;
}
#pragma mark - 代理方法
#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * sectionHeader=[[UIView alloc] init];
    sectionHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH,50);
    sectionHeader .backgroundColor=[UIColor whiteColor];

    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 30)];
    name.text=status[section].city;
    name.textColor=[UIColor color_202020];
    name.font=[UIFont systemFontOfSize:16];
    
    [sectionHeader addSubview:name];
    return sectionHeader;
}

@end
