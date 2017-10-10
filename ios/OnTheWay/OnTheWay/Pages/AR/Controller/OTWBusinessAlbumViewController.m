//
//  OTWBusinessAlbumViewController.m
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/9/30.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessAlbumViewController.h"

@interface OTWBusinessAlbumViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIView *sortView;
@property (nonatomic,strong) UIView *slipLine;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UICollectionView *leftCollectionView;
@property (nonatomic,strong) UICollectionView *rightCollectionView;


@end

@implementation OTWBusinessAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self buildUi];
}
- (void)buildUi
{
    self.title = @"商家详情";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor = [UIColor color_f4f4f4];
    
    [self.sortView addSubview:self.leftBtn];
    [self.sortView addSubview:self.rightBtn];
    [self.sortView addSubview:self.slipLine];
    [self.view addSubview:self.sortView];
    [self.backScrollView addSubview:self.leftCollectionView];
    [self.backScrollView addSubview:self.rightCollectionView];
    [self.view addSubview:self.backScrollView];
    
    
}
- (void)click:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"官方相册"])
    {
        _leftBtn.selected = YES;
        _rightBtn.selected = NO;
        [UIView beginAnimations:nil context:nil];
        _slipLine.frame = CGRectMake(0, 43, SCREEN_WIDTH / 2, 2.f);
        [_backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView commitAnimations];
    }
    else
    {
        
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
        [UIView beginAnimations:nil context:nil];
        [_backScrollView setContentOffset:CGPointMake(SCREEN_WIDTH , 0) animated:YES];
        _slipLine.frame = CGRectMake(SCREEN_WIDTH / 2, 43,SCREEN_WIDTH / 2, 2.f);
        [UIView commitAnimations];
    }
}
#pragma mark collectionviewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _leftCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell"forIndexPath:indexPath];
        cell.backgroundColor = [UIColor grayColor];
        return cell;
    }else if (collectionView == _rightCollectionView)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightUICollectionViewCell"forIndexPath:indexPath];
        cell.backgroundColor = [UIColor redColor];
        return cell;
        
    }else{
        return nil;
    }

}

#pragma mark UICollectionViewDelegateFlowLayout
//设置每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = CGSizeMake((SCREEN_WIDTH - 40) / 2, (SCREEN_WIDTH - 40) / 2 * 52 / 67);
    
    return size;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

//每个cell是否能点击
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UIView*)sortView
{
    if(!_sortView){
        _sortView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 44)];
        _sortView.backgroundColor = [UIColor whiteColor];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 1) / 2, 12, 1, 20)];
        line.backgroundColor = [UIColor color_d5d5d5];
        [_sortView addSubview:line];
        UIView * downLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        downLine.backgroundColor = [UIColor color_d5d5d5];
        [_sortView addSubview:downLine];
    }
    return _sortView;
}
- (UIView *)slipLine
{
    if (!_slipLine) {
        _slipLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH / 2, 1)];
        _slipLine.backgroundColor = [UIColor color_e50834];
    }
    return _slipLine;
}
- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 1) / 2, 43)];
        [_leftBtn setTitle:@"官方相册" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor color_e50834] forState:UIControlStateSelected];
        [_leftBtn setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
        _leftBtn.selected = YES;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_leftBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 1) / 2 + 1, 0, (SCREEN_WIDTH - 1) / 2, 43)];
        [_rightBtn setTitle:@"网友相册" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor color_e50834] forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (UIScrollView *)backScrollView
{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 109, SCREEN_WIDTH * 2, SCREEN_HEIGHT - 109)];
        _backScrollView.backgroundColor = [UIColor clearColor];
        _backScrollView.pagingEnabled = YES;
        _backScrollView.showsVerticalScrollIndicator = NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.delegate = self;
        _backScrollView.scrollEnabled = NO;
    }
    return _backScrollView;
}
- (UICollectionView *)leftCollectionView
{
    if (!_leftCollectionView) {
        UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _leftCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 119) collectionViewLayout:layout];
        [_leftCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        _leftCollectionView.delegate=self;
        _leftCollectionView.dataSource=self;
        _leftCollectionView.backgroundColor = [UIColor clearColor];
        _leftCollectionView.showsHorizontalScrollIndicator = NO;
        _leftCollectionView.showsVerticalScrollIndicator = NO;
        _leftCollectionView.bounces = NO;
    }
    return _leftCollectionView;
}

- (UICollectionView *)rightCollectionView
{
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _rightCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(15 + SCREEN_WIDTH, 10, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 119) collectionViewLayout:layout];
        [_rightCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"RightUICollectionViewCell"];

        _rightCollectionView.delegate=self;
        _rightCollectionView.dataSource=self;
        _rightCollectionView.backgroundColor = [UIColor clearColor];
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.bounces = NO;
    }
    return _rightCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
