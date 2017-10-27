//
//  OTWMyFansTableViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/10/26.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWMyFansTableViewCell.h"

@implementation OTWMyFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 45, 45)];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 45 / 2;
        [self addSubview:_headImageView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 15, 25 / 2, SCREEN_WIDTH - 100, 20)];
        _name.font = [UIFont systemFontOfSize:16];
        _name.textColor = [UIColor color_202020];
        [self addSubview:_name];
        
        _personImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 15, CGRectGetMaxY(_name.frame) + 6.5, 12, 12)];
        _personImg.image = [UIImage imageNamed:@"wd_guanzhu_fensi"];
        [self addSubview:_personImg];
        
        _fansNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_personImg.frame) + 5, CGRectGetMaxY(_name.frame) + 5, SCREEN_WIDTH - 250, 15)];
        _fansNum.font = [UIFont systemFontOfSize:13];
        _fansNum.textColor = [UIColor color_979797];
        [self addSubview:_fansNum];
        
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 7, 53 / 2, 7, 12)];
        _arrow.image = [UIImage imageNamed:@"arrow_right"];
        
        [self addSubview:_arrow];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 64.5, SCREEN_WIDTH - 15, 0.5)];
        line.backgroundColor = [UIColor color_d5d5d5];
        [self addSubview:line];
        
    }
    return self;
}
- (void)setModel:(OTWMyFansModel *)model
{
    _model = model;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.userHeadImg]];
    _name.text = _model.userNickname;
    _fansNum.text = [NSString stringWithFormat:@"粉丝 %@",_model.fansNum];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
