//
//  OTWBusinessARSiftTableViewCell.m
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/9/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessARSiftTableViewCell.h"

@implementation OTWBusinessARSiftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _redLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 49)];
        _redLine.backgroundColor = [UIColor color_e50834];
        _redLine.hidden = YES;
        [self addSubview:_redLine];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH * 0.32 - 30, 43.5)];
        _titleLabel.font = [UIFont systemFontOfSize: 15];
        _titleLabel.textColor = [UIColor color_202020];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, self.frame.size.width, 0.5)];
        _line.backgroundColor = [UIColor color_d5d5d5];
        [self addSubview:_line];
    }
    return self;
}
- (void)layoutSubviews
{
    _titleLabel.frame = CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height - 0.5);
    _line.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
