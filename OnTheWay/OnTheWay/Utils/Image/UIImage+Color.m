//
//  UIImage+Color.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color{
    return [self imageWithColor:color size:CGSizeMake(10, 10)];
}

+ (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)circleImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width * 10.0, size.height * 10.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillEllipseInRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:UIImagePNGRepresentation(image) scale:10.0];
}

+ (UIImage *)imageWithColor:(UIColor *)color text:(NSString *)text size:(CGSize)size {
    //先创建放大一定倍数的画布，并在其上画圆、填色、写字，然后再缩放回原始比例，否则图片会模糊失真
    
    //放大倍数
    float ratio = 3.0;
    //得到ratio倍数的画布
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width * ratio, size.height * ratio);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //填充颜色（圆形）size.height=100时为个人信息页面头像，背景为白色
    if (size.height == 100) {
        UIColor * fillColor = [UIColor whiteColor];
        CGContextSetFillColorWithColor(context,fillColor.CGColor);
    } else {
        CGContextSetFillColorWithColor(context, [color CGColor]);
    }
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFill);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextSetShouldSmoothFonts(context, false);
    
    //得到当前画布的image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    [image drawAtPoint: CGPointZero];
    
    //设置文字属性
    CGFloat fontSize = 0;
    CGPoint onePint, twoPoint;
    if (size.height == 100) {
        fontSize = 30.0 * ratio;
        onePint = CGPointMake(rect.size.width/2-45, rect.size.height/2-50);
        twoPoint = CGPointMake(rect.size.width/2 - 90, rect.size.height/2-50);
    }
    else {
        fontSize = 10.0 * ratio;
        onePint = CGPointMake(rect.size.width/2-14, rect.size.height/2-16);
        twoPoint = CGPointMake(rect.size.width/2-29, rect.size.height/2-16);
    }
    //个人信息页面头像字体颜色
    UIColor *strokeColor = size.height == 100?color:[UIColor whiteColor];
    NSDictionary* dict = @{NSForegroundColorAttributeName: strokeColor,
                           NSFontAttributeName: [UIFont fontWithName:@"Arial" size:fontSize],
                           };
    //写文字
    if (text.length == 1) {
        [text drawAtPoint:onePint withAttributes:dict];
    }
    else if (text.length == 2) {
        [text drawAtPoint:twoPoint withAttributes:dict];
    }
    //得到写字后的image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //将newimage缩小至原始倍数返回
    return [UIImage imageWithData:UIImagePNGRepresentation(newImage) scale:ratio];
}

+ (UIImage *)image:(UIImage *)image Diameter:(CGFloat)diameter {
    //先创建image大小画布在其上裁减圆形，然后用image数据重新填充，最后将图片缩放到需要的比例
    //如不如此，则在uitableviewcell显示时会由于刷新问题无法将图片调整为圆形
    
    //创建image大小的画布
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    //裁减image（圆形）
    CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, image.size.width, image.size.height));
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    //绘制(如不加前两方法则绘制出的图片反向)
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    //得到newimage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    CFRelease(path);
    UIGraphicsEndImageContext();
    
    //缩放比例
    if (diameter == 0) {
        //0则为原始比例
        diameter = 1.0;
    }
    float ratio = newImage.size.height/diameter;
    return [UIImage imageWithData:UIImagePNGRepresentation(newImage) scale:ratio];
}

- (UIImage*)scaleToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  result;
}

@end
