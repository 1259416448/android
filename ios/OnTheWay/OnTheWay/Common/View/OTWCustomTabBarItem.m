//
//  OTWCustomTabBarItem.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/11.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWCustomTabBarItem.h"

static NSInteger defaultTag = 10000;

@interface OTWCustomTabBarItem ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation OTWCustomTabBarItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick)];
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
}

#pragma mrak - Action

- (void)itemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarItem:didSelectIndex:)]) {
        [self.delegate tabBarItem:self didSelectIndex:self.tag - defaultTag];
    }
}

#pragma mark - 

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag + defaultTag];
}

#pragma mark - Getter & Setter

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor grayColor];
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UIImageView*)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImageView];
    }
    
    return _iconImageView;
}

- (void)setIcon:(NSString *)icon
{
    _icon = icon;
    
    self.iconImageView.image = [UIImage imageNamed:icon];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    
    self.titleLabel.textColor = titleColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat space = 6.0;
    
    switch (self.type) {
        case OTWTabBarItemTypeDefault: {
            
            CGFloat iconHeight = (CGRectGetHeight(self.frame) - space * 3)*2/3.0 ;
            self.iconImageView.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2 * space, iconHeight);
            self.titleLabel.frame = CGRectMake(space, CGRectGetMaxY(self.iconImageView.frame) + space, CGRectGetWidth(self.frame) - 2*space, iconHeight/2.0);
        }
            break;
        case OTWTabBarItemTypeImage: {
            
            self.iconImageView.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2*space, CGRectGetHeight(self.frame) - 2*space);
        }
            break;
        case OTWTabBarItemTypeText: {
            
            self.titleLabel.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2*space, CGRectGetHeight(self.frame) - 2*space);
        }
            break;
        case OTWTabBarItemTypeImageFlow: {
            self.iconImageView.frame = CGRectMake(0, -space, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
            break;
        default:
            break;
    }
}

@end
