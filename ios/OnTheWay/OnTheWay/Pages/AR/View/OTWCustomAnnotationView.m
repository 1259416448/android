//
//  OTWCustomAnnotationView.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWCustomAnnotationView.h"
#import "OTWARCustomAnnotation.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define OTWPrintArSpacing_15 15
#define OTWPrintArSpacing_10 10
#define OTWPrintArSpacing_7 7
#define OTWPrintArSpacing_6 6
#define OTWPrintArSpacing_3 3

@interface OTWCustomAnnotationView ()


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIView *titleBGV;

@property (nonatomic,strong) UIView *printARV;
@property (nonatomic,strong) UIImageView *printImageV;
@property (nonatomic,strong) UILabel *printTitleV;
@property (nonatomic,strong) UIImageView *printLocationImageV;
@property (nonatomic,strong) UILabel *printLocationNameV;
@property (nonatomic,strong) UIImageView *printDateImageV;
@property (nonatomic,strong) UILabel *printDateContentV;
@property (nonatomic,strong) UIImageView *printUserImageV;
@property (nonatomic) CGRect arFrame; // Just for test stacking

@end

@implementation OTWCustomAnnotationView

#pragma mark - override

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutUi];
}

- (void)bindUi
{
    if (self.annotaion) {
        //MCYARAnnotation *annotation = self.annotaion;
        OTWARCustomAnnotation *annotation = (OTWARCustomAnnotation*)self.annotaion;
//        NSString *title = self.annotaion.title;
//        DLog(@"annotaion.title__%@",title);
//        NSString *distance = annotation.distanceFromUser > 1000 ? [NSString stringWithFormat:@"%.1fkm", annotation.distanceFromUser / 1000] : [NSString stringWithFormat:@"%.0fm", annotation.distanceFromUser];
//        NSString *text = [NSString stringWithFormat:@"%@\nAZ: %.0f°\nDST: %@", title, annotation.azimuth, distance];
        
//        self.titleLabel.text = text;
        DLog(@"图片url地址-----%@",annotation.footprint.userHeadImg);
        [self.printImageV setImageWithURL:[NSURL URLWithString:annotation.footprint.footprintPhoto]];
        [self.printUserImageV setImageWithURL:[NSURL URLWithString:annotation.footprint.userHeadImg]];
        self.printTitleV.text = annotation.footprint.footprintContent;
        self.printLocationNameV.text = annotation.footprint.footprintAddress;
        self.printDateContentV.text = annotation.footprint.dateCreatedStr;
    }
}

- (void)initialize
{
    [super initialize];
    [self loadUi];
}

- (void)loadUi
{
    [self.printARV removeFromSuperview];
    [self addSubview:self.printARV];
    
//    [self.titleLabel removeFromSuperview];
    [self.printARV addSubview:self.printImageV];
    [self.printARV addSubview:self.printTitleV];
    [self.printARV addSubview:self.printLocationImageV];
    [self.printARV addSubview:self.printLocationNameV];
    [self.printARV addSubview:self.printDateImageV];
    [self.printARV addSubview:self.printDateContentV];
    [self.printARV addSubview:self.printUserImageV];
//    [self.infoButton removeFromSuperview];
//    [self addSubview:self.infoButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self addGestureRecognizer:tapGesture];
    
    self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    self.layer.cornerRadius = 5;
    
    if (self.annotaion != nil) {
        [self bindUi];
    }
}

- (void)layoutUi
{
    CGFloat buttonWidth = 40;
    CGFloat buttonHeight = 40;
    self.titleBGV.frame = CGRectMake(0, 0, self.frame.size.width - buttonWidth - 5, self.frame.size.height);
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width - buttonWidth - 5, self.frame.size.height);
    self.infoButton.frame = CGRectMake(self.frame.size.width - buttonWidth, self.frame.size.height / 2 - buttonHeight / 2, buttonWidth, buttonHeight);
    CGRect printARRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.printARV.frame = printARRect;
}

- (void)tapGesture
{
    if (self.annotaion != nil) {
        MCYARAnnotation *annotation = self.annotaion;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:annotation.title message:@"Tapped" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Setter

- (UIView*)titleBGV
{
    if (!_titleBGV) {
        _titleBGV = [[UIView alloc] init];
        _titleBGV.backgroundColor = [UIColor greenColor];
    }
    return _titleBGV;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return _titleLabel;
}

- (UIButton*)infoButton
{
    if (!_infoButton) {
        _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _infoButton.backgroundColor = [UIColor whiteColor];
        [_infoButton setUserInteractionEnabled:false];
    }
    
    return _infoButton;
}

- (UIView*)printARV
{
    if (!_printARV) {
        _printARV = [[UIView alloc] init];
        _printARV.backgroundColor = [UIColor whiteColor];
    }
    return _printARV;
}

-(UIImageView *)printImageV
{
    if (!_printImageV) {
        _printImageV = [[UIImageView alloc] init];
        CGFloat printImageX = OTWPrintArSpacing_6;
        CGFloat printImageY = OTWPrintArSpacing_6;
        CGRect printImageRect = CGRectMake(printImageX, printImageY, 30, 30);
        _printImageV.frame = printImageRect;
        [_printImageV setImageWithURL:[NSURL URLWithString:@"http://osx4pwgde.bkt.clouddn.com/c0ab21ab26b4694769b6e904788b3590630777.jpg"]];
    }
    return _printImageV;
}

-(UILabel *)printTitleV
{
    if (!_printTitleV) {
        _printTitleV = [[UILabel alloc] init];
        CGFloat printTitleX = CGRectGetMaxX(_printImageV.frame) + OTWPrintArSpacing_6;
        CGFloat printTitleY = OTWPrintArSpacing_6;
        CGRect printTitleRect = CGRectMake(printTitleX, printTitleY, 98, 15);
        _printTitleV.frame = printTitleRect;
        _printTitleV.text = @"看我搞笑的视频,保证不笑屎你";
        _printTitleV.textColor = [UIColor color_242424];
        _printTitleV.font = [UIFont systemFontOfSize:13];
    }
    return _printTitleV;
}

-(UIImageView *)printLocationImageV
{
    if (!_printLocationImageV) {
        _printLocationImageV = [[UIImageView alloc] init];
        CGFloat locationImageX = CGRectGetMaxX(_printImageV.frame) + OTWPrintArSpacing_6;
        CGFloat locationImageY = CGRectGetMaxY(_printTitleV.frame) + OTWPrintArSpacing_3;
        CGRect locationImageRect = CGRectMake(locationImageX, locationImageY, 10, 10);
        _printLocationImageV.frame = locationImageRect;
        [_printLocationImageV setImage:[UIImage imageNamed:@"dinwgei_2"]];
    }
    return _printLocationImageV;
}

-(UILabel *)printLocationNameV
{
    if (!_printLocationNameV) {
        _printLocationNameV = [[UILabel alloc] init];
        CGFloat printLocationImageX = CGRectGetMaxX(_printLocationImageV.frame) + OTWPrintArSpacing_3;
        CGFloat printLocationImageY = CGRectGetMaxY(_printTitleV.frame) + OTWPrintArSpacing_3;
        CGRect printLocationImageRect = CGRectMake(printLocationImageX, printLocationImageY, 34, 12);
        _printLocationNameV.frame = printLocationImageRect;
        _printLocationNameV.text = @"星巴克";
        _printLocationNameV.textColor = [UIColor color_979797];
        _printLocationNameV.font = [UIFont systemFontOfSize:11];
    }
    return _printLocationNameV;
}

-(UIImageView *)printDateImageV
{
    if (!_printDateImageV) {
        _printDateImageV = [[UIImageView alloc] init];
        CGFloat printDateImageX = CGRectGetMaxX(_printLocationNameV.frame) + 8;
        CGFloat printDateImageY = CGRectGetMaxY(_printTitleV.frame) + OTWPrintArSpacing_3;
        CGRect printDateImageRect = CGRectMake(printDateImageX, printDateImageY, 10, 10);
        _printDateImageV.frame = printDateImageRect;
        [_printDateImageV setImage:[UIImage imageNamed:@"shijian"]];
    }
    return _printDateImageV;
}

-(UILabel *)printDateContentV
{
    if (!_printDateContentV) {
        _printDateContentV = [[UILabel alloc] init];
        CGFloat printDateContentX = CGRectGetMaxX(_printDateImageV.frame) + OTWPrintArSpacing_3;
        CGFloat printDateContentY = CGRectGetMaxY(_printTitleV.frame) + OTWPrintArSpacing_3;
        CGRect printDateContentRect = CGRectMake(printDateContentX, printDateContentY, 44, 12);
        _printDateContentV.frame = printDateContentRect;
        _printDateContentV.text = @"2小时前";
        _printDateContentV.textColor = [UIColor color_979797];
        _printDateContentV.font = [UIFont systemFontOfSize:11];
    }
    return _printDateContentV;
}

-(UIImageView *)printUserImageV
{
    if (!_printUserImageV) {
        _printUserImageV = [[UIImageView alloc] init];
        CGFloat printUserImageX = 145;
        CGFloat printUserImageY = -10;
        CGRect printUserImageRect = CGRectMake(printUserImageX, printUserImageY, 30, 30);
        _printUserImageV.frame = printUserImageRect;
        [_printUserImageV setImageWithURL:[NSURL URLWithString:@"http://osx4pwgde.bkt.clouddn.com/c0ab21ab26b4694769b6e904788b3590630777.jpg"]];
        _printUserImageV.layer.cornerRadius = _printUserImageV.width/2.0;
        _printUserImageV.layer.masksToBounds = YES;
        struct CGPath *path = CGPathCreateMutable();
        CGPathAddArc(path, nil, 17 , 17, 17, 0, M_PI*2, true);
        _printUserImageV.layer.shadowPath = path;
    }
    return _printUserImageV;
}

@end
