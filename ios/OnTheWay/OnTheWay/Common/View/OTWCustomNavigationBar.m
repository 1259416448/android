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

@end

@implementation OTWCustomNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.1;
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
    self.titleLabel.frame = CGRectMake(xOff, 33, width, 20);
}

- (void)setLeftImage:(UIImage *)leftImage {
    if (_leftButton) {
        [_leftButton removeFromSuperview];
    }
    [self.leftButton setImage:leftImage forState:UIControlStateNormal];
    [self addSubview:self.leftButton];
    //CGFloat wid = leftImage.size.width;
    //CGFloat hei = leftImage.size.height;
    
    self.leftButton.frame = CGRectMake(0, 20, 15 + 10 + 10 , 44);
    self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 15, 12, 10);
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
    self.rightButton.frame = CGRectMake(SCREEN_WIDTH - width - 18, 30, width + 10, 22.5);
    
}

- (void)setLeftTitle:(NSString *)leftTitle {
    if (_leftButton) {
        [_leftButton removeFromSuperview];
    }
    
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [self addSubview:self.leftButton];
    
    CGFloat width = [leftTitle sizeWithFont:self.leftButton.titleLabel.font].width;
    self.rightButton.frame = CGRectMake(13.5, 31, width, 16);
}

#pragma mark public method


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.backgroungImageView.backgroundColor = backgroundColor;
}

- (void)setBackgroundImage:(UIImage *)image {
    self.backgroungImageView.image = image;
}

- (void)setLeftView:(UIView *)leftView {
    CGFloat yOff = 20 - (leftView.Height - 44)/2;
    yOff = fmaxf(yOff, 0);
    leftView.frame = CGRectMake(13.5, yOff, leftView.Witdh, leftView.Height);
    [self addSubview:leftView];
    
}

- (void)setRightView:(UIView *)rightView {
    CGFloat yOff = 20 - (rightView.Height - 44)/2;
    yOff = fmaxf(yOff, 0);
    //CGFloat xoff = self.Witdh - rightView.Witdh - 17.5;
    //xoff = fmaxf(xoff, 0);
    rightView.frame = CGRectMake(rightView.MinX, yOff, rightView.Witdh, rightView.Height);
    [self addSubview:rightView];
}

- (void)setTitleView:(UIView *)titleView {
    CGFloat yOff = 20 - (titleView.Height - 44)/2;
    yOff = fmaxf(yOff, 0);
    CGFloat xoff = (self.Witdh - titleView.Witdh)/2;
    titleView.frame = CGRectMake(xoff, yOff, titleView.Witdh, titleView.Height);
    [self addSubview:titleView];
}

#pragma mark UI
- (void)buildUI {
    _backgroungImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroungImageView.backgroundColor = [UIColor clearColor];
    //_backgroungImageView.image = [UIImage imageNamed:@"wd_bg"];
    //_backgroungImageView.contentMode = UIViewContentModeTop;
    _backgroungImageView.clipsToBounds  = YES;
    [self addSubview:_backgroungImageView];
}

- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _titleLabel.textColor = [UIColor color_202020];
    }
    return _titleLabel;
}

- (UIButton*)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonClickedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton*)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightButton setTitleColor:[UIColor color_e50834] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClickedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (void) clearShadowColor
{
    self.layer.shadowColor = [UIColor clearColor].CGColor;
}

- (void) setNavigationBarFrame:(CGRect) frame
{
    self.frame = frame;
    self.backgroungImageView.frame = self.bounds;
}

@end
