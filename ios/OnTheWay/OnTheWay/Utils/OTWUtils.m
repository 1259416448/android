//
//  OTWUtils.m
//  OnTheWay
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWUtils.h"

@implementation OTWUtils

#pragma mark 判断系统版本是否大于某个版本
+(BOOL)system_version_greater_than_or_equal_to:(float)version
{
    float currentVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (currentVersion < version) {
        return NO;
    }
    return YES;
}

#pragma mark 判断系统版本是否在某两个值之间
+(BOOL)system_version_gerater_between:(float)version1 and:(float)version2
{
    float currentVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (currentVersion >= version1  && currentVersion < version2) {
        return YES;
    }
    return NO;
}

#pragma mark 判断系统版本是否小于某个值
+(BOOL)system_version_greater_less_than:(float)version
{
    float currentVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (currentVersion < version) {
        return YES;
    }
    return NO;
}

+ (MBProgressHUD *) alertSuccess:(NSString *)content userInteractionEnabled:(BOOL)userInteractionEnabled target:(UIViewController *)target
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:target.view animated:YES];
    hud.userInteractionEnabled = userInteractionEnabled;
    
    UIImage *image = [UIImage imageNamed:@"ar_chenggongtishi"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    
    hud.label.numberOfLines = 0;
    hud.label.text = content;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    
    [hud.label setTop:10];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    //hud.bezelView.layer.opacity = 0.7;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.layer.cornerRadius = 10;
    hud.minSize = CGSizeMake(110, 95);
    hud.mode = MBProgressHUDModeCustomView;
    [hud hideAnimated:YES afterDelay:1.5f];
    return hud;
}

/**
 * 带加载状态的提示框，不会自动关闭
 */
+ (MBProgressHUD *) alertLoading:(NSString *)content userInteractionEnabled:(BOOL)userInteractionEnabled target:(UIViewController *)target
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:target.view animated:YES];
    hud.userInteractionEnabled = userInteractionEnabled;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator startAnimating];
    hud.customView = indicator;
    hud.label.numberOfLines = 0;
    hud.label.text = content;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [hud.label setTop:10];
    hud.contentColor = [UIColor whiteColor];
    
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.layer.cornerRadius = 10;
    hud.minSize = CGSizeMake(110, 95);
    hud.mode = MBProgressHUDModeCustomView;
    return hud;
}


/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
