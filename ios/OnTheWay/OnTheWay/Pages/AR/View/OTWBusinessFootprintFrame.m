//
//  OTWBusinessFootprintFrame.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/7.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessFootprintFrame.h"

#define businessFootprintContentFont [UIFont fontWithName:@"PingFangSC-Regular" size:15]
#define businessFootprintNicknameFont [UIFont fontWithName:@"PingFangSC-Regular" size:14]
#define businessFootprintMarginPadding 5

@implementation OTWBusinessFootprintFrame

static NSString *photoParamsTwo = @"?imageMogr2/thumbnail/!20p";

- (id) initWithFootprint:(OTWFootprintListModel *)footprint
{
    self = [super init];
    if(self){
        self.footprintDetail = footprint;
        [self buildFrame];
    }
    return self;
}

//设置frame信息，计算cell高度
- (void) buildFrame
{
    CGFloat paddingLeft = 55;
    CGFloat contentW = SCREEN_WIDTH - paddingLeft - GLOBAL_PADDING;
    CGSize contentSize = [OTWUtils sizeWithString:self.footprintDetail.footprintContent font:businessFootprintContentFont maxSize:CGSizeMake(contentW, 1000)];
    self.contentH = contentSize.height;
    //计算照片的高度
    if(self.footprintDetail.footprintPhotoArray && self.footprintDetail.footprintPhotoArray.count >0 ){
        //根据图片张数计算高度
        NSUInteger cell = self.footprintDetail.footprintPhotoArray.count / 3;
        if(self.footprintDetail.footprintPhotoArray.count % 3 != 0){
            cell ++ ;
        }
        self.photoViewH = self.photoH * cell + 5 * (cell - 1);
        
        // 1. 创建缩略图图片链接数组
        NSMutableArray *thumbnailImageUrls = [NSMutableArray array];
        // 2 创建原图图片链接数组
        NSMutableArray *originalImageUrls = [NSMutableArray array];
        
        for (NSString *one in self.footprintDetail.footprintPhotoArray) {
            [thumbnailImageUrls addObject:[one stringByAppendingString:photoParamsTwo]];
            //增加了参数处理
            //[originalImageUrls addObject:[one stringByAppendingString:photoParamsTwo]];
            [originalImageUrls addObject:one];
        }
        self.photosView.thumbnailUrls = thumbnailImageUrls;
        self.photosView.originalUrls = originalImageUrls;

    } else {
        self.photoViewH = 0;
    }
    //设置cell高度
    self.cellHeight = ceilf(54 + self.contentH + (self.photoViewH == 0 ? 0 : (self.photoViewH + 5 )) + 50);
    
    self.nicknameW = SCREEN_WIDTH - GLOBAL_PADDING - 55;
    CGSize nicknameTextSize = [OTWUtils sizeWithString:self.footprintDetail.userNickname font:businessFootprintNicknameFont maxSize:CGSizeMake(self.nicknameW, 15)];
    self.nicknameW = nicknameTextSize.width;
    
}

- (CGFloat) photoH
{
    if(!_photoH || _photoH == 0){
        //  78 / 97 高宽比
        _photoH = 78.0 / 97.0 * self.photoW;
    }
    return _photoH;
}

- (CGFloat) photoW
{
    if(!_photoW || _photoW == 0){
        _photoW = (SCREEN_WIDTH - 55 - GLOBAL_PADDING - 5 * 2) / 3;
    }
    return _photoW;
}

- (PYPhotosView *) photosView
{
    if(!_photosView){
        _photosView = [[PYPhotosView alloc] init];
        _photosView.py_x = 0;
        _photosView.py_y = 0;
        _photosView.photoWidth = self.photoW;
        _photosView.photoHeight = self.photoH;
        _photosView.photoMargin = businessFootprintMarginPadding;
    }
    return _photosView;
}

@end
