//
//  OTWBusinessActivityIconView.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/4.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessActivityIconView.h"

@interface OTWBusinessActivityIconView ()

@property (nonatomic,strong) UIView *nameBGView;

@property (nonatomic,strong) UIImageView *nameBGImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation OTWBusinessActivityIconView

+(instancetype _Nonnull ) initWithName:(NSString * _Nonnull)name color:( UIColor * _Nonnull ) color
{
    OTWBusinessActivityIconView *view =  [[OTWBusinessActivityIconView alloc] init];
    view.name = name;
    view.color = color;
    [view buildUI];
    return view;
    
}

- (void) buildUI
{
    [self addSubview:self.nameBGView];
    [self.nameBGView addSubview:self.nameBGImageView];
    [self.nameBGView addSubview:self.nameLabel];
}

- (void) setName:(NSString *_Nonnull)name color:(UIColor *_Nonnull) color
{
    //self.nameBGView.backgroundColor = color;
    self.nameBGImageView.image = [UIImage imageWithColor:color size:CGSizeMake(15, 15)];
    self.nameLabel.text = name;
}

- (UIView *) nameBGView
{
    if(!_nameBGView){
        _nameBGView = [[UIView alloc] init];
        //_nameBGView.backgroundColor = self.color;
        _nameBGView.frame = CGRectMake(0, 0, 15, 15);
    }
    return _nameBGView;
}

- (UILabel *) nameLabel
{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = self.name;
        _nameLabel.frame = self.nameBGView.bounds;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIImageView *) nameBGImageView
{
    if(!_nameBGImageView){
        _nameBGImageView = [[UIImageView alloc] init];
        _nameBGImageView.frame = self.nameBGView.bounds;
        _nameBGImageView.image = [UIImage imageWithColor:self.color size:CGSizeMake(15, 15)];
    }
    return _nameBGImageView;
}

@end
