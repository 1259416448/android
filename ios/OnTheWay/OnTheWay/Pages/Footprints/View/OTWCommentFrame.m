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
#define commentContentFont [UIFont fontWithName:@"PingFangSC-Regular" size:15]
#define commentNicknameFont [UIFont fontWithName:@"PingFangSC-Regular" size:14]
@implementation OTWCommentFrame

-(void) setCommentModel:(OTWCommentModel *)commentModel
{
    _commentModel = commentModel;
    CGFloat padding = 15;
    CGFloat paddingLeft = 55;
    CGSize textSize = [OTWUtils sizeWithString:_commentModel.commentContent font:commentContentFont maxSize:CGSizeMake(SCREEN_WIDTH-padding-paddingLeft, 2000)];
    _contentH = textSize.height;
    _cellHeight = paddingTop + paddingBottom + textSize.height;
    self.nicknameW = SCREEN_WIDTH - padding - 55;
    CGSize nicknameTextSize = [OTWUtils sizeWithString:_commentModel.userNickname font:commentNicknameFont maxSize:CGSizeMake(self.nicknameW, 15)];
    self.nicknameW = nicknameTextSize.width;
}

@end
