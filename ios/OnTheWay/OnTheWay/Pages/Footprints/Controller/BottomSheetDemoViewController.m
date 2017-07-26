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
        self.contentSizeInPopup = CGSizeMake(self.view.width, 357);
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
    
    [self createImageV];
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
        _shapeBG.frame = CGRectMake(0, 45, self.view.width, 312);
    }
    return _shapeBG;
}

- (UIImageView *)userImageV
{
    if (!_userImageV) {
        _userImageV = [[UIImageView alloc] init];
        CGRect userImageRect = CGRectMake(SCREEN_WIDTH/2.0 - 45, -45, 90, 90);
        _userImageV.frame = userImageRect;
        [_userImageV setImageWithURL:[NSURL URLWithString:@"http://osx4pwgde.bkt.clouddn.com/c0ab21ab26b4694769b6e904788b3590630777.jpg"]];
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
        CGFloat userNameX = OTWPrintArSpacing_15;
        CGFloat userNameY = CGRectGetMaxY(_userImageV.frame) + OTWPrintArSpacing_10;
        CGFloat userNameW = SCREEN_WIDTH - OTWPrintArSpacing_15*2;
        CGSize userNameSize = [@"想起一个很长的名字" boundingRectWithSize:CGSizeMake(userNameW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        CGRect userNameRect = CGRectMake(userNameX, userNameY, userNameW, userNameSize.height);
        _userNameV.frame = userNameRect;
        _userNameV.text = @"想起一个很长的名字";
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
        CGFloat footPrintContentX = OTWPrintArSpacing_15;
        CGFloat footPrintContentY = CGRectGetMaxY(_underLineOneView.frame) + (SCREEN_WIDTH - OTWPrintArSpacing_15*2 - OTWPrintArSpacing_6*2)/3.0*80/111 + OTWPrintArSpacing_15 + OTWPrintArSpacing_10;
        CGFloat footPrintContentW = SCREEN_WIDTH - OTWPrintArSpacing_15*2;
        CGSize footPrintContentSize = [@"香甜的桂花馅料里裹着核桃仁，用井水来淘洗像珍珠一样的江米" boundingRectWithSize:CGSizeMake(footPrintContentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        CGRect footPrintContentRect = CGRectMake(footPrintContentX, footPrintContentY, footPrintContentW, footPrintContentSize.height);
        _footPrintContent.frame = footPrintContentRect;
        _footPrintContent.text = @"香甜的桂花馅料里裹着核桃仁，用井水来淘洗像珍珠一样的江米";
        _footPrintContent.textColor = [UIColor color_202020];
        _footPrintContent.font = [UIFont systemFontOfSize:16];
        _footPrintContent.numberOfLines = 0;
    }
    return _footPrintContent;
}

-(UIView*)underLineOneView{
    if(!_underLineOneView){
        CGFloat lineVY = CGRectGetMaxY(_userNameV.frame) + OTWPrintArSpacing_15;
        _underLineOneView = [[UIView alloc] initWithFrame:CGRectMake(0, lineVY, SCREEN_WIDTH, 0.5)];
        _underLineOneView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineOneView;
}

-(UIImageView *)locationV
{
    if (!_locationV) {
        _locationV = [[UIImageView alloc] init];
        CGFloat locationVY = CGRectGetMaxY(_footPrintContent.frame) + OTWPrintArSpacing_6;
        _locationV.frame = CGRectMake(15, locationVY, 10, 10);
        [_locationV setImage:[UIImage imageNamed:@"dinwgei_2"]];
    }
    return _locationV;
}

-(UILabel *)locationNameV
{
    if (!_locationNameV) {
        _locationNameV = [[UILabel alloc] init];
        CGFloat locationNameX = CGRectGetMaxX(_locationV.frame) + OTWPrintArSpacing_3;
        CGFloat locationNameY = CGRectGetMaxY(_footPrintContent.frame) + OTWPrintArSpacing_6;
        _locationNameV.frame = CGRectMake(locationNameX, locationNameY, 190, 12);
        _locationNameV.text = @"北大街联慧路88号";
        _locationNameV.textColor = [UIColor color_979797];
        _locationNameV.font = [UIFont systemFontOfSize:11];
    }
    return _locationNameV;
}

-(UIImageView *)dateV
{
    if (!_dateV) {
        _dateV = [[UIImageView alloc] init];
        CGFloat dateVX = SCREEN_WIDTH - 70;
        CGFloat dateVY = CGRectGetMaxY(_footPrintContent.frame) + OTWPrintArSpacing_6;
        _dateV.frame = CGRectMake(dateVX, dateVY, 10, 10);
        [_dateV setImage:[UIImage imageNamed:@"shijian"]];
    }
    return _dateV;
}

-(UILabel *)dateNameV
{
    if (!_dateNameV) {
        _dateNameV = [[UILabel alloc] init];
        CGFloat dateNameX = CGRectGetMaxX(_dateV.frame) + OTWPrintArSpacing_3;
        CGFloat dateNameY = CGRectGetMaxY(_footPrintContent.frame) + OTWPrintArSpacing_6;
        _dateNameV.frame = CGRectMake(dateNameX, dateNameY, 41, 12);
        _dateNameV.text = @"1小时前";
        _dateNameV.textColor = [UIColor color_979797];
        _dateNameV.font = [UIFont systemFontOfSize:11];
    }
    return _dateNameV;
}

- (UIButton *)detailButtonV
{
    if (!_detailButtonV) {
        _detailButtonV = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat detailButtonY = CGRectGetMaxY(_dateNameV.frame) + 20;
        CGRect detailButtonRect = CGRectMake(0, detailButtonY, SCREEN_WIDTH, 38.5);
        _detailButtonV.frame = detailButtonRect;
        _detailButtonV.backgroundColor = [UIColor color_f4f4f4];
        //button 内边距
//        _detailButtonV.titleEdgeInsets = UIEdgeInsetsMake(5, 9.5, 5, 9.5);
        //button 文字居中显示
        _detailButtonV.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        _detailButtonV.layer.cornerRadius = 4;
        _detailButtonV.titleLabel.font = [UIFont systemFontOfSize:13];
        [_detailButtonV setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailButtonV setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
    }
    return _detailButtonV;
}

-(void)createImageV
{
    CGFloat imageW = (SCREEN_WIDTH - OTWPrintArSpacing_15*2 - OTWPrintArSpacing_6*2)/3.0;
    CGFloat imageH = imageW*80/111;
    CGFloat imageY = CGRectGetMaxY(_underLineOneView.frame) + OTWPrintArSpacing_15;
    for (int index = 0; index <= 1; index++) {
        CGFloat imageX = OTWPrintArSpacing_15 + index * (imageW + OTWPrintArSpacing_6);
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [imageView setImageWithURL:[NSURL URLWithString:@"http://osx4pwgde.bkt.clouddn.com/c0ab21ab26b4694769b6e904788b3590630777.jpg"]];
        [self.shapeBG addSubview:imageView];
    }
}

- (void)nextBtnDidTap
{
    NSLog(@"A");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
