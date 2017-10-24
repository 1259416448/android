//
//  OTWMyShopTableHeadView.m
//  OnTheWay
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWMyShopTableHeadView.h"

@interface OTWMyShopTableHeadView ()

@property (nonatomic, strong) UILabel * timeLabel;

@property (nonatomic, strong) UIImageView * shopPic;
@property (nonatomic, strong) UILabel * shopName;
@property (nonatomic, strong) UILabel * shopAddress;
@property (nonatomic, strong) UILabel * shopPhoneNum;
@property (nonatomic, strong) UIView * discountView;


@end

@implementation OTWMyShopTableHeadView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line1.backgroundColor = [UIColor color_d5d5d5];
        [self addSubview:line1];
        
        UILabel * time = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 13)];
        time.text = @"认领时间";
        time.font = [UIFont systemFontOfSize:13];
        time.textColor = [UIColor color_202020];
        [self addSubview:time];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 120, 0.5, 120, 34)];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [UIColor color_979797];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = @"2017-02-01";
        [self addSubview:_timeLabel];
        
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = [UIColor color_d5d5d5];
        [self addSubview:line2];
        
        _shopPic = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(line2.frame) + 15, 110, 80)];
        [_shopPic sd_setImageWithURL:[NSURL URLWithString:[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg" stringByAppendingString:@"?imageView2/1/w/222/h/160"]]];
        [self addSubview:_shopPic];
        
        _shopName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_shopPic.frame) + 10, CGRectGetMaxY(line2.frame) + 15, SCREEN_WIDTH - 40 - 110, 20)];
        _shopName.font = [UIFont systemFontOfSize:16];
        _shopName.textColor = [UIColor color_202020];
        _shopName.text = @"胡大饭馆(东直门总店)";
        [self addSubview:_shopName];
        
        UIImageView * location = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_shopName.frame), CGRectGetMaxY(_shopName.frame) + 10, 10, 10)];
        location.image = [UIImage imageNamed:@"dingwei"];
        [self addSubview:location];
        
        _shopAddress = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(location.frame) + 5, CGRectGetMaxY(_shopName.frame) + 8, SCREEN_WIDTH - 40 - 110 - 14, 16)];
        _shopAddress.font = [UIFont systemFontOfSize:13];
        _shopAddress.textColor = [UIColor color_979797];
        _shopAddress.text = @"北大街联慧路88号";
        [self addSubview:_shopAddress];
        
        UIImageView * phone = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_shopName.frame), CGRectGetMaxY(location.frame) + 7, 10, 10)];
        phone.image = [UIImage imageNamed:@"dianhua"];
        [self addSubview:phone];
        
        _shopPhoneNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phone.frame) + 5, CGRectGetMaxY(_shopAddress.frame) + 1, SCREEN_WIDTH - 40 - 110 - 14, 14)];
        _shopPhoneNum.font = [UIFont systemFontOfSize:13];
        _shopPhoneNum.textColor = [UIColor color_979797];
        _shopPhoneNum.text = @"010-3456776";
        [self addSubview:_shopPhoneNum];
        
        UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 144.5, SCREEN_WIDTH, 0.5)];
        line3.backgroundColor = [UIColor color_d5d5d5];
        [self addSubview:line3];
        
    }
    return self;
}
- (void)layoutSubviews
{
    _timeLabel.frame = CGRectMake(SCREEN_WIDTH - 15 - 120, 0.5, 120, 34);
}

@end
