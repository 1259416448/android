//
//  UIColor+Utils.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)

+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (UIColor *)colorWithHexString: (NSString *)color;
+ (NSString *)hexValuesFromUIColor:(UIColor *)color;

+ (UIColor *)color_333333;
+ (UIColor *)color_898989;
+ (UIColor *)color_bfbfbf;
+ (UIColor *)color_d9d9d9;
+ (UIColor *)color_eff1ee;
+ (UIColor *)color_22b2e7;
+ (UIColor *)color_d9dad9;

@end
