//
//  OTWUtils.h
//  OnTheWay
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWUtils : NSObject

#pragma mark 判断系统版本是否大于等于某个值
+ (BOOL)system_version_greater_than_or_equal_to:(float)version;
#pragma mark 判断系统版本是否在某两个值之间
+ (BOOL)system_version_gerater_between:(float)version1 and:(float)version2;
#pragma mark 判断系统版本是否小于某个值
+ (BOOL)system_version_greater_less_than:(float)version;

/**
 * 弹出成功提示框，并在 1.5f 后关闭
 */
#pragma mark 弹出成功提示框
+ (MBProgressHUD *) alertSuccess:(NSString *)content userInteractionEnabled:(BOOL)userInteractionEnabled target:(UIViewController *)target;

/**
 * 带加载状态的提示框，不会自动关闭
 */
+ (MBProgressHUD *) alertLoading:(NSString *)content userInteractionEnabled:(BOOL)userInteractionEnabled target:(UIViewController *)target;

/**
 * 弹出失败提示框，并在 1.5f 后关闭
 */
+ (MBProgressHUD *) alertFailed:(NSString *)content userInteractionEnabled:(BOOL)userInteractionEnabled target:(UIViewController *)target;

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;
@end
