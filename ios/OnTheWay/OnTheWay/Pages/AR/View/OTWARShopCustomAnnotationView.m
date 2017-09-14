//
//  OTWARShopCustomAnnotationView.m
//  OnTheWay
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWARShopCustomAnnotationView.h"
#import "OTWBusinessARAnnotation.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OTWUtils.h"

#define OTWPrintArSpacing_15 15
#define OTWPrintArSpacing_10 10
#define OTWPrintArSpacing_7 7
#define OTWPrintArSpacing_6 6
#define OTWPrintArSpacing_3 3
#define shopNameFont [UIFont systemFontOfSize:14.0]

@interface OTWARShopCustomAnnotationView ()

@property (nonatomic,strong) UIView *printBGView;
@property (nonatomic,strong) UIView *shopColorV;
@property (nonatomic,strong) UILabel *shopTitleV;
@property (nonatomic,strong) UIView *distanceV;
@property (nonatomic,strong) UILabel *distanceContentV;
@property (nonatomic) CGRect arFrame; // Just for test stacking

@end

@implementation OTWARShopCustomAnnotationView

#pragma mark - override

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)bindUi
{
    if (self.annotaion) {
        OTWBusinessARAnnotation *annotation = (OTWBusinessARAnnotation*)self.annotaion;
        [self setFrameByData:annotation.arShop];
    }
}

- (void)initialize
{
    [super initialize];
    [self loadUi];
}

- (void)loadUi
{
    [self addSubview:self.printBGView];
    [self.shopColorV addSubview:self.shopTitleV];
    [self.printBGView addSubview:self.shopColorV];
    [self.distanceV addSubview:self.distanceContentV];
    [self.printBGView addSubview:self.distanceV];
    self.backgroundColor = [UIColor clearColor];
    
    if (self.annotaion != nil) {
        [self bindUi];
    }
}

#pragma mark - Setter
- (UIView *)shopColorV
{
    if (!_shopColorV) {
        _shopColorV = [[UIView alloc] init];
    }
    return _shopColorV;
}

-(UILabel *)shopTitleV
{
    if (!_shopTitleV) {
        _shopTitleV = [[UILabel alloc] init];
        _shopTitleV.textColor = [UIColor whiteColor];
        _shopTitleV.font = [UIFont systemFontOfSize:14];
    }
    return _shopTitleV;
}

- (UIView *)distanceV
{
    if (!_distanceV) {
        _distanceV = [[UIView alloc] init];
        _distanceV.backgroundColor = [UIColor whiteColor];
    }
    return _distanceV;
}

-(UILabel *)distanceContentV
{
    if (!_distanceContentV) {
        _distanceContentV = [[UILabel alloc] init];
        _distanceContentV.font = [UIFont systemFontOfSize:15];
    }
    return _distanceContentV;
}

-(UIView *)printBGView
{
    if(!_printBGView){
        _printBGView = [[UIView alloc] init];
    }
    return _printBGView;
}

-(void)setFrameByData:(OTWBusinessModel*)arShop
{
    
    CGSize shopSize = [OTWUtils sizeWithString:arShop.name font:shopNameFont maxSize:CGSizeMake(self.Witdh, 15)];
    self.shopTitleV.frame = CGRectMake(10, 10, shopSize.width, shopSize.height);
    self.shopTitleV.text = arShop.name;
    
    self.shopColorV.frame = CGRectMake(0, 0, CGRectGetMaxX(self.shopTitleV.frame) + 10, 35);
    if (arShop.colorCode && ![arShop.colorCode isEqualToString:@""]) {
        self.shopColorV.backgroundColor = [[UIColor colorWithHexString:arShop.colorCode] colorWithAlphaComponent:0.85];
    } else {
        self.shopColorV.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    }
    
    
    self.distanceV.frame = CGRectMake(CGRectGetMaxX(self.shopColorV.frame), 0, 65, 35);
    self.distanceContentV.frame = CGRectMake(10, 10, 45, 15);
    self.distanceContentV.textAlignment = NSTextAlignmentCenter;
    self.distanceContentV.textColor = [UIColor colorWithHexString:arShop.colorCode];
    self.distanceContentV.text = [NSString stringWithFormat:@"%.0fm",self.annotaion.distanceFromUser];
    
    self.frame = CGRectMake(0, 0, CGRectGetMaxX(self.distanceV.frame), self.Height);
    self.printBGView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.distanceV.frame), self.Height);
    self.printBGView.backgroundColor = [UIColor clearColor];
    self.printBGView.layer.cornerRadius = 3;
    self.printBGView.layer.masksToBounds = YES;
    
}

@end
