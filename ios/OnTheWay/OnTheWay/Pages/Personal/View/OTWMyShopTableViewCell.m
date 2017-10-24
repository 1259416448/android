//
//  OTWMyShopTableViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWMyShopTableViewCell.h"

@implementation OTWMyShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16.5, 17, 17)];
        [self addSubview:_image];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_image.frame) + 10, 1, 120, 48)];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor color_202020];
        [self addSubview:_title];
        
        UIImageView * arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 7, 19, 7, 12)];
        arrow.image = [UIImage imageNamed:@"arrow_right"];
        [self addSubview:arrow];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 49.5, SCREEN_WIDTH - 15, 0.5)];
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
