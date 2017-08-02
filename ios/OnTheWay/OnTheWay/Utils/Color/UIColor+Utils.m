//
//  UIColor+Utils.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

#pragma - 颜色转换 Color转换为十六进制颜色字符串

+(NSString *)hexValuesFromUIColor:(UIColor *)color {
    
    if (!color) {
        return nil;
    }
    
    if (color == [UIColor whiteColor]) {
        // Special case, as white doesn't fall into the RGB color space
        return @"ffffff";
    }
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);
    
    NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec];
    
    return returnString;
    
}


+ (UIColor *)color_333333 {
    return [UIColor colorWithHexString:@"333333"];
}
+ (UIColor *)color_898989 {
    return [UIColor colorWithHexString:@"898989"];
}
+ (UIColor *)color_bfbfbf {
    return [UIColor colorWithHexString:@"bfbfbf"];
}
+(UIColor*)color_fbfbfb{
    return [UIColor colorWithHexString:@"fbfbfb"];
}
+ (UIColor *)color_d9d9d9 {
    return [UIColor colorWithHexString:@"d9d9d9"];
}
+ (UIColor *)color_eff1ee {
    return [UIColor colorWithHexString:@"eff1ee"];
}
+ (UIColor *)color_ffe8e3 {
    return [UIColor colorWithHexString:@"ffe8e3"];
}
+ (UIColor *)color_22b2e7 {
    return [UIColor colorWithHexString:@"22b2e7"];
}
+ (UIColor *)color_d9dad9 {
    return [UIColor colorWithHexString:@"d9dad9"];
}
+ (UIColor *)color_f4f4f4 {
    return [UIColor colorWithHexString:@"f4f4f4"];
}
+ (UIColor *)color_d5d5d5 {
    return [UIColor colorWithHexString:@"d5d5d5"];
}
+ (UIColor *)color_202020 {
    return [UIColor colorWithHexString:@"202020"];
}
+ (UIColor *)color_f9f9f9 {
    return [UIColor colorWithHexString:@"f9f9f9"];
}
+ (UIColor *)color_c4c4c4{
    return [UIColor colorWithHexString:@"c4c4c4"];
}
+ (UIColor *)color_ff134c {
    return [UIColor colorWithHexString:@"ff134c"];
}
+ (UIColor *)color_ff9144 {
    return [UIColor colorWithHexString:@"ff9144"];
}
+(UIColor *)color_242424{
     return [UIColor colorWithHexString:@"242424"];
}
+(UIColor*)color_999999{
      return [UIColor colorWithHexString:@"999999"];
}
+(UIColor*)color_dedede{
     return [UIColor colorWithHexString:@"dedede"];
}
+ (UIColor *)color_979797 {
    return [UIColor colorWithHexString:@"979797"];
}
+ (UIColor *)color_e50834 {
    return [UIColor colorWithHexString:@"e50834"];
}
+ (UIColor *)color_545454 {
    return [UIColor colorWithHexString:@"545454"];
}
+ (UIColor *)color_757575 {
    return [UIColor colorWithHexString:@"757575"];
}
+ (UIColor *)color_ededed {
    return [UIColor colorWithHexString:@"ededed"];
}
+ (UIColor *)color_ffc6c8{
    return [UIColor colorWithHexString:@"ffc6c8"];
}
+ (UIColor *)color_f3715a{
    return [UIColor colorWithHexString:@"f3715a"];
}
@end
