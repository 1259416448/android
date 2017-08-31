//
//  OTWPersonalChooseBankViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalChooseBankViewController.h"
#import "CHCustomSearchBar.h"
#import "OTWPersonalChooseBankViewCell.h"

@interface OTWPersonalChooseBankViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView;
    NSArray *sectionTitles; // 每个分区的标题

}
@property (nonatomic,strong) CHCustomSearchBar *uiSearchBar;
@property (nonatomic,strong) UIView *tableViewTableViewHeader;
@property(nonatomic,assign) UIEdgeInsets textFieldInset;

@end

@implementation OTWPersonalChooseBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self buildUI];
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI{
    //设置标题
    self.title = @"选择开户行";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    //搜索框
    [self.view addSubview: self.tableViewTableViewHeader ];
    [self.tableViewTableViewHeader addSubview:self.uiSearchBar];
    
    //创建一个分组样式的UITableView
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.tableViewTableViewHeader.MaxY-0.5, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationHeight) style:UITableViewStylePlain];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    tableView.tag=10000;
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexColor = [UIColor color_979797];
    [self.view addSubview:tableView];


}
-(void)setData{
    sectionTitles       = [[NSArray alloc] initWithObjects:
                           @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",
                           @"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",
                           @"X",@"Y",@"Z"];
}

-(UIView*)tableViewTableViewHeader{
    if(!_tableViewTableViewHeader){
        _tableViewTableViewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, 51)];
        _tableViewTableViewHeader.backgroundColor=[UIColor clearColor];
        _tableViewTableViewHeader.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        _tableViewTableViewHeader.layer.borderWidth=0.5;
    }
    return _tableViewTableViewHeader;
}
-(CHCustomSearchBar*)uiSearchBar{
    if(!_uiSearchBar){
        _uiSearchBar=[[CHCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 50)];
        [_uiSearchBar setPlaceholder:@"搜索"];
        [_uiSearchBar setContentMode:UIViewContentModeCenter];
        
        //自定义搜索框的大小
        _uiSearchBar.textFieldInset=UIEdgeInsetsMake(9, 15, 9, 15);
        
        //替换搜索图标
        //        [_footprintSearchAddress setImage:[UIImage imageNamed:@"sousuo_1"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        //这个枚举可以对searchBar进行修改
        _uiSearchBar.searchBarStyle = UISearchBarStyleProminent;
        
        
        UITextField *searchField = nil;
        for (UIView *subview in  _uiSearchBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIView")]&&subview.subviews.count>0) {
                subview.backgroundColor = [UIColor color_ededed];
                [[subview.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        //的到搜索框 并设置他的属性
        searchField = [[[_uiSearchBar.subviews firstObject] subviews] lastObject];
        searchField.layer.cornerRadius = 3;
        searchField.layer.masksToBounds = YES;
        searchField.layer.borderColor = [UIColor clearColor].CGColor;
        searchField.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.9f];
        [searchField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        searchField.layer.borderWidth = 0.5;
        //设置图标
        UIImage *image = [UIImage imageNamed: @"sousuo_1"];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        iView.frame = CGRectMake(0, 0, 15 , 15);
        UIView *myview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15 , 15)];
        [myview addSubview: iView];
        searchField.leftView = myview;
        
        _uiSearchBar.delegate = self;
    }
    return _uiSearchBar;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionTitles.count;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  3;
    
}
#pragma mark 组高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DLog(@"我点击了：%ld",indexPath.row);
    
}
//section底部视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
//    view.backgroundColor = [UIColor clearColor];
//    UILabel *sectionHeaderLeft=[[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 1,5)];
//    sectionHeaderLeft.backgroundColor=[UIColor color_d5d5d5];
//    [view addSubview:sectionHeaderLeft];
//    return view;
//}
#pragma mark - 自定义分组头
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * sectionHeader=[[UIView alloc] init];
    sectionHeader.backgroundColor=[UIColor color_f4f4f4];
    
    UILabel *month=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 34)];
    month.text=sectionTitles[section];
    month.textColor=[UIColor color_979797];
    month.font=[UIFont systemFontOfSize:12];
    [sectionHeader addSubview:month];
    
    return sectionHeader;
    
    
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"OTWPersonalHistroyPayeeViewCellCellIdentifierK";
    OTWPersonalChooseBankViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWPersonalChooseBankViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
    }
    return cell;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionTitles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return index;
}
@end
