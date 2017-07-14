//
//  OTWFindBusinessMenFrame.m
//  OnTheWay
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFindBusinessmenFrame.h"
#import "OTWFindBusinessmenModel.h"

@implementation OTWFindBusinessmenFrame

-(void)setFindBusinessmen:(FindBusinessmenModel *)findBusinessmen
{
    _findBusinessmen = findBusinessmen;
    
   CGFloat padding = 15;
    
    //距离文字
    _distanceF=CGRectMake(0, 0, 50, 40);
    //时间文字
     _needTimeF = CGRectMake(0, 0, 50, 40);
    
    //用户名称
//    CGFloat userNameFX = userNameFX+userNameFW+10;
//    CGFloat userNameFY = 18;
//    CGFloat userNameFW = SCREEN_WIDTH - padding *2 - userNameFX - 15;
//    CGFloat userNameFH = 18;
    _userNameF = CGRectMake(padding, padding, SCREEN_WIDTH- padding *2-33, 18);
    
    //内容
//    CGFloat footprintContentX = 15;
//    CGFloat footprintContentY = 45;
//    CGFloat footprintContentW = 0;
//    CGFloat footprintContentH = 46;
    _addressContentF = CGRectMake(0, 0, 50, 40);
    
    //定位图标
//    CGFloat footprintAddressImageFX = 15 ;
//    CGFloat footprintAddressImageFY = 97 - 46  + footprintContentH ; //为了以后可以适配内容高度变化
//    CGFloat footprintAddressImageFW = 8;
//    CGFloat footprintAddressImageFH = 10;
    _addressImageF = CGRectMake(0, 0, 50, 40);
    
    //定位label
//    CGFloat footprintAddressFX = 26;
//    CGFloat footprintAddressFY = 96 - 46  + footprintContentH;
//    CGFloat footprintAddressFW = SCREEN_WIDTH - padding*2 - 15 - 80;
//    CGFloat footprintAddressFH = 12;
//    _footprintAddressF = CGRectMake(footprintAddressFX, footprintAddressFY, footprintAddressFW, footprintAddressFH);
//    
//    CGSize textSize = [self sizeWithString:_footprint.dateCreatedStr font:FootprintDateCreatedStrFont maxSize:CGSizeMake(100, 12)];
    
//    DLog(@"textSize w :%f",textSize.width);
    
    //时间图
    
    //目前行固定
    _cellHeight = 118 ;
    _findBusinessBGF = CGRectMake(15, 10, SCREEN_WIDTH-15*2, _cellHeight);
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
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
