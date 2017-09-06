//
//  OTWBusinessActivityTableViewCell.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/5.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessActivityTableViewCell.h"
#import "OTWBusinessActivityIconView.h"

@interface OTWBusinessActivityTableViewCell ()

//左侧图标
@property (nonatomic,strong) OTWBusinessActivityIconView *iconView;
//中间名称
@property (nonatomic,strong) UILabel *nameLabel;
//左侧图标
@property (nonatomic,strong) UIImageView *rightImageView;
//底部线
@property (nonatomic,strong) UIView *bottomLine;

@end

@implementation OTWBusinessActivityTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *) identifier
{
    return [[OTWBusinessActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self buildUI];
    }
    return self;
}

- (void) buildUI
{
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.rightImageView];
    [self addSubview:self.bottomLine];
}

- (void) setDate:(NSString *)activityName typeName:(NSString *)typeName typeColor:(UIColor *)typeColor isLast:(BOOL)isLast
{
    self.nameLabel.text = activityName;
    [self.iconView setName:typeName color:typeColor];
    if(isLast){
        self.bottomLine.hidden = YES;
    }else{
        self.bottomLine.hidden = NO;
    }
}

#pragma mark - Setter Getter

- (OTWBusinessActivityIconView *) iconView
{
    if(!_iconView){
        _iconView = [OTWBusinessActivityIconView initWithName:@"券" color:[UIColor color_ff5959]];
        _iconView.frame = CGRectMake(GLOBAL_PADDING, 12.5, 15, 15);
    }
    return _iconView;
}

- (UILabel *) nameLabel
{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _nameLabel.textColor = [UIColor color_757575];
        _nameLabel.frame = CGRectMake(self.iconView.MaxX +10, 10,SCREEN_WIDTH - self.iconView.MaxX - 10 - 30, 20);
    }
    return _nameLabel;
}

- (UIImageView *) rightImageView
{
    if(!_rightImageView){
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"arrow_right"];
        _rightImageView.frame = CGRectMake(SCREEN_WIDTH - GLOBAL_PADDING - 7, 15, 7, 12);
    }
    return _rightImageView;
}

- (UIView *) bottomLine
{
    if(!_bottomLine){
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor color_d5d5d5];
        _bottomLine.frame = CGRectMake(GLOBAL_PADDING , 39.5, SCREEN_WIDTH - GLOBAL_PADDING, 0.5);
    }
    return _bottomLine;
}

@end
