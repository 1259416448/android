//
//  OTWBusinessAlbumViewController.m
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/9/30.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessAlbumViewController.h"
#import "OTWBusinessAlbumModel.h"
#import "OTWAlbumCollectionViewCell.h"
#import "OTWBusinessAlbumParameter.h"
#import "SDPhotoBrowser.h"

@interface OTWBusinessAlbumViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>

@property (nonatomic,strong) UIView *sortView;
@property (nonatomic,strong) UIView *slipLine;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UICollectionView *leftCollectionView;
@property (nonatomic,strong) UICollectionView *rightCollectionView;
@property (nonatomic,strong) OTWBusinessAlbumParameter *Parameter;
@property (nonatomic,strong) NSMutableArray *userAlbumArr;
@property (nonatomic,strong) NSMutableArray *businessAlbumArr;
@property (nonatomic,strong) UIView *noResultView;
@property (nonatomic,strong) UIImageView *noResultImage;


@end

@implementation OTWBusinessAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userAlbumArr = @[].mutableCopy;
    _businessAlbumArr = @[].mutableCopy;
    [self buildUi];
    [self loadUserPhotos];
}
- (void)buildUi
{
    self.title = @"商家详情";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor = [UIColor color_f4f4f4];
    
    //商家相册暂不显示
    [self.sortView addSubview:self.leftBtn];
    [self.sortView addSubview:self.rightBtn];
    [self.sortView addSubview:self.slipLine];
    [self.view addSubview:self.sortView];
    [self.backScrollView addSubview:self.leftCollectionView];
    [self.backScrollView addSubview:self.noResultView];

    [self.backScrollView addSubview:self.rightCollectionView];
    [self.view addSubview:self.backScrollView];
//    [self.backScrollView setContentOffset:CGPointMake(SCREEN_WIDTH , 0) animated:YES];
    [self click:self.rightBtn];
    
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
    if (collectionView == _rightCollectionView) {
        return _userAlbumArr.count;
    }else{
        return _businessAlbumArr.count;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _leftCollectionView) {
        OTWAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell"forIndexPath:indexPath];
        return cell;
    }else if (collectionView == _rightCollectionView)
    {
        OTWAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightUICollectionViewCell"forIndexPath:indexPath];
        OTWBusinessAlbumModel * model = _userAlbumArr[indexPath.row];
        [cell.photo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.photoUrl,AlbumImageSize]]];
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
    if (collectionView == _rightCollectionView) {
        SDPhotoBrowser *photoBrowser = [[SDPhotoBrowser alloc] init];
        photoBrowser.delegate = self;
        photoBrowser.sourceImagesContainerView = collectionView;
        photoBrowser.isAnimate = NO;
        photoBrowser.currentImageIndex = (int)indexPath.row;
        photoBrowser.imageCount = _userAlbumArr.count;
        [photoBrowser show];
    }else{
    }
}

//每个cell是否能点击
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)loadUserPhotos
{
    NSString * url = [NSString stringWithFormat:@"%@%@",@"/app/business/user/photos/",_shopId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       [OTWNetworkManager doGET:url parameters:self.Parameter.mj_keyValues responseCache:^(id responseCache) {
           if([[NSString stringWithFormat:@"%@",responseCache[@"code"]] isEqualToString:@"0"]){
               NSArray * arr = [[responseCache objectForKey:@"body"] objectForKey:@"content"];
               if (_Parameter.number == 0) {
                   for (NSDictionary * result in arr) {
                       OTWBusinessAlbumModel * model = [OTWBusinessAlbumModel mj_objectWithKeyValues:result];
                       [_userAlbumArr addObject: model];
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [_rightCollectionView reloadData];
                       [_rightCollectionView.mj_header endRefreshing];
                       [_rightCollectionView.mj_footer endRefreshing];
                   });
               }
           }
       } success:^(id responseObject) {
           if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
               self.Parameter.currentTime = responseObject[@"body"][@"currentTime"];
               if (_Parameter.number == 0) {
                   [_userAlbumArr removeAllObjects];
               }
               NSArray * arr = [[responseObject objectForKey:@"body"] objectForKey:@"content"];
               for (NSDictionary * result in arr) {
                   OTWBusinessAlbumModel * model = [OTWBusinessAlbumModel mj_objectWithKeyValues:result];
                   [_userAlbumArr addObject: model];
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                   if (_Parameter.number == 0 && arr.count == 0) {
//                       [self.view addSubview:self.noResultView];
                   }
                   [_rightCollectionView reloadData];
                   if (arr.count == 0 || arr.count < self.Parameter.size) {
                       [_rightCollectionView.mj_footer endRefreshingWithNoMoreData];
                   }else{
                       [_rightCollectionView.mj_footer endRefreshing];
                   }
                   [_rightCollectionView.mj_header endRefreshing];
               });
           }
           
       } failure:^(NSError *error) {
           
       }];
    });
}
#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlString = @"";
    OTWBusinessAlbumModel * model = _userAlbumArr[index];
    urlString = model.photoUrl;
    return [NSURL URLWithString:urlString];
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    OTWAlbumCollectionViewCell *cell = (OTWAlbumCollectionViewCell *)[_rightCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    return cell.photo.image;
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
        [_leftCollectionView registerClass:[OTWAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
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
        [_rightCollectionView registerClass:[OTWAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"RightUICollectionViewCell"];

        _rightCollectionView.delegate=self;
        _rightCollectionView.dataSource=self;
        _rightCollectionView.backgroundColor = [UIColor clearColor];
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
//        _rightCollectionView.bounces = NO;
        _rightCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _Parameter.number = 0;
            [self loadUserPhotos];
        }];
        _rightCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _Parameter.number++;
            [self loadUserPhotos];
        }];
    }
    return _rightCollectionView;
}
-(UIView *)noResultView{
    if(!_noResultView){
        _noResultView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationHeight)];
        _noResultView.backgroundColor=[UIColor whiteColor];
        [_noResultView addSubview:self.noResultImage];
    }
    
    return _noResultView;
}
-(UIImageView *)noResultImage{
    if(!_noResultImage){
        _noResultImage=[[UIImageView alloc]init];
        _noResultImage.frame=CGRectMake((SCREEN_WIDTH-151)/2, (SCREEN_HEIGHT - 110) / 2 - 65, 151, 109);
        _noResultImage.image=[UIImage imageNamed:@"qx_wushangjia"];
    }
    return _noResultImage;
}

- (OTWBusinessAlbumParameter *)Parameter
{
    if (!_Parameter) {
        _Parameter = [[OTWBusinessAlbumParameter alloc] init];
        _Parameter.number = 0;
        _Parameter.size = 20;
        _Parameter.shopId = _shopId;
        _Parameter.currentTime = nil;
    }
    return _Parameter;
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
