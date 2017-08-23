//
//  OTWFootprintDetail.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/16.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintDetailFrame.h"

#define paddingTop 75
#define paddingBottom 42
#define footprintContentFont [UIFont systemFontOfSize:17]
#define userNicknameFont [UIFont systemFontOfSize:16]
#define footprintDateCreatedStrFont [UIFont fontWithName:@"PingFangSC-Regular" size:12]

@implementation OTWFootprintDetailFrame

- (void) setFootprintDetailModel:(OTWFootprintListModel *)footprintDetailModel
{
    CGFloat padding = 15;
    _footprintDetailModel = footprintDetailModel;
    
    
    // 345 250
    
    _photoViewH = 0;
    
    if(_footprintDetailModel.footprintPhotoArray && _footprintDetailModel.footprintPhotoArray.count > 0){
        CGFloat bili = (SCREEN_WIDTH - padding *2)/345;
        _photoViewH = 250 * bili;
    }
    
    CGSize textSize = [self sizeWithString:_footprintDetailModel.footprintContent font:footprintContentFont maxSize:CGSizeMake(SCREEN_WIDTH-padding*2, 2000)];
    _contentH = textSize.height;
//    if (_footprintDetailModel.footprintCommentNum > 0) {
//        _cellHeight = textSize.height+paddingTop+paddingBottom + _photoViewH + 20 + 208;
//    } else {
//        _cellHeight = textSize.height+paddingTop+paddingBottom + _photoViewH + 20 + 36;
//    }
    
    //说明 第一个10 是内容差10 pt   第二个 10 表示 足迹详情 与 评论标题 之间的距离是10  ； 36 表示评论标题 height 36
    _cellHeight = textSize.height+paddingTop+paddingBottom + _photoViewH + 10 + 10 + 36;
    
    if(_photoViewH == 0){
        _cellHeight -= 10;
    }
    
    CGSize dateCreatedStrSize = [self sizeWithString:_footprintDetailModel.dateCreatedStr font:footprintDateCreatedStrFont maxSize:CGSizeMake(150, 12)];
    _dateCreatedStrW = dateCreatedStrSize.width;
    
    CGSize nicknameSize = [self sizeWithString:_footprintDetailModel.userNickname font:userNicknameFont maxSize:CGSizeMake(SCREEN_WIDTH - padding - 45 - 15 - 10, 20)];
    _nicknameH = nicknameSize.width;
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
