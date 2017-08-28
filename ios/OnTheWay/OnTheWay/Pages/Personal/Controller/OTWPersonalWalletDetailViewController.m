//
//  OTWPersonalWalletDetailViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/22.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalWalletDetailViewController.h"
#import "OTWPersonalWalletDetailViewCell.h"

@interface OTWPersonalWalletDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UITableView *tableView;
}
@property (nonatomic,strong) UIView *topLine;
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIScrollView *topScrollView;
@property (nonatomic,strong) UIButton *chooseCalendBtn;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIButton *allBtn;
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UIView *buttonView;
@property (nonatomic,strong) UIButton *incomeBtn;
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong,nonatomic) UITableView *topTableView;

@end

@implementation OTWPersonalWalletDetailViewController

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
    //设置标题
    self.title = @"钱包明细";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //头部第一条线
    [self.view addSubview:self.topLine];
    
    //头部第二条线
    [self.view addSubview: self.bottomLine];
    
    //头部删选
    [self.view addSubview:self.topView];
    //buttomview
    [self.view addSubview:self.buttonView];
    //全部按钮
    [self.buttonView addSubview:self.allBtn];
    //支出按钮
    [self.buttonView addSubview:self.payBtn];
    //收入按钮
    [self.buttonView addSubview:self.incomeBtn];
    //日历选择按钮
    [self.view addSubview:self.chooseCalendBtn];
    
    //关闭日历选择
    [self.view addSubview:self.closeBtn];
   
    //日历选择view
    //[self.view addSubview:self.topScrollView];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing=0;
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, self.navigationHeight+0.5, SCREEN_WIDTH-50, 43) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.collectionView.hidden=YES;
    [self.view addSubview:self.collectionView];
    

    
    //创建一个分组样式的UITableView
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.bottomLine.MaxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.bottomLine.MaxY) style:UITableViewStyleGrouped];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    tableView.tag=10000;
    
    tableView.backgroundColor = [UIColor clearColor];
   
    [self.view addSubview:tableView];
    
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 13;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    if(indexPath.row%13==0){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 43)];
        label.textColor = [UIColor color_e50834];
        label.font=[UIFont systemFontOfSize:14];
        label.textAlignment=NSTextAlignmentCenter;
        label.text = @"2028年";
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        [cell.contentView addSubview:label];
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 43)];
        label.textColor = [UIColor color_202020];
        label.font=[UIFont systemFontOfSize:14];
        label.textAlignment=NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        [cell.contentView addSubview:label];
  
        UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
        selectedBGView.backgroundColor = [UIColor color_e50834];
        cell.selectedBackgroundView = selectedBGView;
    }
    
    
   
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%13==0){
        return CGSizeMake(60, 43);

    }else{
        return CGSizeMake(44, 43);

    }
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section:%ld row:%ld",indexPath.section,indexPath.row);
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor color_e50834];
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%13==0){
        return NO;
    }else{
        return YES;
    }
   }

-(UIView*)topLine{
    if(!_topLine){
        _topLine=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, 0.5)];
        _topLine.backgroundColor=[UIColor color_d5d5d5];
    }
    return _topLine;
}

-(UIView*)bottomLine{
    if(!_bottomLine){
        _bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight+43.5, SCREEN_WIDTH, 0.5)];
        _bottomLine.backgroundColor=[UIColor color_d5d5d5];
    }
    return _bottomLine;
}

-(UIView*)topView{
    if(!_topView){
        _topView=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight+0.5, SCREEN_WIDTH-50, 43)];
        _topView.backgroundColor=[UIColor whiteColor];
    
    }
    return _topView;
}
-(UIScrollView*)topScrollView{
    if(!_topScrollView){
        _topScrollView=[[UIScrollView alloc]init];
        
        _topScrollView.frame=CGRectMake(0, self.navigationHeight+0.5, SCREEN_WIDTH-50, 43);
        _topScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 43);
    }
    return _topScrollView;
}

-(UIView*)buttonView{
    if(!_buttonView){
        _buttonView=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight+0.5, SCREEN_WIDTH-50, 43)];
    }
    return _buttonView;
}
-(UIButton*)allBtn{
    if(!_allBtn){
        _allBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, 58, 42)];
        [_allBtn setTitleColor:[UIColor color_e50834] forState:UIControlStateNormal];
        _allBtn.backgroundColor=[UIColor whiteColor];
        _allBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
        _allBtn.adjustsImageWhenHighlighted = NO;
        [_allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *leftLine=[[UIView alloc]initWithFrame:CGRectMake(_allBtn.MaxX, 17, 1, 10)]
        ;
        leftLine.backgroundColor=[UIColor color_d5d5d5];
        [_allBtn addSubview:leftLine];
    }
    return  _allBtn;
}
-(UIButton*)payBtn{
    if(!_payBtn){
        //支出
        _payBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.allBtn.MaxX+1, 0.5, 58, 42)];
        [_payBtn setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
        _payBtn.backgroundColor=[UIColor whiteColor];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_payBtn setTitle:@"支出" forState:UIControlStateNormal];
        _payBtn.adjustsImageWhenHighlighted = NO;
        [_payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *payBtnLeftLine=[[UIView alloc]initWithFrame:CGRectMake(_payBtn.Witdh, 17, 1, 10)]
        ;
        payBtnLeftLine.backgroundColor=[UIColor color_d5d5d5];
        [_payBtn addSubview:payBtnLeftLine];
    }
    return _payBtn;
}
-(UIButton*)incomeBtn{
    if(!_incomeBtn){
        //收入
        _incomeBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.payBtn.MaxX+1, 0.5, 58, 42)];
        [_incomeBtn setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
        _incomeBtn.backgroundColor=[UIColor whiteColor];
        _incomeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_incomeBtn setTitle:@"收入" forState:UIControlStateNormal];
        _incomeBtn.adjustsImageWhenHighlighted = NO;
        [_incomeBtn addTarget:self action:@selector(incomeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _incomeBtn;
}
-(UIButton*)chooseCalendBtn{
    if(!_chooseCalendBtn){
        _chooseCalendBtn=[[UIButton alloc]init];
        [_chooseCalendBtn setTitleColor:[UIColor color_e50834] forState:UIControlStateNormal];
        _chooseCalendBtn.backgroundColor=[UIColor whiteColor];
        [_chooseCalendBtn setImage:[UIImage imageNamed:@"wd_riqi"] forState:(UIControlStateNormal)];
        _chooseCalendBtn.adjustsImageWhenHighlighted = NO;
        [_chooseCalendBtn addTarget:self action:@selector(chooseCalendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *rightLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0.5, 0.5, 43)]
        ;
        rightLine.backgroundColor=[UIColor color_d5d5d5];
        [_chooseCalendBtn addSubview:rightLine];
        _chooseCalendBtn.frame=CGRectMake(SCREEN_WIDTH-50, self.navigationHeight+0.5, 50, 43);
    }

    return _chooseCalendBtn;
}
-(UIButton*)closeBtn{
    if(!_closeBtn){
        _closeBtn=[[UIButton alloc]init];
        [_closeBtn setTitleColor:[UIColor color_e50834] forState:UIControlStateNormal];
        _closeBtn.backgroundColor=[UIColor whiteColor];
        [_closeBtn setImage:[UIImage imageNamed:@"wd_yincang"] forState:(UIControlStateNormal)];
        _closeBtn.adjustsImageWhenHighlighted = NO;
        [_closeBtn addTarget:self action:@selector(closeBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *rightLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0.5, 0.5, 43)]
        ;
        rightLine.backgroundColor=[UIColor color_d5d5d5];
        [_closeBtn addSubview:rightLine];
        _closeBtn.frame=CGRectMake(SCREEN_WIDTH-50, self.navigationHeight+0.5, 50, 43);
        _closeBtn.hidden=YES;
    }
    return _closeBtn;
}
-(void)allBtnClick{
    DLog(@"点击了全部");
}
-(void)payBtnClick{
    DLog(@"点击了支出");
}
-(void)incomeBtnClick{
    DLog(@"点击了收入");
}
-(void)chooseCalendBtnClick{
    DLog(@"点击了日历");
    self.buttonView.hidden=YES;
    self.collectionView.hidden=NO;
    self.chooseCalendBtn.hidden=YES;
    self.closeBtn.hidden=NO;
}
-(void)closeBtnBtnClick{
    DLog(@"点击了关闭");
    self.buttonView.hidden=NO;
    self.collectionView.hidden=YES;
    self.chooseCalendBtn.hidden=NO;
    self.closeBtn.hidden=YES;
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
    return 2;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  3;

}
#pragma mark 组高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
        
        UILabel *month=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 40)];
        month.text=@"7月";
        month.textColor=[UIColor color_979797];
        month.font=[UIFont systemFontOfSize:12];
        [sectionHeader addSubview:month];
        
        return sectionHeader;
  
   
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *cellIdentifier=@"OTWPersonalWalletDetailViewCellCellIdentifierK";
        OTWPersonalWalletDetailViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell){
            cell=[[OTWPersonalWalletDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //在此模块，以便重新布局
        }
        return cell;

    
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
@end
