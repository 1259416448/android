//
//  OTWAddNewActiveTableViewCellTwo.m
//  OnTheWay
//
//  Created by apple on 2017/10/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWAddNewActiveTableViewCellTwo.h"

@implementation OTWAddNewActiveTableViewCellTwo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 49.5)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor color_202020];
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, 0, 100, 49.5)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = UIColorFromRGB(0x979797);
        [self addSubview:_timeLabel];
        
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 7, (self.frame.size.height - 12) / 2, 7, 12)];
        _arrow.image = [UIImage imageNamed:@"arrow_right"];
        [self addSubview:_arrow];
        
        UIView * downLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
        downLine.backgroundColor = [UIColor color_d5d5d5];
        [self addSubview:downLine];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
