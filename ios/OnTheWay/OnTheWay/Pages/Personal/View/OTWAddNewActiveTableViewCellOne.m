//
//  OTWAddNewActiveTableViewCellOne.m
//  OnTheWay
//
//  Created by apple on 2017/10/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWAddNewActiveTableViewCellOne.h"

@implementation OTWAddNewActiveTableViewCellOne

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
        
        _detailTF = [[UITextField alloc] initWithFrame:CGRectMake(130, 0, SCREEN_WIDTH - 15 - 130, self.frame.size.height - 0.5)];
        _detailTF.textAlignment = NSTextAlignmentRight;
        _detailTF.font = [UIFont systemFontOfSize:14];
        _detailTF.textColor = UIColorFromRGB(0x979797);
        [self addSubview:_detailTF];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
