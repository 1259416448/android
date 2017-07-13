//
//  OTWNewsCell.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewsCell.h"

@implementation OTWNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (UIImageView*)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = CGRectMake(15, (self.height-18)/2, 18, 18);
    }
    
    return _iconImageView;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.MaxX+10, _iconImageView.Y, 150, _iconImageView.Height)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor color_202020];
    }
    
    return _titleLabel;
}

- (UIImageView*)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.frame = CGRectMake(0, (self.height-12)/2, 7, 12);
        _arrowImageView.right = self.width - 10;
        DLog(@"self.width:%f", self.width);
        _arrowImageView.image = [UIImage imageNamed:@"arrow_right"];
    }
    
    return _arrowImageView;
}

- (UILabel*)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.Height-18)/2, 30, 18)];
        _subTitleLabel.font = [UIFont systemFontOfSize:15];
        _subTitleLabel.textColor = [UIColor color_202020];
        _subTitleLabel.right = self.arrowImageView.left - 10;
        _subTitleLabel.layer.cornerRadius = 10;
        _subTitleLabel.layer.masksToBounds = YES;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.backgroundColor = [UIColor redColor];
    }
    
    return _subTitleLabel;
}

- (UIView*)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(self.iconImageView.left, self.height-1, self.width, 1)];
        _line.backgroundColor = [UIColor color_f4f4f4];
    }
    
    return _line;
}

- (void)addContentView
{
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.line];
}

@end
