//
//  UIImage+CHTailort.h
//  THMMProject
//
//  Created by 唐川辉 on 16/7/16.
//  Copyright © 2016年 tangchuanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CHTailort)


/**
 *  裁剪部分图片
 *
 *  @param rect 大写
 *
 *  @return uiimage
 */
-(UIImage*)getSubImage:(CGRect)rect;


/**
 *  等比例缩放图片
 *
 *  @param size 大写
 *
 *  @return uiimage
 */
-(UIImage*)scaleToSize:(CGSize)size;
/**
 *  按比例不拉伸缩放裁剪
 */
- (UIImage *)scaleNormalTosize:(CGSize )size;


- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;



/**
 图片浏览生成中心小图片,背景黑图

 @param centerImage 中心图
 */
+ (UIImage *)mergeImageWithCenterImage:(UIImage *)centerImage;

/**
 裁剪图片

 @param clipRect  裁剪的位置，大小
 @param clipImage 裁剪的图片

 @return 裁剪后的图片
 */
- (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage;


@end
