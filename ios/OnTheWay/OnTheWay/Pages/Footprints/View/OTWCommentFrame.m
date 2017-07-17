//
//  OTWCommentFrame.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/16.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWCommentFrame.h"

#define paddingTop 54
#define paddingBottom 15
#define commentContentFont [UIFont systemFontOfSize:15]

@implementation OTWCommentFrame

-(void) setCommentModel:(OTWCommentModel *)commentModel
{
    _commentModel = commentModel;
    CGFloat padding = 15;
    CGFloat paddingLeft = 55;
    CGSize textSize = [self sizeWithString:_commentModel.commentContent font:commentContentFont maxSize:CGSizeMake(SCREEN_WIDTH-padding-paddingLeft, 2000)];
    _contentH = textSize.height;
    _cellHeight = paddingTop + paddingBottom + textSize.height;
}

#pragma mark - 计算文字高度

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
