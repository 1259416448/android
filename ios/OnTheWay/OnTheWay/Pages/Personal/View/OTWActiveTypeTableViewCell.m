//
//  OTWActiveTypeTableViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWActiveTypeTableViewCell.h"

@implementation OTWActiveTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _activeImage = [[UILabel alloc] init];
        _activeImage.font = [UIFont systemFontOfSize:10];
        _activeImage.textColor = [UIColor whiteColor];
        _activeImage.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_activeImage];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor color_202020];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor color_d5d5d5];
        [self addSubview:line];
    }
    return self;
}
- (void)setModel:(OTWBusinessActivityModel *)model
{
    _model = model;
    NSInteger width = _model.name.length * 16 - 1;
    _activeImage.frame = CGRectMake((SCREEN_WIDTH - 25 - width) / 2, 29 / 2, 15, 15);
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_activeImage.frame) + 10, 0, width, 43.5);
    _titleLabel.text = _model.name;
    _activeImage.text = _model.typeName;
    _activeImage.backgroundColor = [UIColor colorWithHexString:_model.colorStr];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
