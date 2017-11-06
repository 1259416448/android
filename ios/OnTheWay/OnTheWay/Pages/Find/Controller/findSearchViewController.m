//
//  findSearchViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "findSearchViewController.h"

#import "OTWCustomNavigationBar.h"

#import "CHCustomSearchBar.h"

#import "findSearchViewCell.h"

#import "OTWSearchShopListViewController.h"

@interface findSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
    UITableView *_tableView;
}

@property (nonatomic,strong) CHCustomSearchBar *searchBar;
@property (nonatomic,strong) UIButton *cancelBtn;

@end

@implementation findSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI{
    //设置标题 搜索--商家详情
    //[self.customNavigationBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.customNavigationBar.frame=CGRectMake(0, 0, SCREEN_WIDTH, 65);
    [self.customNavigationBar addSubview:self.searchBar];
    self.customNavigationBar.backgroundColor=[UIColor whiteColor];
    
    [self.customNavigationBar addSubview:self.cancelBtn];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];

    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65-20) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
//    [self.view addSubview:_tableView];

}
#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}
#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
    OTWSearchShopListViewController *findSearchListVC = [[OTWSearchShopListViewController alloc] init];
    [self.navigationController pushViewController:findSearchListVC animated:YES];
}
#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier=@"findSearchViewCellIdentifierKey";
    findSearchViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[findSearchViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
    }
    
    return cell;
}

#pragma mark - 代理方法
#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}
-(CHCustomSearchBar*)searchBar{
    if(!_searchBar){
        _searchBar=[[CHCustomSearchBar alloc] initWithFrame:CGRectMake(15, 25.5, SCREEN_WIDTH-45-35, 34)];
        [_searchBar setPlaceholder:@"搜索附近的美食、商城"];
        [_searchBar setContentMode:UIViewContentModeCenter];
        _searchBar.layer.cornerRadius = 20;
        _searchBar.layer.masksToBounds = YES;
        
        //自定义搜索框的大小
        _searchBar.textFieldInset=UIEdgeInsetsMake(0,0,0,0);
        
        //替换搜索图标
//        [_searchBar setImage:[UIImage imageNamed:@"sousuo_1"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
      
        
        //这个枚举可以对searchBar进行修改
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
        
        
        UITextField *searchField = nil;
        for (UIView *subview in  _searchBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIView")]&&subview.subviews.count>0) {
                subview.backgroundColor = [UIColor color_f4f4f4];
                [[subview.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        //的到搜索框 并设置他的属性
        searchField = [[[_searchBar.subviews firstObject] subviews] lastObject];
        searchField.layer.cornerRadius = 30;
        searchField.layer.masksToBounds = YES;
        searchField.layer.borderColor = [UIColor clearColor].CGColor;
        searchField.backgroundColor=[[UIColor color_f4f4f4]colorWithAlphaComponent:0.9f];
        searchField.layer.borderWidth = 0.5;
        //设置图标
        UIImage *image = [UIImage imageNamed: @"sousuo_1"];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        iView.frame = CGRectMake(0, 0, 15 , 15);
        UIView *myview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15 , 15)];
        [myview addSubview: iView];
        searchField.leftView = myview;
        _searchBar.delegate = self;
        
        UIButton * clearSearchBar = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        clearSearchBar.frame =CGRectMake(_searchBar.Witdh-15-15, 19/2, 15, 15);
        clearSearchBar.layer.cornerRadius = clearSearchBar.frame.size.width /2;
        clearSearchBar.clipsToBounds = YES;
        [clearSearchBar setBackgroundImage:[UIImage imageNamed:@"fx_guanbi"] forState:(UIControlStateNormal)];
        [clearSearchBar addTarget:self action:@selector(clearSearchBarClick) forControlEvents:UIControlEventTouchUpInside];
          clearSearchBar.showsTouchWhenHighlighted = NO;
//        [_searchBar addSubview:clearSearchBar];
    }
    return _searchBar;
}

-(void)clearSearchBarClick{
    DLog(@"点击了清除");
  }

-(UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_cancelBtn setTitle: @"取消" forState: UIControlStateNormal];
        _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cancelBtn setTitleColor:[UIColor color_202020]forState:UIControlStateNormal];
        
        _cancelBtn.frame =CGRectMake(self.searchBar.Witdh+30, 25.5+6, 35, 22.5);
        
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.showsTouchWhenHighlighted = NO;

    }
    return _cancelBtn;
}
-(void)cancelBtnClick{
    DLog(@"点击了取消");
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"点击了搜索");
    return YES;
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
