//
//  OTWNoPraiseViewController.m
//  OnTheWay
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNoPraiseViewController.h"

@interface OTWNoPraiseViewController ()

@property(nonatomic,strong) UIImageView *noPraiseImage;
@property(nonatomic,strong) UILabel *noPraiseTips;

@end

@implementation OTWNoPraiseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBase];
}

- (void)setBase
{
    self.title = @"新的赞";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.noPraiseImage];
    [self.view addSubview:self.noPraiseTips];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView*)noPraiseImage
{
    if (!_noPraiseImage) {
        CGFloat noPraiseImageX = (SCREEN_WIDTH - 145)/2.0;
        CGFloat noPraiseImageY = (SCREEN_HEIGHT - 115)/2.0;
        _noPraiseImage = [[UIImageView alloc] initWithFrame:CGRectMake(noPraiseImageX, noPraiseImageY, 145, 115)];
        [_noPraiseImage setImage:[UIImage imageNamed:@"qx_wupinglun"]];
    }
    return _noPraiseImage;
}

- (UILabel*)noPraiseTips
{
    if (!_noPraiseTips) {
        CGFloat noPraiseTipsX = (SCREEN_WIDTH - 108)/2.0;
        CGFloat noPraiseTipsY = CGRectGetMaxY(self.noPraiseImage.frame) + 20;
        _noPraiseTips = [[UILabel alloc] init];
        _noPraiseTips.frame = CGRectMake(noPraiseTipsX, noPraiseTipsY, 108, 42);
        _noPraiseTips.text = @"还没有小伙伴\n为你的足迹点赞呢";
        _noPraiseTips.textColor = [UIColor color_979797];
        [_noPraiseTips setFont:[UIFont systemFontOfSize:13]];
        _noPraiseTips.numberOfLines = 0;
        _noPraiseTips.textAlignment = NSTextAlignmentCenter;
    }
    return _noPraiseTips;
}

@end
