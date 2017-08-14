//
//  OTWCustomAnnotationView.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWCustomAnnotationView.h"
#import "OTWARCustomAnnotation.h"
#import "OTWFootprintDetailController.h"
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

@property (nonatomic,strong) UIView *printBGView;
@property (nonatomic,strong) UIView *printARV;
@property (nonatomic,strong) UIImageView *printImageV;
@property (nonatomic,strong) UILabel *printTitleV;
@property (nonatomic,strong) UIImageView *printLocationImageV;
@property (nonatomic,strong) UILabel *printLocationNameV;
@property (nonatomic,strong) UIImageView *printDateImageV;
@property (nonatomic,strong) UILabel *printDateContentV;

@property (nonatomic,strong) UIView *printUserImageBGView;

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
//        NSString *title = self.annotaion.title;
//        DLog(@"annotaion.title__%@",title);
//        NSString *distance = annotation.distanceFromUser > 1000 ? [NSString stringWithFormat:@"%.1fkm", annotation.distanceFromUser / 1000] : [NSString stringWithFormat:@"%.0fm", annotation.distanceFromUser];
//        NSString *text = [NSString stringWithFormat:@"%@\nAZ: %.0f°\nDST: %@", title, annotation.azimuth, distance];
//        self.titleLabel.text = text;
        OTWARCustomAnnotation *annotation = (OTWARCustomAnnotation*)self.annotaion;
        [self setFrameByData:annotation.footprint];
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
    [self.printBGView addSubview:self.printImageV];
    [self.printBGView addSubview:self.printTitleV];
    [self.printBGView addSubview:self.printLocationImageV];
    [self.printBGView addSubview:self.printLocationNameV];
    [self.printBGView addSubview:self.printDateImageV];
    [self.printBGView addSubview:self.printDateContentV];
    [self addSubview:self.printUserImageBGView];
    [self.printUserImageBGView addSubview:self.printUserImageV];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self addGestureRecognizer:tapGesture];
    
    self.backgroundColor = [UIColor clearColor];
    
    if (self.annotaion != nil) {
        [self bindUi];
    }
}

- (void)layoutUi
{
    self.printARV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)tapGesture
{
    if (self.annotaion != nil) {
        OTWARCustomAnnotation *annotation = (OTWARCustomAnnotation*)self.annotaion;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:annotation.title message:@"Tapped" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        OTWFootprintDetailController *VC =  [[OTWFootprintDetailController alloc] init];
//        [VC setFid:annotation.footprint.footprintId.description];
//        [self.navigationController pushViewController:VC animated:YES];
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
    }
    return _printImageV;
}

-(UILabel *)printTitleV
{
    if (!_printTitleV) {
        _printTitleV = [[UILabel alloc] init];
        _printTitleV.textColor = [UIColor color_242424];
        _printTitleV.font = [UIFont systemFontOfSize:13];
    }
    return _printTitleV;
}

-(UIImageView *)printLocationImageV
{
    if (!_printLocationImageV) {
        _printLocationImageV = [[UIImageView alloc] init];
        [_printLocationImageV setImage:[UIImage imageNamed:@"dinwgei_2"]];
    }
    return _printLocationImageV;
}

-(UILabel *)printLocationNameV
{
    if (!_printLocationNameV) {
        _printLocationNameV = [[UILabel alloc] init];
        _printLocationNameV.textColor = [UIColor color_979797];
        _printLocationNameV.font = [UIFont systemFontOfSize:11];
    }
    return _printLocationNameV;
}

-(UIImageView *)printDateImageV
{
    if (!_printDateImageV) {
        _printDateImageV = [[UIImageView alloc] init];
        [_printDateImageV setImage:[UIImage imageNamed:@"shijian"]];
    }
    return _printDateImageV;
}

-(UILabel *)printDateContentV
{
    if (!_printDateContentV) {
        _printDateContentV = [[UILabel alloc] init];
        _printDateContentV.textColor = [UIColor color_979797];
        _printDateContentV.font = [UIFont systemFontOfSize:11];
    }
    return _printDateContentV;
}

-(UIImageView *)printUserImageV
{
    if (!_printUserImageV) {
        _printUserImageV = [[UIImageView alloc] init];
    }
    return _printUserImageV;
}

-(UIView *)printUserImageBGView
{
    if(!_printUserImageBGView){
        _printUserImageBGView = [[UIView alloc] init];
    }
    return _printUserImageBGView;
}

-(UIView *)printBGView
{
    if(!_printBGView){
        _printBGView = [[UIView alloc] init];
    }
    return _printBGView;
}

-(void)setFrameByData:(OTWFootprintListModel*)footprint
{
    BOOL bIsFootprintPhoto = footprint.footprintPhoto && ![footprint.footprintPhoto isEqualToString:@""];
    
    self.layer.shadowColor = [UIColor color_545454].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.printBGView.bounds].CGPath;
    
    self.printBGView.frame = CGRectMake(0, 0, self.Witdh, self.Height);
    self.printBGView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    self.printBGView.layer.cornerRadius = 3;
    self.printBGView.layer.masksToBounds = YES;
    
        //足迹显示图片
    if (bIsFootprintPhoto) {
        self.printImageV.hidden = NO;
        CGFloat printImageX = OTWPrintArSpacing_6;
        CGFloat printImageY = OTWPrintArSpacing_6;
        CGRect printImageRect = CGRectMake(printImageX, printImageY, 30, 30);
        self.printImageV.frame = printImageRect;
        self.printImageV.layer.cornerRadius = 2;
        self.printImageV.layer.masksToBounds = YES;
        [self.printImageV setImageWithURL:[NSURL URLWithString:[footprint.footprintPhoto stringByAppendingString:@"?imageView2/1/w/60/h/60"]]];
    } else{
        self.printImageV.hidden = YES;
    }
    
    //足迹标题
    if (bIsFootprintPhoto) {
        CGFloat printTitleX = CGRectGetMaxX(self.printImageV.frame) + OTWPrintArSpacing_6;
        CGFloat printTitleY = OTWPrintArSpacing_6;
        CGFloat printTitleW = self.frame.size.width - 60/2 - 6*2 - 30;
        CGRect printTitleRect = CGRectMake(printTitleX, printTitleY, printTitleW, 15);
        self.printTitleV.frame = printTitleRect;
    } else {
        CGFloat printTitleW = self.frame.size.width - 60/2 - 6*2;
        self.printTitleV.frame = CGRectMake(OTWPrintArSpacing_6, OTWPrintArSpacing_6, printTitleW, 15);
    }
    self.printTitleV.text = footprint.footprintContent;
    
    //定位
    CGFloat locationImageY = CGRectGetMaxY(self.printTitleV.frame) + OTWPrintArSpacing_3;
    if (bIsFootprintPhoto) {
        CGFloat locationImageX = CGRectGetMaxX(self.printImageV.frame) + OTWPrintArSpacing_6;
        self.printLocationImageV.frame = CGRectMake(locationImageX, locationImageY, 10, 10);
    } else {
        self.printLocationImageV.frame = CGRectMake(OTWPrintArSpacing_6, locationImageY, 10, 10);;
    }
    
    //定位名称
    CGFloat locationNameX = CGRectGetMaxX(self.printLocationImageV.frame) + OTWPrintArSpacing_3;
    CGFloat locationNameY = CGRectGetMaxY(self.printTitleV.frame) + OTWPrintArSpacing_3;
    CGFloat locationNameW = 0.0;
    if (bIsFootprintPhoto) {
        locationNameW = (self.frame.size.width - OTWPrintArSpacing_6*3 - OTWPrintArSpacing_3*2 - 8 - 30 - 15)/2;;
    }else{
        locationNameW = (self.frame.size.width - OTWPrintArSpacing_6*2 - OTWPrintArSpacing_3*2 - 8 - 15)/2;
    }
    self.printLocationNameV.frame = CGRectMake(locationNameX, locationNameY, locationNameW, 12);
    self.printLocationNameV.text = footprint.footprintAddress;
    
    //日期图标
    CGFloat printDateImageX = CGRectGetMaxX(self.printLocationNameV.frame) + 8;
    CGFloat printDateImageY = CGRectGetMaxY(self.printTitleV.frame) + OTWPrintArSpacing_3;
    self.printDateImageV.frame = CGRectMake(printDateImageX, printDateImageY, 10, 10);
    
    //日期字样
    CGFloat printDateContentX = CGRectGetMaxX(self.printDateImageV.frame) + OTWPrintArSpacing_3;
    CGFloat printDateContentY = CGRectGetMaxY(self.printTitleV.frame) + OTWPrintArSpacing_3;
    CGFloat printDateContentW = 0.0;
    if (bIsFootprintPhoto) {
        printDateContentW = (self.frame.size.width - OTWPrintArSpacing_6*3 - OTWPrintArSpacing_3*2 - 8 - 30 - 15)/2;
    }else{
        printDateContentW = (self.frame.size.width - OTWPrintArSpacing_6*2 - OTWPrintArSpacing_3*2 - 8 - 15)/2;
    }
    self.printDateContentV.frame = CGRectMake(printDateContentX, printDateContentY, printDateContentW, 12);
    self.printDateContentV.text = footprint.dateCreatedStr;
    
    //用户头像
    CGFloat printUserImageX = 145;
    CGFloat printUserImageY = -12;
    
    self.printUserImageBGView.frame = CGRectMake(printUserImageX, printUserImageY, 33, 33);
    self.printUserImageBGView.backgroundColor = [UIColor whiteColor];
    self.printUserImageBGView.layer.cornerRadius = self.printUserImageBGView.Witdh/2.0;
    //增加阴影
    struct CGPath *path = CGPathCreateMutable();
    CGPathAddArc(path, nil, 16.5 , 16.5, 16.5, 0, M_PI*2, true);
    self.printUserImageBGView.layer.shadowPath = path;
    self.printUserImageBGView.layer.shadowColor = [UIColor color_545454].CGColor;
    self.printUserImageBGView.layer.shadowOffset = CGSizeMake(0, 1);
    self.printUserImageBGView.layer.shadowOpacity = 0.3;
    
    
    self.printUserImageV.frame = CGRectMake(1.5, 1.5, 30, 30);
    [self.printUserImageV setImageWithURL:[NSURL URLWithString:footprint.userHeadImg]];
    self.printUserImageV.layer.cornerRadius = self.printUserImageV.width/2.0;
    self.printUserImageV.layer.masksToBounds = YES;
    
}

@end
