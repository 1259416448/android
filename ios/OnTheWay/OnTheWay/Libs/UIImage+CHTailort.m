//
//  UIImage+CHTailort.m
//  THMMProject
//
//  Created by 唐川辉 on 16/7/16.
//  Copyright © 2016年 tangchuanhui. All rights reserved.
//

#import "UIImage+CHTailort.h"
#import "HYBImageCliped.h"

@implementation UIImage (CHTailort)


-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
//    CGFloat height = self.size.height;

    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


/**
 *  按比例不拉伸缩放裁剪
 */
- (UIImage *)scaleNormalTosize:(CGSize )size {
    
//    NSLog(@"0%@",NSStringFromCGSize(self.size));
    
    CGFloat origianlRatio = self.size.width/self.size.height;;
    CGFloat newlRatio = size.width/size.height;
    
    //原图比例小余新图,裁掉上下两部分,保留中间
    if (origianlRatio < newlRatio) {
        CGFloat newImageHeigh = self.size.width/ newlRatio;
        CGFloat newImageY = (self.size.height-newImageHeigh)/2;
        UIImage *image = [self getSubImage:CGRectMake(0, newImageY, self.size.width, newImageHeigh)];
//        image = [image scaleToSize:CGSizeMake(size.width*2, size.height*2)];

//        NSLog(@"1%@",NSStringFromCGSize(image.size));

        return image;
    }
    
    
    //原图比例大余新图,裁掉左右两部分,保留中间
    else if (origianlRatio > newlRatio) {
        CGFloat newImageWidth = newlRatio * self.size.height;
        CGFloat newImageX = (self.size.width-newImageWidth)/2;
        UIImage *image = [self getSubImage:CGRectMake(newImageX, 0, newImageWidth,self.size.height)];
//         image = [image scaleToSize:CGSizeMake(size.width*2, size.height*2)];
//        NSLog(@"2%@",NSStringFromCGSize(image.size));

        return image;
    }
    
    //比例相同
    return self;
//    return [self scaleToSize:CGSizeMake(size.width*2, size.height*2)];
}

/**
 图片浏览生成中心小图片,背景黑图
 
 @param centerImage 中心图
 */
+ (UIImage *)mergeImageWithCenterImage:(UIImage *)centerImage {
    
    CGSize size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT/2.0);
    
    //    获得图片上下文
    UIGraphicsBeginImageContext(size);
    
    UIImage *blackImage = [UIImage hyb_imageWithColor:[UIColor clearColor] toSize:size];
    
    CGFloat centerWidth = (SCREEN_WIDTH-120)/3.0;
    
    //    绘图
    [blackImage drawInRect:CGRectMake(0, 0, 0.01, 0.01)];
    
    //    [self.img2 drawInRect:CGRectMake(0, _img1.size.height, size.width, _img2.size.height)];
    [centerImage drawInRect:CGRectMake(size.width/2-centerWidth/2.0, size.height/2-centerWidth/2.0, centerWidth, centerWidth)];
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //    关闭图片上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage;

{
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, clipRect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}
    




@end
