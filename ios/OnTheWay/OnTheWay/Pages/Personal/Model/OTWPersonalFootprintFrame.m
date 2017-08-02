//
//  OTWPersonalFootprintFrame.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/1.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalFootprintFrame.h"

#define contentLabelFont [UIFont fontWithName:@"PingFangSC-Regular" size:15]

@implementation OTWPersonalFootprintFrame

+ (instancetype) initWithFootprintDetail:(OTWFootprintListModel *)footprintDetail
{
    OTWPersonalFootprintFrame *footprintFrame = [[OTWPersonalFootprintFrame alloc] init];
    footprintFrame.footprintDetal = footprintDetail;
    return footprintFrame;
}

- (void) initData
{
    if(_footprintDetal.footprintPhotoArray && _footprintDetal.footprintPhotoArray.count>0){
        _hasPhoto = YES;
    }else{
        _hasPhoto = NO;
    }
    CGFloat textBGViewFX = 80;
    if(_hasPhoto) textBGViewFX = textBGViewFX + 80 + 10;
    CGFloat textBGViewFW = SCREEN_WIDTH - 15 - 80;
    if(_hasPhoto) textBGViewFW = textBGViewFW - 80 - 10;
    CGFloat textBGViewFH = 80;
    
    CGFloat maxContentLabelH = 63;
    
    CGFloat contentLabelFH = maxContentLabelH;
    //自动计算文字高度 最高 60
    CGSize textSize = [self sizeWithString:_footprintDetal.footprintContent font:contentLabelFont maxSize:CGSizeMake(textBGViewFW, maxContentLabelH)];
    contentLabelFH = textSize.height;
    
    if(!_hasPhoto&&!_hasRelease){
        textBGViewFH = contentLabelFH + 20;
    }
    
    _contentLabelF = CGRectMake(0, 0, textBGViewFW, contentLabelFH);
    _textBGViewF = CGRectMake(textBGViewFX, 0, textBGViewFW, textBGViewFH);

    CGFloat addressImageViewFW = 10;
    CGFloat addressLabelFX = addressImageViewFW +3;
    CGFloat addressLabelFW = textBGViewFW - addressLabelFX;
    if(_hasPhoto){
        _addressImageViewF = CGRectMake(0, maxContentLabelH + 7.5 , addressImageViewFW, 10);
        _addressLabelF = CGRectMake(addressLabelFX, maxContentLabelH + 6.5, addressLabelFW , 12);
    }else{
        _addressImageViewF = CGRectMake(0, contentLabelFH + 7.6 , addressImageViewFW, 10);
        
        _addressLabelF = CGRectMake(addressLabelFX, contentLabelFH + 6.5, addressLabelFW , 12);
    }
    
    _cellHeight = textBGViewFH + 15;
    
    if([_leftContent isEqualToString:@"今天"]){
        _cellLineF = CGRectMake(22.5, 4.5 , 1, _cellHeight - 4.5);
    }else{
        _cellLineF = CGRectMake(22.5, 0 , 1, _cellHeight);
    }
}

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
