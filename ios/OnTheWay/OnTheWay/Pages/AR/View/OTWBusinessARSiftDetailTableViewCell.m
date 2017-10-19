//
//  OTWBusinessARSiftDetailTableViewCell.m
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/9/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessARSiftDetailTableViewCell.h"

@implementation OTWBusinessARSiftDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor color_f4f4f4];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH * 0.68 - 60, 43.5)];
        _titleLabel.font = [UIFont systemFontOfSize: 15];
        _titleLabel.textColor = [UIColor color_202020];
        [self addSubview:_titleLabel];
        _selectedImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 15 - 13, 15, 13, 14)];
        _selectedImg.image = [UIImage imageNamed:@"xuanze"];
        _selectedImg.hidden = YES;
        [self addSubview:_selectedImg];
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH * 0.68, 0.5)];
        _line.backgroundColor = [UIColor color_d5d5d5];
        [self addSubview:_line];
    }
    return self;
}
- (void)layoutSubviews
{
    _titleLabel.frame = CGRectMake(30, 0, self.frame.size.width - 60, self.frame.size.height - 0.5);
    _selectedImg.frame = CGRectMake(self.frame.size.width - 15 - 13, 15, 13, 14);
    _line.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
