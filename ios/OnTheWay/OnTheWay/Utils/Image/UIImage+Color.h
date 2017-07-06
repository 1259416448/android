//
//  UIImage+Color.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)circleImageWithColor:(UIColor *)color
                             size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color
                       text:(NSString*)text
                       size:(CGSize)size;


+ (UIImage *)image:(UIImage *)image
          Diameter:(CGFloat)diameter;

- (UIImage*)scaleToSize:(CGSize)newSize;

@end
