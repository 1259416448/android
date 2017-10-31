//
//  OTWAddNewActiveTableViewCellFour.m
//  OnTheWay
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWAddNewActiveTableViewCellFour.h"

@interface OTWAddNewActiveTableViewCellFour ()<UITextViewDelegate>

@end

@implementation OTWAddNewActiveTableViewCellFour

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
        
        _contentBackView = [[UIView alloc] initWithFrame:CGRectMake(15, 50, SCREEN_WIDTH - 30, 120)];
        _contentTextView.backgroundColor = [UIColor whiteColor];
        _contentBackView.layer.masksToBounds = YES;
        _contentBackView.layer.borderWidth = 0.5;
        _contentBackView.layer.borderColor = [UIColor color_d5d5d5].CGColor;
        _contentBackView.layer.cornerRadius = 3;
        [self addSubview:_contentBackView];
        
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 18, SCREEN_WIDTH - 60, 84)];
        _contentTextView.delegate = self;
        _contentTextView.font = [UIFont systemFontOfSize:13];
        _contentTextView.text = @"介绍下您的活动吧~";
        _contentTextView.textColor = [UIColor color_979797];
        [_contentBackView addSubview:_contentTextView];
        
        UIView * downLine = [[UIView alloc] initWithFrame:CGRectMake(0, 184.5, SCREEN_WIDTH, 0.5)];
        downLine.backgroundColor = [UIColor color_d5d5d5];
        [self addSubview:downLine];
    }
    return self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"介绍下您的活动吧~"]) {
        textView.text = @"";
        textView.textColor = [UIColor color_202020];
    }else{
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"介绍下您的活动吧~";
        textView.textColor = [UIColor color_979797];
    }else{
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
