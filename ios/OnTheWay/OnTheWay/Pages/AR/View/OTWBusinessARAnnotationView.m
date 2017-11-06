//
//  OTWARShopCustomAnnotationView.m
//  OnTheWay
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessARAnnotationView.h"
#import "OTWBusinessARAnnotation.h"

#define OTWPrintArSpacing_15 15
#define OTWPrintArSpacing_10 10
#define OTWPrintArSpacing_7 7
#define OTWPrintArSpacing_6 6
#define OTWPrintArSpacing_3 3
#define shopNameFont [UIFont systemFontOfSize:14.0]

@interface OTWBusinessARAnnotationView ()

@property (nonatomic,strong) UIView *printBGView;
@property (nonatomic,strong) UIView *shopColorV;
@property (nonatomic,strong) UILabel *shopTitleV;
@property (nonatomic,strong) UIView *distanceV;
@property (nonatomic,strong) UILabel *distanceContentV;
@property (nonatomic) CGRect arFrame; // Just for test stacking

@end

@implementation OTWBusinessARAnnotationView

#pragma mark - override

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)bindUi
{
    if (self.annotaion) {
        OTWBusinessARAnnotation *annotation = (OTWBusinessARAnnotation*)self.annotaion;
        [self setFrameByData:annotation.businessFrame];
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
    [self.printBGView addSubview:self.distanceV];
    [self.distanceV addSubview:self.distanceContentV];
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
        _shopTitleV.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _shopTitleV;
}

- (UIView *)distanceV
{
    if (!_distanceV) {
        _distanceV = [[UIView alloc] init];
    }
    return _distanceV;
}

-(UILabel *)distanceContentV
{
    if (!_distanceContentV) {
        _distanceContentV = [[UILabel alloc] init];
        _distanceContentV.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
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

-(void)setFrameByData:(OTWBusinessARAnnotationFrame*)businessFrame
{
    self.shopTitleV.frame = CGRectMake(10, 10, businessFrame.contentW, 15);
    self.shopTitleV.text = businessFrame.businessDetail.name;
    
    self.shopColorV.frame = CGRectMake(0, 0, businessFrame.contentW + 10 * 2, 35);
    if (businessFrame.businessDetail.colorCode && ![businessFrame.businessDetail.colorCode isEqualToString:@""]) {
        self.shopColorV.backgroundColor = [[UIColor colorWithHexString:businessFrame.businessDetail.colorCode] colorWithAlphaComponent:businessFrame.colorAlpha];
    } else {
        self.shopColorV.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:businessFrame.colorAlpha];
    }
    
    self.distanceContentV.frame = CGRectMake(10, 9.5, 45, 15);
    self.distanceContentV.textAlignment = NSTextAlignmentCenter;
    self.distanceContentV.textColor = [UIColor colorWithHexString:businessFrame.businessDetail.colorCode];
    self.distanceContentV.text = [NSString stringWithFormat:@"%.0fm",self.annotaion.distanceFromUser];
    [self.distanceContentV sizeToFit];
    self.distanceV.frame = CGRectMake(self.shopColorV.MaxX, 0, self.distanceContentV.Witdh + 20 , 35);
    self.distanceV.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:businessFrame.distanceAlpha];
    
    self.printBGView.frame = CGRectMake(0, 0, self.distanceV.MaxX, self.Height);
    self.printBGView.backgroundColor = [UIColor clearColor];
    self.printBGView.layer.cornerRadius = 3;
    self.printBGView.layer.masksToBounds = YES;
    
}

- (void) setShopColorVBackGroup
{
    OTWBusinessARAnnotation *businessAnnotation = (OTWBusinessARAnnotation *) self.annotaion;
    self.shopColorV.backgroundColor = [[UIColor colorWithHexString:businessAnnotation.businessFrame.businessDetail.colorCode] colorWithAlphaComponent:businessAnnotation.businessFrame.colorAlpha];
    self.distanceV.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:businessAnnotation.businessFrame.distanceAlpha];
}

@end
