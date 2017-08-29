//
//  OTWNotFundFootprintView.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNotFundFootprintView.h"

@interface OTWNotFundFootprintView()

@property (nonatomic,strong) UIImageView *notFundImageView;
@property (nonatomic,strong) UILabel *notFundLabel;
@property (nonatomic,strong) UIButton *jumpReleaseButton;

@end

@implementation OTWNotFundFootprintView

+ (instancetype) initWithIfMy:(Boolean) ifMy
{
    OTWNotFundFootprintView *view = [[OTWNotFundFootprintView alloc] init];
    view.ifMy = ifMy;
    [view buildUI];
    return view;
}

- (void) buildUI
{
    self.frame = CGRectMake(0, 266, SCREEN_WIDTH, SCREEN_HEIGHT - 266);
    [self addSubview:self.notFundImageView];
    [self addSubview:self.notFundLabel];
    if(self.ifMy){
      [self addSubview:self.jumpReleaseButton];
    }
}

#pragma mark - Setter Getter

- (UIImageView *) notFundImageView
{
    if(!_notFundImageView){
        CGFloat notFundImageViewX = (SCREEN_WIDTH - 145)/2 ;
        CGFloat notFundImageViewY = (self.Height - 115 ) / 2;
        //判断一下是否能全部显示
        CGFloat sumH = 115 + 20 + 42 + 50 + 44;
        CGFloat maxH = (SCREEN_HEIGHT - sumH)/2;
        if(notFundImageViewY > maxH){
            notFundImageViewY = maxH;
        }
        notFundImageViewY = 20;
        _notFundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(notFundImageViewX,notFundImageViewY, 145, 115)];
        _notFundImageView.image = [UIImage imageNamed:@"qx_wuzuji"];
    }
    return _notFundImageView;
}

- (UILabel *) notFundLabel
{
    if(!_notFundLabel){
        _notFundLabel =[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 117)/2, self.notFundImageView.MaxY + 20 , 117, 42)];
        _notFundLabel.text = @"太低调了\n竟然一条足迹都没有";
        _notFundLabel.numberOfLines = 0;
        _notFundLabel.textColor = [UIColor color_979797];
        _notFundLabel.textAlignment = NSTextAlignmentCenter;
        _notFundLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    }
    return _notFundLabel;
}

- (UIButton *) jumpReleaseButton
{
    if(!_jumpReleaseButton){
        _jumpReleaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _jumpReleaseButton.frame = CGRectMake( (SCREEN_WIDTH - 200)/2 ,self.notFundLabel.MaxY + 50, 200 , 44);
        _jumpReleaseButton.backgroundColor = [UIColor color_e50834];
        [_jumpReleaseButton setTitle:@"立即发布足迹" forState:UIControlStateNormal];
        [_jumpReleaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_jumpReleaseButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        _jumpReleaseButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        _jumpReleaseButton.layer.cornerRadius = 3;
    }
    return _jumpReleaseButton;
}

- (void) buttonClicked
{
    if(self.block){
        self.block();
    }
}


@end
