//
//  OTWFootprintListFrame.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintListFrame.h"
#import "OTWFootprintListModel.h"
#import <MJExtension.h>

#define FootprintDateCreatedStrFont [UIFont systemFontOfSize:11]
#define nicknameLabelFont [UIFont systemFontOfSize:15]

@implementation OTWFootprintListFrame

-(void)setFootprint:(OTWFootprintListModel *)footprint
{
    _footprint = footprint;
    
    CGFloat padding = 15;
    
    //用户头像
    CGFloat userHeadImgFX = 15;
    CGFloat userHeadImgFY = 10;
    CGFloat userHeadImgFW = 34;
    CGFloat userHeadImgFH = 34;
    _userHeadImgF = CGRectMake(userHeadImgFX, userHeadImgFY, userHeadImgFH, userHeadImgFW);
    
    //用户名称
    CGFloat userNicknameFX = userHeadImgFX+userHeadImgFW+10;
    CGFloat userNicknameFY = 10;
    CGFloat userNicknameFW = SCREEN_WIDTH - padding *2 - userNicknameFX - 15;
    CGFloat userNicknameFH = 34;
    //计算一下nickname宽度
    CGSize nickNameSize = [self sizeWithString:_footprint.userNickname font:nicknameLabelFont maxSize:CGSizeMake(userNicknameFW, userNicknameFH)];
    _userNicknameF = CGRectMake(userNicknameFX, userNicknameFY, nickNameSize.width, userNicknameFH);
    
    //内容
    CGFloat footprintContentX = 15;
    CGFloat footprintContentY = 45;
    CGFloat footprintContentW = 0;
    if(!_footprint.footprintPhoto || [_footprint.footprintPhoto isEqualToString:@""]){
        footprintContentW = SCREEN_WIDTH - padding*2 - 15*2;
    }else{
        footprintContentW = SCREEN_WIDTH - padding*2 - 15 - 70;
    }
    CGFloat footprintContentH = 46;
    _footprintContentF = CGRectMake(footprintContentX, footprintContentY, footprintContentW, footprintContentH);
    
    //图片 只有有图片时，才增加
    if(_footprint.footprintPhoto && ![_footprint.footprintPhoto isEqualToString:@""]){
        CGFloat footprintPhotoImgFX = SCREEN_WIDTH - 15 - 46 - padding*2;
        CGFloat footprintPhotoImgFY = 45;
        CGFloat footprintPhotoImgFW = 46;
        CGFloat footprintPhotoImgFH = 46;
        _footprintPhotoImgF = CGRectMake(footprintPhotoImgFX, footprintPhotoImgFY, footprintPhotoImgFW, footprintPhotoImgFH);
    }
    
    //定位图标
    CGFloat footprintAddressImageFX = 15 ;
    CGFloat footprintAddressImageFY = 97 - 46  + footprintContentH ; //为了以后可以适配内容高度变化
    CGFloat footprintAddressImageFW = 9.8;
    CGFloat footprintAddressImageFH = 9.8;
    _footprintAddressImageF = CGRectMake(footprintAddressImageFX, footprintAddressImageFY, footprintAddressImageFW, footprintAddressImageFH);

    
    CGSize textSize = [self sizeWithString:_footprint.dateCreatedStr font:FootprintDateCreatedStrFont maxSize:CGSizeMake(100, 12)];
    
    //时间图标
    CGFloat dataCreatedImageFX = SCREEN_WIDTH - 14 -padding*2 - textSize.width - 3 - 10 ;
    CGFloat dataCreatedImageFY = 96.5;
    CGFloat dataCreatedImageFW = 10;
    CGFloat dataCreatedImageFH = 10;
    _dataCreatedImageF = CGRectMake(dataCreatedImageFX, dataCreatedImageFY,dataCreatedImageFW,dataCreatedImageFH);
    
    //时间文字
    CGFloat dataCreatedFX = SCREEN_WIDTH - 14 - padding*2 - textSize.width;
    CGFloat dataCreatedFY = 96;
    CGFloat dataCreatedFW = textSize.width;
    CGFloat dataCreatedFH = 12;
    _dataCreatedF = CGRectMake(dataCreatedFX, dataCreatedFY, dataCreatedFW, dataCreatedFH);
    
    
    //定位label
    CGFloat footprintAddressFX = 26+1.8;
    CGFloat footprintAddressFY = 96 - 46  + footprintContentH;
    CGFloat footprintAddressFW = SCREEN_WIDTH - 30 - 28 - textSize.width - 30;
    CGFloat footprintAddressFH = 12;
    _footprintAddressF = CGRectMake(footprintAddressFX, footprintAddressFY, footprintAddressFW, footprintAddressFH);
    
    //目前行高固定
    _cellHeight = 118 ;
    _footprintBGF = CGRectMake(15, 10, SCREEN_WIDTH-15*2, _cellHeight);
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
