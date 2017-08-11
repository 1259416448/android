//
//  OTWSearchShopListViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/10.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWSearchShopListViewController.h"

#import "OTWSearchShopListViewCell.h"

#import "OTWCustomNavigationBar.h"

#import "CHCustomSearchBar.h"

@interface OTWSearchShopListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
}
@property (nonatomic,strong) CHCustomSearchBar *footprintSearchAddress;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView *noResultView;
@property (nonatomic,strong) UIImageView *noResultImage;
@property (nonatomic,strong) UILabel *noResultLabelOne;
@property (nonatomic,strong) UILabel *noResultLabelTwo;
@property (nonatomic,strong) UIButton *addClaimShopBtn;
@end

@implementation OTWSearchShopListViewController

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
    [self.customNavigationBar addSubview:self.footprintSearchAddress];
    self.customNavigationBar.backgroundColor=[UIColor whiteColor];
    
    [self.customNavigationBar addSubview:self.cancelBtn];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65-20) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    //有搜索结果
    //[self.view addSubview:_tableView];
    
    //无搜索结果
    [self.view addSubview:self.noResultView];
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
}
#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"OTWSearchShopListViewCellIdentifierKey";
    OTWSearchShopListViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWSearchShopListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    
    OTWSearchShopListViewCell *cell = (OTWSearchShopListViewCell *)[self tableView:tableView
                                                       cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(CHCustomSearchBar*)footprintSearchAddress{
    if(!_footprintSearchAddress){
        _footprintSearchAddress=[[CHCustomSearchBar alloc] initWithFrame:CGRectMake(15, 25.5, SCREEN_WIDTH-45-35, 34)];
        [_footprintSearchAddress setPlaceholder:@"搜索附近的美食、商城"];
        [_footprintSearchAddress setContentMode:UIViewContentModeCenter];
        _footprintSearchAddress.layer.cornerRadius = 20;
        _footprintSearchAddress.layer.masksToBounds = YES;
        
        //自定义搜索框的大小
        _footprintSearchAddress.textFieldInset=UIEdgeInsetsMake(0,0,0,0);
        
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
        searchField.layer.cornerRadius = 30;
        searchField.layer.masksToBounds = YES;
        searchField.layer.borderColor = [UIColor clearColor].CGColor;
        searchField.backgroundColor=[[UIColor color_f4f4f4]colorWithAlphaComponent:0.9f];
        searchField.layer.borderWidth = 0.5;
        _footprintSearchAddress.delegate = self;

        UIButton * clearSearchBar = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        clearSearchBar.frame =CGRectMake(_footprintSearchAddress.Witdh-15-15, 19/2, 15, 15);
        clearSearchBar.layer.cornerRadius = clearSearchBar.frame.size.width /2;
        clearSearchBar.clipsToBounds = YES;
        [clearSearchBar setBackgroundImage:[UIImage imageNamed:@"fx_guanbi"] forState:(UIControlStateNormal)];
       [clearSearchBar addTarget:self action:@selector(clearSearchBarClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_footprintSearchAddress addSubview:clearSearchBar];
    }
    return _footprintSearchAddress;
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
        
        _cancelBtn.frame =CGRectMake(self.footprintSearchAddress.Witdh+30, 25.5+6, 35, 22.5);

        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(void)cancelBtnClick{
    DLog(@"点击了取消");
}

-(UIView*)noResultView{
    if(!_noResultView){
        _noResultView=[[UIView alloc] initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65-20)];
        _noResultView.backgroundColor=[UIColor whiteColor];
        [_noResultView addSubview:self.noResultImage];
        [_noResultView addSubview:self.noResultLabelOne];
        [_noResultView addSubview:self.noResultLabelTwo];
        [_noResultView addSubview:self.addClaimShopBtn];
    }
    return _noResultView;
}
-(UIImageView*)noResultImage{
    if(!_noResultImage){
        _noResultImage=[[UIImageView alloc]init];
        _noResultImage.frame=CGRectMake((SCREEN_WIDTH-151)/2, 130, 151, 109);
        _noResultImage.image=[UIImage imageNamed:@"qs_wusousuo"];
    }
    return _noResultImage;
}

-(UILabel*)noResultLabelOne{
    if(!_noResultLabelOne){
        _noResultLabelOne=[[UILabel alloc]init];
        _noResultLabelOne.text=@"小主，您搜索的词太高端了";
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
        _noResultLabelTwo.text=@"我们都没有搜索到呢~";
        _noResultLabelTwo.font=[UIFont systemFontOfSize:13];
        _noResultLabelTwo.textColor=[UIColor color_979797];
        [_noResultLabelTwo sizeToFit];
        _noResultLabelTwo.frame=CGRectMake(0, self.noResultLabelOne.MaxY+10, SCREEN_WIDTH, _noResultLabelTwo.Height);
        _noResultLabelTwo.textAlignment=NSTextAlignmentCenter;
    }
    return _noResultLabelTwo;
}
-(UIButton*)addClaimShopBtn{
    if(!_addClaimShopBtn){
        _addClaimShopBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_addClaimShopBtn setTitle: @"添加商家并认领" forState: UIControlStateNormal];
        _addClaimShopBtn.titleLabel.font=[UIFont systemFontOfSize:17];
        _addClaimShopBtn.backgroundColor=[UIColor color_e50834];
        _addClaimShopBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_addClaimShopBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        
        _addClaimShopBtn.frame =CGRectMake((SCREEN_WIDTH-200)/2,self.noResultLabelTwo.MaxY+50,200,44);
        
        [_addClaimShopBtn addTarget:self action:@selector(addClaimShopBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addClaimShopBtn.layer.cornerRadius = 3;
        _addClaimShopBtn.layer.masksToBounds = YES;
    }
    return _addClaimShopBtn;
}
-(void)addClaimShopBtnClick{
    DLog(@"点击了添加商家并认领");
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
