//
//  BottomSheetDemoViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "BottomSheetDemoViewController.h"
#import <STPopup.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OTWUITapGestureRecognizer.h"
#import <MJExtension.h>
#import <STPopup.h>

#define OTWPrintArSpacing_15 15
#define OTWPrintArSpacing_10 10
#define OTWPrintArSpacing_6 6
#define OTWPrintArSpacing_3 3

#define OTWUserNameFontSize [UIFont systemFontOfSize:15]

@interface BottomSheetDemoViewController ()

@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UIView *shapeBG;
@property(nonatomic,strong) UIImageView *userImageV;
@property(nonatomic,strong) UILabel *userNameV;
@property(nonatomic,strong) UIView *underLineOneView;
@property(nonatomic,strong) UIImageView *locationV;
@property(nonatomic,strong) UILabel *locationNameV;
@property(nonatomic,strong) UIImageView *dateV;
@property(nonatomic,strong) UILabel *dateNameV;
@property(nonatomic,strong) UIButton *detailButtonV;

@property(nonatomic,strong) UILabel *footPrintContent;

@end

@implementation BottomSheetDemoViewController

- (instancetype)init
{
    if (self = [super init]) {
//        self.contentSizeInPopup = CGSizeMake(self.view.width, 357);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.shapeBG addSubview:self.userImageV];
    [self.shapeBG addSubview:self.userNameV];
    [self.shapeBG addSubview:self.underLineOneView];
    [self.shapeBG addSubview:self.footPrintContent];
    [self.shapeBG addSubview:self.locationV];
    [self.shapeBG addSubview:self.locationNameV];
    [self.shapeBG addSubview:self.dateV];
    [self.shapeBG addSubview:self.dateNameV];
    [self.shapeBG addSubview:self.detailButtonV];
    [self.view addSubview:self.shapeBG];
}

-(void)setFootprint:(OTWFootprintListModel *)footprint
{
    _footprint = footprint;

    //view容器
    CGFloat shapeBGH = 312;
    if (_footprint.footprintPhotoArray.count == 0) {
        shapeBGH = 312 - (SCREEN_WIDTH - OTWPrintArSpacing_15*2 - OTWPrintArSpacing_6*2)/3.0*80/111 - OTWPrintArSpacing_10;
    }
    self.contentSizeInPopup = CGSizeMake(self.view.width, shapeBGH + 45);
    self.shapeBG.frame = CGRectMake(0, 45, self.view.width, shapeBGH);
    //设置用户头像
    [self.userImageV setImageWithURL:[NSURL URLWithString:_footprint.userHeadImg]];
    
    //设置用户名
    CGFloat userNameX = OTWPrintArSpacing_15;
    CGFloat userNameY = CGRectGetMaxY(self.userImageV.frame) + OTWPrintArSpacing_10;
    CGFloat userNameW = SCREEN_WIDTH - OTWPrintArSpacing_15*2;
    CGSize userNameSize = [_footprint.userNickname boundingRectWithSize:CGSizeMake(userNameW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    CGRect userNameRect = CGRectMake(userNameX, userNameY, userNameW, userNameSize.height);
    self.userNameV.frame = userNameRect;
    self.userNameV.text = _footprint.userNickname;
    
    //间隔线
    CGFloat lineVY = CGRectGetMaxY(self.userNameV.frame) + OTWPrintArSpacing_15;
    self.underLineOneView.frame = CGRectMake(0, lineVY, SCREEN_WIDTH, 0.5);
    
    //设置足迹内容
    CGFloat footPrintContentX = OTWPrintArSpacing_15;
    CGFloat footPrintContentY = 0.0;
    if (_footprint.footprintPhotoArray.count > 0) {
        footPrintContentY = CGRectGetMaxY(self.underLineOneView.frame) + (SCREEN_WIDTH - OTWPrintArSpacing_15*2 - OTWPrintArSpacing_6*2)/3.0*80/111 + OTWPrintArSpacing_15 + OTWPrintArSpacing_10;
    } else {
        footPrintContentY = CGRectGetMaxY(self.underLineOneView.frame) + OTWPrintArSpacing_10;
    }
    CGFloat footPrintContentW = SCREEN_WIDTH - OTWPrintArSpacing_15*2;
    CGRect footPrintContentRect = CGRectMake(footPrintContentX, footPrintContentY, footPrintContentW, 42);
    self.footPrintContent.frame = footPrintContentRect;
    self.footPrintContent.text = _footprint.footprintContent;
    
    //地理位置图标
    CGFloat locationVY = CGRectGetMaxY(self.footPrintContent.frame) + OTWPrintArSpacing_6;
    self.locationV.frame = CGRectMake(15, locationVY, 10, 10);
    
    //地理位置
    CGFloat locationNameX = CGRectGetMaxX(self.locationV.frame) + OTWPrintArSpacing_3;
    CGFloat locationNameY = CGRectGetMaxY(self.footPrintContent.frame) + OTWPrintArSpacing_6;
    self.locationNameV.frame = CGRectMake(locationNameX, locationNameY, SCREEN_WIDTH/2, 12);
    self.locationNameV.text = _footprint.footprintAddress;
    
    //时间图标
    CGFloat dateVX = SCREEN_WIDTH - 70;
    CGFloat dateVY = CGRectGetMaxY(self.footPrintContent.frame) + OTWPrintArSpacing_6;
    self.dateV.frame = CGRectMake(dateVX, dateVY, 10, 10);
    
    //发布时间
    CGFloat dateNameX = CGRectGetMaxX(self.dateV.frame) + OTWPrintArSpacing_3;
    CGFloat dateNameY = CGRectGetMaxY(self.footPrintContent.frame) + OTWPrintArSpacing_6;
    self.dateNameV.frame = CGRectMake(dateNameX, dateNameY, 45, 12);
    self.dateNameV.text = _footprint.dateCreatedStr;
    
    //查看详情按钮
    CGFloat detailButtonY = self.shapeBG.frame.size.height  - 38.5;
    CGRect detailButtonRect = CGRectMake(0, detailButtonY, SCREEN_WIDTH, 38.5);
    self.detailButtonV.frame = detailButtonRect;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToFootprintDetail)];
    [self.detailButtonV addGestureRecognizer: tapGesture];
    [self createImageV:footprint];
    
}

#pragma mark 跳转到足迹详情
-(void)jumpToFootprintDetail
{
    [self.popupController dismiss];
    OTWFootprintDetailController *VC =  [[OTWFootprintDetailController alloc] init];
    [VC setFid:_footprint.footprintId.description];
    [self.mapController.navigationController pushViewController:VC animated:YES];

}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _label.frame = CGRectMake(20, 10, self.view.frame.size.width - 40, self.view.frame.size.height - 20);
}

- (UIView *)shapeBG
{
    if (!_shapeBG) {
        _shapeBG = [[UIView alloc] init];
        _shapeBG.backgroundColor = [UIColor whiteColor];
    }
    return _shapeBG;
}

- (UIImageView *)userImageV
{
    if (!_userImageV) {
        _userImageV = [[UIImageView alloc] init];
        CGRect userImageRect = CGRectMake(SCREEN_WIDTH/2.0 - 45, -45, 90, 90);
        _userImageV.frame = userImageRect;
        _userImageV.layer.cornerRadius = _userImageV.width/2.0;
        _userImageV.layer.masksToBounds = YES;
        struct CGPath *path = CGPathCreateMutable();
        CGPathAddArc(path, nil, 17 , 17, 17, 0, M_PI*2, true);
        _userImageV.layer.shadowPath = path;
    }
    return _userImageV;
}
- (UILabel *)userNameV
{
    if (!_userNameV) {
        _userNameV = [[UILabel alloc] init];
        _userNameV.textColor = [UIColor color_757575];
        _userNameV.font = [UIFont systemFontOfSize:15];
        _userNameV.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameV;
}

- (UILabel *)footPrintContent
{
    if (!_footPrintContent) {
        _footPrintContent = [[UILabel alloc] init];
        _footPrintContent.textColor = [UIColor color_202020];
        _footPrintContent.font = [UIFont systemFontOfSize:16];
        _footPrintContent.numberOfLines = 0;
    }
    return _footPrintContent;
}

-(UIView*)underLineOneView{
    if(!_underLineOneView){
        _underLineOneView = [[UIView alloc] init];
        _underLineOneView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineOneView;
}

-(UIImageView *)locationV
{
    if (!_locationV) {
        _locationV = [[UIImageView alloc] init];
        [_locationV setImage:[UIImage imageNamed:@"dinwgei_2"]];
    }
    return _locationV;
}

-(UILabel *)locationNameV
{
    if (!_locationNameV) {
        _locationNameV = [[UILabel alloc] init];
        _locationNameV.textColor = [UIColor color_979797];
        _locationNameV.font = [UIFont systemFontOfSize:11];
    }
    return _locationNameV;
}

-(UIImageView *)dateV
{
    if (!_dateV) {
        _dateV = [[UIImageView alloc] init];
        [_dateV setImage:[UIImage imageNamed:@"shijian"]];
    }
    return _dateV;
}

-(UILabel *)dateNameV
{
    if (!_dateNameV) {
        _dateNameV = [[UILabel alloc] init];
        _dateNameV.textColor = [UIColor color_979797];
        _dateNameV.font = [UIFont systemFontOfSize:11];
    }
    return _dateNameV;
}

- (UIButton *)detailButtonV
{
    if (!_detailButtonV) {
        _detailButtonV = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButtonV.backgroundColor = [UIColor color_f4f4f4];
        //button 文字居中显示
        _detailButtonV.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _detailButtonV.titleLabel.font = [UIFont systemFontOfSize:13];
        [_detailButtonV setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailButtonV setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
    }
    return _detailButtonV;
}

-(void)createImageV:(OTWFootprintListModel*)footprint
{
    if (footprint.footprintPhotoArray.count == 0) {
        return;
    }
    CGFloat imageW = (SCREEN_WIDTH - OTWPrintArSpacing_15*2 - OTWPrintArSpacing_6*2)/3.0;
    CGFloat imageH = imageW*80/111;
    CGFloat imageY = CGRectGetMaxY(_underLineOneView.frame) + OTWPrintArSpacing_15;
    for (int index = 0; index < footprint.footprintPhotoArray.count; index++) {
        if (index > 2) {
            break;
        }
        CGFloat imageX = OTWPrintArSpacing_15 + index * (imageW + OTWPrintArSpacing_6);
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        NSString *imageView2Params = @"?imageView2/1/w/222/h/160";
        [imageView setImageWithURL:[NSURL URLWithString:[[footprint.footprintPhotoArray objectAtIndex:index] stringByAppendingString:imageView2Params]]];
        imageView.layer.cornerRadius = 4;
        [imageView.layer setMasksToBounds:YES];
        [self.shapeBG addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
