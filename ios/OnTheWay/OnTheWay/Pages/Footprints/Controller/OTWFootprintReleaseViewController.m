//
//  OTWFootprintReleaseViewController.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintReleaseViewController.h"
#import "OTWCustomNavigationBar.h"
#import <IQKeyboardManager.h>
#import "PYPhotosView.h"
#import "OTWAlbumSelectHelper.h"
#import <TZImagePickerController.h>
#import <TZImageManager.h>
#import "OTWUITapGestureRecognizer.h"

@interface OTWFootprintReleaseViewController () <UITextViewDelegate,PYPhotosViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,strong) UIView *customRightNavigationBarView;

@property (nonatomic,strong) UIView *footprintContentView;

@property (nonatomic,strong) UILabel *footprintContentTips;

@property (nonatomic,strong) UITextView *footprintTextView;

@property (nonatomic,strong) UIView *centerLine;

@property (nonatomic,strong) UIView *photoChooseView;

@property (nonatomic,weak) PYPhotosView *publishPhotosView;

@property (nonatomic,assign) CGFloat photoW;

@end

@implementation OTWFootprintReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bulidUI];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) bulidUI
{
    self.title = @"发布足迹";
    self.view.backgroundColor=[UIColor color_f4f4f4];
    [self setCustomNavigationRightView:self.customRightNavigationBarView];
    //文本框
    [self.footprintContentView addSubview:self.footprintTextView];
    [self.footprintContentView addSubview:self.footprintContentTips];
    [self.footprintContentView addSubview:self.centerLine];
    [self.view addSubview:self.photoChooseView];
    //
    [self.view bringSubviewToFront:self.customNavigationBar];
    
    PYPhotosView *publishPhotosView = [PYPhotosView photosView];
    NSMutableArray *imagesM = [NSMutableArray array];
    publishPhotosView.images = imagesM;
    publishPhotosView.py_x = 15;
    publishPhotosView.py_y = 15;
    publishPhotosView.photoWidth = self.photoW;
    publishPhotosView.photoHeight = self.photoW;
    publishPhotosView.photosMaxCol = 4;
    publishPhotosView.photoMargin = 10;
    publishPhotosView.delegate = self;
    publishPhotosView.hideDeleteView = YES;
    [self.photoChooseView addSubview:publishPhotosView];
    self.publishPhotosView = publishPhotosView;
}

- (UIView *) footprintContentView
{
    if(!_footprintContentView){
        _footprintContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, 150)];
        _footprintContentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_footprintContentView];
    }
    return _footprintContentView;
}

- (UIView *) footprintContentTips
{
    if(!_footprintContentTips){
        _footprintContentTips = [[UILabel alloc] initWithFrame:CGRectMake(22.5, 15, 210, 25)];
        _footprintContentTips.text=@"把你此刻的心情分享给大家吧~";
        _footprintContentTips.textColor = [UIColor color_757575];
        _footprintContentTips.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _footprintContentTips;
}

- (UIView *) customRightNavigationBarView
{
    if(!_customRightNavigationBarView){
        _customRightNavigationBarView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-32, 30, 34, 22.5)];
        _customRightNavigationBarView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 34, 22.5)];
        titleLabel.text = @"发布";
        titleLabel.textColor = [UIColor color_202020];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [_customRightNavigationBarView addSubview:titleLabel];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footprintReleaseTap)];
        [_customRightNavigationBarView addGestureRecognizer:tapGesturRecognizer];
    }
    return _customRightNavigationBarView;
}

- (UITextView *) footprintTextView
{
    if(!_footprintTextView){
        _footprintTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.footprintContentTips.MinX, self.footprintContentTips.MinY, SCREEN_WIDTH - self.footprintContentTips.MinX * 2,150 - 30)];
        _footprintTextView.textColor = [UIColor color_202020];
        _footprintTextView.font = [UIFont systemFontOfSize:15];
        _footprintTextView.delegate = self;
        _footprintTextView.textContainerInset = UIEdgeInsetsMake(0,0, 0, 0);
        _footprintTextView.layoutManager.allowsNonContiguousLayout = NO;
        _footprintTextView.textAlignment = NSTextAlignmentLeft;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _footprintTextView;
}

- (UIView *) centerLine
{
    if(!_centerLine){
        _centerLine = [[UIView alloc] initWithFrame:CGRectMake(15, self.footprintContentView.Height-1, CGRectGetWidth(self.view.frame), 1)];
        _centerLine.backgroundColor = [UIColor color_f4f4f4];
    }
    return _centerLine;
}

- (UIView *) photoChooseView
{
    if(!_photoChooseView){
        _photoChooseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.footprintContentView.MaxY, CGRectGetWidth(self.view.frame), self.photoW + 15 * 2)];
        _photoChooseView.backgroundColor = [UIColor whiteColor];
    }
    return _photoChooseView;
}

- (CGFloat) photoW
{
    if(!_photoW || _photoW == 0){
        _photoW = (SCREEN_WIDTH - 15 * 2 - 10 *3 )/4;
    }
    return _photoW;
}

#pragma mark - 右侧按钮点击

- (void) footprintReleaseTap
{
    DLog(@"点击发布");
}

#pragma mark - UITextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.footprintContentTips.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length == 0){
        self.footprintContentTips.hidden = NO;
    }
}

#pragma mark - PYPhotosViewDelegate
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-images.count delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingGif = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto) {
        if(isSelectOriginalPhoto){
            for (NSObject *asset in assets) {
                [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *image,NSDictionary *info){
                    [images addObject:image];
                    [photosView reloadDataWithImages:images];
                }];
            }
        }else{
            for (UIImage *one in photos) {
                [images  addObject:one];
            }
        }
        [photosView reloadDataWithImages:images];
        //计算高度
        CGFloat photoChooseH = self.photoW + 15 * 2;
        if(images.count >= 4){
            photoChooseH = ( images.count / 4 + 1 ) * (self.photoW + 10) + 15 * 2 - 10;
        }
        _photoChooseView.frame = CGRectMake(0, self.footprintContentView.MaxY, CGRectGetWidth(self.view.frame), photoChooseH);
        [self layoutView];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 * 构建删除按钮,根据当前图片构建
 */
- (void) layoutView
{
    for (UIView *one in _photoChooseView.subviews) {
        if(![one isKindOfClass:[PYPhotosView class]]){
            [one removeFromSuperview];
        }
    }
    NSMutableArray *images = _publishPhotosView.images;
    if(images.count > 0){
        for (int i = 1; i<images.count+1; i++) {
            int xCount = i%4;
            CGFloat x = 0;
            if(xCount == 0){
                xCount = 4;
            }
            x = (xCount - 1) * _publishPhotosView.photoMargin + xCount *_publishPhotosView.photoWidth + _publishPhotosView.py_x - 7.5;
            CGFloat y = 0;
            int yCount = i/4 + 1;
            if(i%4==0){
                yCount = yCount - 1;
            }
            y = (yCount - 1) * _publishPhotosView.photoMargin + (yCount - 1) *_publishPhotosView.photoHeight + _publishPhotosView.py_y - 7.5;
            //生成图片
            [_photoChooseView addSubview:[self buildDeleteView:x y:y index:(i - 1)]];
        }
    }
}

- (UIView *) buildDeleteView:(CGFloat) x y:(CGFloat)y index:(int)index
{
    UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 16 , 16)];
    deleteImageView.image = [UIImage imageNamed:@"fb_delete"];
    OTWUITapGestureRecognizer *tapRecognizer = [[OTWUITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
    deleteImageView.userInteractionEnabled = YES;
    tapRecognizer.opId = [NSString stringWithFormat:@"%d",index];
    [deleteImageView addGestureRecognizer:tapRecognizer];
    deleteImageView.tag = index;
    return deleteImageView;
}

- (void) deleteImage:(UITapGestureRecognizer *) tapRecognizer
{
    OTWUITapGestureRecognizer *tap =(OTWUITapGestureRecognizer *)tapRecognizer;
    int index = [tap.opId intValue];
    [_publishPhotosView.images removeObjectAtIndex:index];
    [_publishPhotosView reloadDataWithImages:_publishPhotosView.images];
    [self layoutView];
}

// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr
{
    NSLog(@"进入预览图片");
}

/**
 * 删除图片按钮触发时调用此方法
 * imageIndex : 删除的图片在之前图片数组的位置
 */
- (void)photosView:(PYPhotosView *)photosView didDeleteImageIndex:(NSInteger)imageIndex
{
    CGFloat photoChooseH = self.photoW + 15 * 2;
    if(photosView.images.count >= 4){
        photoChooseH = ( photosView.images.count / 4 + 1 ) * (self.photoW + 10) + 15 * 2 - 10;
    }
    _photoChooseView.frame = CGRectMake(0, self.footprintContentView.MaxY, CGRectGetWidth(self.view.frame), photoChooseH);
}

@end
