//
//  CHBaseAlertView.h
//  HuBanMerchants
//
//  Created by andy on 2016/12/27.
//  Copyright © 2016年 北京致硕网络公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHBaseAlertView : UIView


/**
 自定义弹出框

 @param titleArray        标题数组(通过数组换行)
 @param messageArray      内容数组(通过数组换行)
 @param buttonTitleArrray 按钮文字数组(字典数组：{@"color":[uicolor blackcolor],@"title":title})
 @param clickBlock        点击的第几个，0开始
 */
+ (CHBaseAlertView *)shareBaseAlertViewWithTitleArray:(NSArray *)titleArray
                            messageArray:(NSArray *)messageArray
                       buttonTitleArrray:(NSArray *)buttonTitleArrray
                              clickBlock:(void (^)(NSInteger index))clickBlock;


@end
