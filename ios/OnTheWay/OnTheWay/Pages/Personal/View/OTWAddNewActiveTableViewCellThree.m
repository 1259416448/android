//
//  OTWAddNewActiveTableViewCellThree.m
//  OnTheWay
//
//  Created by apple on 2017/10/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWAddNewActiveTableViewCellThree.h"

@implementation OTWAddNewActiveTableViewCellThree

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, self.frame.size.height - 0.5)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor color_202020];
        [self addSubview:_titleLabel];

        _activityImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 32 - 15, (self.frame.size.height - 15) / 2, 15, 15)];
        [self addSubview:_activityImg];
        
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 7, (self.frame.size.height - 12) / 2, 7, 12)];
        _arrow.image = [UIImage imageNamed:@"arrow_right"];
        [self addSubview:_arrow];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
