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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 60, 43.5)];
        _titleLabel.font = [UIFont systemFontOfSize: 15];
        _titleLabel.textColor = [UIColor color_202020];
        [self addSubview:_titleLabel];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor color_d5d5d5];
        [self addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
