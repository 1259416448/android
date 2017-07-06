//
//  OTWCustomNavigationBar.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWCustomNavigationBar.h"

@interface OTWCustomNavigationBar ()
{
    
}

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIImageView * backgroungImageView;
@property (nonatomic,strong) UIView *underLineView;

@end

@implementation OTWCustomNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self buildUI];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

#pragma mark private methd
- (void)leftButtonClickedAction {
    if (self.leftButtonClicked) {
        self.leftButtonClicked();
    }
}

- (void)rightButtonClickedAction {
    if (self.rightButtonClicked) {
        self.rightButtonClicked();
    }
}

#pragma mark property

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self addSubview:self.titleLabel];
    CGFloat width = [title sizeWithFont:self.titleLabel.font].width;
    CGFloat xOff = (self.Witdh - width)/2;
    self.titleLabel.frame = CGRectMake(xOff, 36.5, width, 20);
}

- (void)setLeftImage:(UIImage *)leftImage {
    if (_leftButton) {
        [_leftButton removeFromSuperview];
    }
    [self.leftButton setImage:leftImage forState:UIControlStateNormal];
    [self addSubview:self.leftButton];
    CGFloat wid = leftImage.size.width;
    CGFloat hei = leftImage.size.height;
    
    self.leftButton.frame = CGRectMake(0, 39, wid + 23.5 , hei + 6);
    self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(3, 13.5, 3, 10);
}

- (void)setRightImage:(UIImage *)rightImage {
    if (_rightButton) {
        [_rightButton removeFromSuperview];
    }
    [self.rightButton setImage:rightImage forState:UIControlStateNormal];
    [self addSubview:self.rightButton];
    CGFloat wid = rightImage.size.width;
    CGFloat hei = rightImage.size.height;
    
    self.rightButton.frame = CGRectMake(self.Witdh - 27.5 - wid, 39, wid + 23.5, hei + 6);
    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(3, 10, 3, 17.5);
}

- (void)setRightTitle:(NSString *)rightTitle {
    if (_rightButton) {
        [_rightButton removeFromSuperview];
    }
    
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [self addSubview:self.rightButton];
    
    CGFloat width = [rightTitle sizeWithFont:self.rightButton.titleLabel.font].width;
    self.rightButton.frame = CGRectMake(self.Witdh - width - 17.5, 40, width + 17.5, 16);
    
}

- (void)setLeftTitle:(NSString *)leftTitle {
    if (_leftButton) {
        [_leftButton removeFromSuperview];
    }
    
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [self addSubview:self.leftButton];
    
    CGFloat width = [leftTitle sizeWithFont:self.leftButton.titleLabel.font].width;
    self.rightButton.frame = CGRectMake(13.5, 40, width, 16);
}

#pragma mark public method


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.backgroungImageView.backgroundColor = backgroundColor;
    self.underLineView.backgroundColor = backgroundColor;
}

- (void)setBackgroundImage:(UIImage *)image {
    self.backgroungImageView.image = image;
}

- (void)setLeftView:(UIView *)leftView {
    CGFloat yOff = 20 - (leftView.Height - 55)/2;
    yOff = fmaxf(yOff, 0);
    leftView.frame = CGRectMake(13.5, yOff, leftView.Witdh, leftView.Height);
    [self addSubview:leftView];
    
}

- (void)setRightView:(UIView *)rightView {
    CGFloat yOff = 20 - (rightView.Height - 55)/2;
    yOff = fmaxf(yOff, 0);
    CGFloat xoff = self.Witdh - rightView.Witdh - 17.5;
    xoff = fmaxf(xoff, 0);
    rightView.frame = CGRectMake(xoff, yOff, rightView.Witdh, rightView.Height);
    [self addSubview:rightView];
}

- (void)setTitleView:(UIView *)titleView {
    CGFloat yOff = 20 - (titleView.Height - 55)/2;
    yOff = fmaxf(yOff, 0);
    CGFloat xoff = (self.Witdh - titleView.Witdh)/2;
    titleView.frame = CGRectMake(xoff, yOff, titleView.Witdh, titleView.Height);
    [self addSubview:titleView];
}

#pragma mark UI
- (void)buildUI {
    _backgroungImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroungImageView.backgroundColor = [UIColor color_22b2e7];
    [self addSubview:_backgroungImageView];
    
    _underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 74.5, self.Witdh, 0.5)];
    _underLineView.backgroundColor = [UIColor color_22b2e7];
    [self addSubview:_underLineView];
}

- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton*)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonClickedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton*)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClickedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end
