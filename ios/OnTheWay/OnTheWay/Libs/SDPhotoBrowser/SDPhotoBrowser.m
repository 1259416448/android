//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"
#import "UIImage+CHTailort.h"

#import "LSActionSheet.h"
//#import "TranslateMessageViewController.h"
//#import "CHUserNetRequest.h"

//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"
//#import "CHBaseTopRemindAnimationView.h"

//  =============================================

@implementation SDPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
    BOOL _willDisappear;
    NSTimer     *_myidleTimer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SDPhotoBrowserBackgrounColor;
        _isAnimate = YES;
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)dealloc
{
//    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"framess"];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
    }
}
-(void)resetIdleTimer {
    
    if (_myidleTimer) {
        
        [_myidleTimer invalidate];
        
    }
    
    int timeout = 5;
    
    _myidleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    
    
}
-(void)idleTimerExceeded {
    _indexLabel.hidden = YES;
}

- (void)setupToolbars
{
    [self resetIdleTimer];
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 49);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont systemFontOfSize:20];
    indexLabel.backgroundColor = UIColorFromRGBAlpha(0x000000, 0.63);
//    indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
    indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
        _indexLabel = indexLabel;
        [self addSubview:indexLabel];
    }
    
    
    // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    saveButton.hidden = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];
}

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)saveImageAlert:(UIGestureRecognizer *)gesture {
    
    if (gesture.state != UIGestureRecognizerStateBegan ) {
        return;
    }
    
    [LSActionSheet showWithTitle:@"" destructiveTitle:@"" otherTitles:@[@"保存图片"] block:^(int index) {
        if (index == 1) {
            [self saveImage];
        }
        else if (index == 0) {
            
        }
    }];
    
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    UILongPressGestureRecognizer *longPoress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImageAlert:)];
    [_scrollView addGestureRecognizer:longPoress];
    longPoress.minimumPressDuration = 0.6;
    longPoress.numberOfTouchesRequired = 1;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
        imageView.tag = i;

        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [_scrollView addSubview:imageView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    SDBrowserImageView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        NSURL *imageURL =  [self highQualityImageURLForIndex:index];
        NSString *urlstr = [imageURL absoluteString];
        if ([urlstr containsString:@"http"]) {
            
            [imageView setImageWithURL:imageURL placeholderImage:[self placeholderImageForIndex:index]];
        }
        
        //localfile
        else if ([urlstr containsString:@"localfile"]) {
            imageView.image = [self placeholderImageForIndex:index];
        }
        
        else if ([urlstr containsString:@"chlocalfile"]) {
            
        }
        
        else {
            
            NSData *data = [NSData dataWithContentsOfFile:urlstr];
            UIImage *localImage = [UIImage imageWithData:data];
            imageView.image = localImage;
        }
        
        
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    if (_isAnimate == YES) {
        
        _scrollView.hidden = YES;
        _willDisappear = YES;
        
        SDBrowserImageView *currentImageView = (SDBrowserImageView *)recognizer.view;
        NSInteger currentIndex = currentImageView.tag;
        
        UIView *sourceView = nil;
        if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
            UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
            NSIndexPath *path = [NSIndexPath indexPathForItem:currentIndex inSection:0];
            sourceView = [view cellForItemAtIndexPath:path];
        }else {
            sourceView = self.sourceImagesContainerView.subviews[currentIndex];
        }
        
        
        
        CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
        
        UIImageView *tempView = [[UIImageView alloc] init];
        tempView.contentMode = sourceView.contentMode;
        tempView.clipsToBounds = YES;
        tempView.image = currentImageView.image;
        CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
        
        if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
            h = self.bounds.size.height;
        }
        
        tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
        tempView.center = self.center;
        
        [self addSubview:tempView];
        
        _saveButton.hidden = YES;
        
        [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
            tempView.frame = targetTemp;
            self.backgroundColor = [UIColor clearColor];
            _indexLabel.alpha = 0.1;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
//        [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
//            self.backgroundColor = [UIColor clearColor];
//            _indexLabel.alpha = 0.1;
//        } completion:^(BOOL finished) {
            [self removeFromSuperview];
//        }];
    }
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
    SDBrowserImageView *imageView = (SDBrowserImageView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 2.0;
    }
    
    SDBrowserImageView *view = (SDBrowserImageView *)recognizer.view;

    [view doubleTapToZommWithScale:scale];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(SDBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 24.5);
    _saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"framess" options:0 context:nil];
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        SDBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[SDBrowserImageView class]]) {
            [currentImageView clear];
        }
    }
}

- (void)showFirstImage
{
//    UIView *sourceView = nil;
//    
//    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
//        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
//        NSIndexPath *path = [NSIndexPath indexPathForItem:self.currentImageIndex inSection:0];
//        sourceView = [view cellForItemAtIndexPath:path];
//    }else {
//        sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
//    }
//    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
//    
//    UIImageView *tempView = [[UIImageView alloc] init];
//    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
//    
//    [self addSubview:tempView];
//    
//    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
//    
//    tempView.frame = rect;
//    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
//    _scrollView.hidden = YES;
    
    if (_isAnimate == YES) {
        UIImage *images = [self placeholderImageForIndex:self.currentImageIndex];
        if (images != nil) {
            UIView *sourceView = nil;
            
            if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
                UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
                NSIndexPath *path = [NSIndexPath indexPathForItem:self.currentImageIndex inSection:0];
                sourceView = [view cellForItemAtIndexPath:path];
            }else {
                sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
            }
            CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
            
            UIImageView *tempView = [[UIImageView alloc] init];
            tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
            
            [self addSubview:tempView];
            
            CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
            
            tempView.frame = rect;
            tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
            _scrollView.hidden = YES;
            
            
            [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
                tempView.center = self.center;
                tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
            } completion:^(BOOL finished) {
                _hasShowedFistView = YES;
                [tempView removeFromSuperview];
                _scrollView.hidden = NO;
            }];
        }else{
//            [UIView animateWithDuration:0.1 animations:^{
//                
//            } completion:^(BOOL finished) {
//                _hasShowedFistView = YES;
//                _scrollView.hidden = NO;
//            }];
            _hasShowedFistView = YES;
            _scrollView.hidden = NO;
        }
    }else{
        [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
//            tempView.center = self.center;
//            tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
        } completion:^(BOOL finished) {
            _hasShowedFistView = YES;
//            [tempView removeFromSuperview];
            _scrollView.hidden = NO;
        }];
//        _scrollView.hidden = NO;
    }
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        
        UIImage *returnImage =[self.delegate photoBrowser:self placeholderImageForIndex:index];
        if (returnImage == nil) {
            return nil;
        }
        UIImage *newImage = [UIImage mergeImageWithCenterImage:returnImage];
        
        NSURL *url = [self highQualityImageURLForIndex:index];
        NSString *urlstr = [url absoluteString];

        if ([urlstr containsString:@"localfile"]) {
            newImage = returnImage;
        }
        
        
        return newImage;
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _indexLabel.hidden = NO;
    [self resetIdleTimer];
    
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        SDBrowserImageView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    
    NSLog(@"%lf-size=%lf",scrollView.contentOffset.x,scrollView.contentSize.width);
    
    if (!_willDisappear) {
        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    }
    [self setupImageOfImageViewForIndex:index];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.currentImageIndex+1>=self.imageCount) {
        if (scrollView.contentOffset.x>  (self.currentImageIndex*(SCREEN_WIDTH+20) + 20)) {
            [OTWUtils alertFailed:@"没有更多了哦" userInteractionEnabled:NO target:nil];
        }
    }
    
}



@end
