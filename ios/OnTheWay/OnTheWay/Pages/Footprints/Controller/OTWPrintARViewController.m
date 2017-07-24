//
//  OTWPrintARViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPrintARViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define OTWPrintArSpacing_15 15
#define OTWPrintArSpacing_10 10
#define OTWPrintArSpacing_7 7
#define OTWPrintArSpacing_6 6
#define OTWPrintArSpacing_3 3

#define OTWPrintArImageWidth_10 10
#define OTWPrintArImageWidth_30 30
#define OTWPrintArImageWidth_35 35
#define OTWPrintArImageWidth_50 50

@interface OTWPrintARViewController ()
@property (nonatomic,strong) UIView *arBGV;
@property (nonatomic,strong) UIImageView *backImageV;
@property (nonatomic,strong) UIImageView *refreshImageV;
@property (nonatomic,strong) UIImageView *dateImageV;
@property (nonatomic,strong) UIImageView *locationImageV;
@property (nonatomic,strong) UIImageView *cameraImageV;
@property (nonatomic,strong) UIImageView *arListImageV;
@property (nonatomic,strong) UIImageView *planeMapImageV;
@property (nonatomic,strong) UIView *printARV;
@property (nonatomic,strong) UIImageView *printImageV;
@property (nonatomic,strong) UILabel *printTitleV;
@property (nonatomic,strong) UIImageView *printLocationImageV;
@property (nonatomic,strong) UILabel *printLocationNameV;
@property (nonatomic,strong) UIImageView *printDateImageV;
@property (nonatomic,strong) UILabel *printDateContentV;
@property (nonatomic,strong) UIImageView *printUserImageV;


@end

@implementation OTWPrintARViewController

//隐藏底边栏
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
    // Do any additional setup after loading the view.
    
}

-(void)setupBase
{
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.arBGV];
    [self.arBGV addSubview:self.backImageV];
    [self.arBGV addSubview:self.refreshImageV];
    [self.arBGV addSubview:self.dateImageV];
    [self.arBGV addSubview:self.locationImageV];
    [self.arBGV addSubview:self.cameraImageV];
    [self.arBGV addSubview:self.arListImageV];
    [self.arBGV addSubview:self.planeMapImageV];
    [self.arBGV addSubview:self.printARV];
    [self.printARV addSubview:self.printImageV];
    [self.printARV addSubview:self.printTitleV];
        [self.printARV addSubview:self.printLocationImageV];
        [self.printARV addSubview:self.printLocationNameV];
        [self.printARV addSubview:self.printDateImageV];
        [self.printARV addSubview:self.printDateContentV];
        [self.printARV addSubview:self.printUserImageV];
    
}

-(UIView *)arBGV
{
    if (!_arBGV) {
        _arBGV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _arBGV.backgroundColor = [UIColor redColor];
    }
    return _arBGV;
}

-(UIImageView *)backImageV
{
    if (!_backImageV) {
        _backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 24.5, 35, 35)];
        [_backImageV setImage:[UIImage imageNamed:@"back_1"]];
        _backImageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToUp)];
        [_backImageV addGestureRecognizer:tapGesturRecognizer];
        
    }
    return _backImageV;
}

-(UIImageView *)refreshImageV
{
    if (!_refreshImageV) {
        _refreshImageV = [[UIImageView alloc] init];
        CGFloat refreshImageX = SCREEN_WIDTH - OTWPrintArImageWidth_35 - OTWPrintArSpacing_15;
        CGFloat refreshImageY = SCREEN_HEIGHT - 195 - OTWPrintArImageWidth_35;
        CGRect refreshImageRect = CGRectMake(refreshImageX, refreshImageY, OTWPrintArImageWidth_35, OTWPrintArImageWidth_35);
        _refreshImageV.frame = refreshImageRect;
        [_refreshImageV setImage:[UIImage imageNamed:@"ar_huanyipi"]];
    }
    return _refreshImageV;
}

-(UIImageView *)dateImageV
{
    if (!_dateImageV) {
        _dateImageV = [[UIImageView alloc] init];
        CGFloat dateImageX = SCREEN_WIDTH - OTWPrintArImageWidth_35 - OTWPrintArSpacing_15;
        CGFloat dateImageY = CGRectGetMaxY(_refreshImageV.frame) + OTWPrintArSpacing_10;
        CGRect dateImageRect = CGRectMake(dateImageX, dateImageY, OTWPrintArImageWidth_35, OTWPrintArImageWidth_35);
        _dateImageV.frame = dateImageRect;
        [_dateImageV setImage:[UIImage imageNamed:@"zj_shijian"]];
    }
    return _dateImageV;
}

-(UIImageView *)locationImageV
{
    if (!_locationImageV) {
        _locationImageV = [[UIImageView alloc] init];
        CGFloat locationImageX = SCREEN_WIDTH - OTWPrintArImageWidth_35 - OTWPrintArSpacing_15;
        CGFloat locationImageY = CGRectGetMaxY(_dateImageV.frame) + OTWPrintArSpacing_10;
        CGRect locationImageRect = CGRectMake(locationImageX, locationImageY, OTWPrintArImageWidth_35, OTWPrintArImageWidth_35);
        _locationImageV.frame = locationImageRect;
        [_locationImageV setImage:[UIImage imageNamed:@"juli"]];
    }
    return _locationImageV;
}


-(UIImageView *)cameraImageV
{
    if (!_cameraImageV) {
        _cameraImageV = [[UIImageView alloc] init];
        CGFloat cameraImageX = SCREEN_WIDTH - OTWPrintArImageWidth_50*3 - OTWPrintArSpacing_15 - OTWPrintArSpacing_7*2;
        CGFloat cameraImageY = SCREEN_HEIGHT - OTWPrintArSpacing_15*2 - OTWPrintArImageWidth_50;
        CGRect cameraImageRect = CGRectMake(cameraImageX, cameraImageY, OTWPrintArImageWidth_50, OTWPrintArImageWidth_50);
        _cameraImageV.frame = cameraImageRect;
        [_cameraImageV setImage:[UIImage imageNamed:@"fabu"]];
    }
    return _cameraImageV;
}

-(UIImageView *)arListImageV
{
    if (!_arListImageV) {
        _arListImageV = [[UIImageView alloc] init];
        CGFloat arListImageX = CGRectGetMaxX(_cameraImageV.frame) + OTWPrintArSpacing_7;
        CGFloat arListImageY = CGRectGetMaxY(_cameraImageV.frame) - OTWPrintArImageWidth_50;
        CGRect arListImageRect = CGRectMake(arListImageX, arListImageY, OTWPrintArImageWidth_50, OTWPrintArImageWidth_50);
        _arListImageV.frame = arListImageRect;
        [_arListImageV setImage:[UIImage imageNamed:@"ar_list"]];
    }
    return _arListImageV;
}

-(UIImageView *)planeMapImageV
{
    if (!_planeMapImageV) {
        _planeMapImageV = [[UIImageView alloc] init];
        CGFloat planeMapImageX = CGRectGetMaxX(_arListImageV.frame) + OTWPrintArSpacing_7;
        CGFloat planeMapImageY = CGRectGetMaxY(_arListImageV.frame) - OTWPrintArImageWidth_50;
        CGRect planeMapImageRect = CGRectMake(planeMapImageX, planeMapImageY, OTWPrintArImageWidth_50, OTWPrintArImageWidth_50);
        _planeMapImageV.frame = planeMapImageRect;
        [_planeMapImageV setImage:[UIImage imageNamed:@"ar_pingmian"]];
    }
    return _planeMapImageV;
}

-(UIView *)printARV
{
    if (!_printARV) {
        _printARV = [[UIView alloc] init];
        CGRect printARRect = CGRectMake(44.5, 117, 164, 42);
        _printARV.frame = printARRect;
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
        CGRect printImageRect = CGRectMake(printImageX, printImageY, OTWPrintArImageWidth_30, OTWPrintArImageWidth_30);
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
        CGRect locationImageRect = CGRectMake(locationImageX, locationImageY, OTWPrintArImageWidth_10, OTWPrintArImageWidth_10);
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
        CGRect printDateImageRect = CGRectMake(printDateImageX, printDateImageY, OTWPrintArImageWidth_10, OTWPrintArImageWidth_10);
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
        CGRect printUserImageRect = CGRectMake(printUserImageX, printUserImageY, OTWPrintArImageWidth_30, OTWPrintArImageWidth_30);
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

- (void) backToUp

{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addFootPrintV
{
    
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
