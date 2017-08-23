//
//  CreateShopPicCell.m
//  OnTheWay
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "CreateShopPicCell.h"
#import "PYPhotosView.h"
#import "OTWUITapGestureRecognizer.h"
#import "OTWAlbumSelectHelper.h"
#import <TZImagePickerController.h>
#import <TZImageManager.h>

#define TFCellPadding_15 15
#define TFCellPadding_5 5


@interface CreateShopPicCell()<PYPhotosViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,assign) CGFloat picHeight;
@property (nonatomic,strong) UIView *photoChooseView;
@property (nonatomic,weak) PYPhotosView *publishPhotosView;
@property (nonatomic,strong) UINavigationController *mainControl;

@end

@implementation CreateShopPicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    //设置cell背景色
    [self setBackgroundColor:[UIColor whiteColor]];
    //初始化图片选择器
    [self initPYPhotoV];
    [self addSubview:self.photoChooseView];
    
}

- (void)initPYPhotoV
{
    PYPhotosView *addShopImgV = [PYPhotosView photosView];
    NSMutableArray *imageArr = [NSMutableArray array];
    addShopImgV.images = imageArr;
    addShopImgV.py_x = 15;
    addShopImgV.py_y = 15;
    addShopImgV.photoWidth = self.picHeight;
    addShopImgV.photoHeight = self.picHeight;
    addShopImgV.photosMaxCol = 4;
    addShopImgV.photoMargin = 10;
    addShopImgV.delegate = self;
    addShopImgV.hideDeleteView = YES;
    [self.photoChooseView addSubview:addShopImgV];
    self.publishPhotosView = addShopImgV;
}

- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - images.count delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
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
        CGFloat photoChooseH = self.picHeight + 15 * 2;
        if(images.count >= 4){
            photoChooseH = ( images.count / 4 + 1 ) * (self.picHeight + 10) + 15 * 2 - 10;
        }
        self.photoChooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, photoChooseH);
        [self layoutView];
    }];
    [self.mainControl presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 * 构建删除按钮,根据当前图片构建
 */
- (void) layoutView
{
    for (UIView *one in self.photoChooseView.subviews) {
        if(![one isKindOfClass:[PYPhotosView class]]){
            [one removeFromSuperview];
        }
    }
    NSMutableArray *images = self.publishPhotosView.images;
    if(images.count > 0){
        for (int i = 1; i<images.count+1; i++) {
            int xCount = i%4;
            CGFloat x = 0;
            if(xCount == 0){
                xCount = 4;
            }
            x = (xCount - 1) * self.publishPhotosView.photoMargin + xCount *self.publishPhotosView.photoWidth + self.publishPhotosView.py_x - 7.5;
            CGFloat y = 0;
            int yCount = i/4 + 1;
            if(i%4==0){
                yCount = yCount - 1;
            }
            y = (yCount - 1) * _publishPhotosView.photoMargin + (yCount - 1) *_publishPhotosView.photoHeight + _publishPhotosView.py_y - 7.5;
            //生成图片
            [self.photoChooseView addSubview:[self buildDeleteView:x y:y index:(i - 1)]];
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
    [self.publishPhotosView.images removeObjectAtIndex:index];
    [self.publishPhotosView reloadDataWithImages:self.publishPhotosView.images];
    [self layoutView];
    [self photosView:self.publishPhotosView didDeleteImageIndex:index];
}

/**
 * 删除图片按钮触发时调用此方法
 * imageIndex : 删除的图片在之前图片数组的位置
 */
- (void)photosView:(PYPhotosView *)photosView didDeleteImageIndex:(NSInteger)imageIndex
{
    CGFloat photoChooseH = self.picHeight + 15 * 2;
    if(photosView.images.count >= 4){
        photoChooseH = ( photosView.images.count / 4 + 1 ) * (self.picHeight + 10) + 15 * 2 - 10;
    }
    self.photoChooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, photoChooseH);
    [self layoutView];
}

+ (CGFloat)cellHeight:(CreateShopModel *)createModel
{
    CGFloat cellHeight = (SCREEN_WIDTH - 15*2 - 10*3)/4 + 15*2;
    return cellHeight;
}

- (void)refreshContent:(CreateShopModel *)createModel formModel:(CreateShopFormModel *)formModel control:(UINavigationController *)control
{
    self.mainControl = control;
}

- (UIView *) photoChooseView
{
    if(!_photoChooseView){
        _photoChooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.picHeight + 15 * 2)];
        _photoChooseView.backgroundColor = [UIColor whiteColor];
    }
    return _photoChooseView;
}

- (CGFloat)picHeight
{
    if (!_picHeight) {
        _picHeight = (SCREEN_WIDTH - 15*2 - 10*3)/4;
    }
    return _picHeight;
}

@end
