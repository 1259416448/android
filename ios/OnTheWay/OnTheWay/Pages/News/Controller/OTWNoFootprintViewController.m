//
//  OTWNoFootprintViewController.m
//  OnTheWay
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNoFootprintViewController.h"

@interface OTWNoFootprintViewController ()

@property(nonatomic,strong) UIImageView *noFootprintImage;
@property(nonatomic,strong) UILabel *noFootprintTips;

@end

@implementation OTWNoFootprintViewController

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
    self.title = @"新的足迹动态";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.noFootprintImage];
    [self.view addSubview:self.noFootprintTips];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView*)noFootprintImage
{
    if (!_noFootprintImage) {
        CGFloat noFootprintImageX = (SCREEN_WIDTH - 143)/2.0;
        CGFloat noFootprintImageY = (SCREEN_HEIGHT - 115)/2.0;
        _noFootprintImage = [[UIImageView alloc] initWithFrame:CGRectMake(noFootprintImageX, noFootprintImageY, 145, 115)];
        [_noFootprintImage setImage:[UIImage imageNamed:@"qx_wuzujidongtai"]];
    }
    return _noFootprintImage;
}

- (UILabel*)noFootprintTips
{
    if (!_noFootprintTips) {
        CGFloat noSystemNewTipsX = (SCREEN_WIDTH - 216)/2.0;
        CGFloat noSystemNewTipsY = CGRectGetMaxY(self.noFootprintImage.frame) + 20;
        _noFootprintTips = [[UILabel alloc] init];
        _noFootprintTips.frame = CGRectMake(noSystemNewTipsX, noSystemNewTipsY, 216, 42);
        _noFootprintTips.text = @"悄悄告诉你\n你关注的小伙伴是个安静的美女子哦";
        _noFootprintTips.textColor = [UIColor color_979797];
        [_noFootprintTips setFont:[UIFont systemFontOfSize:13]];
        _noFootprintTips.numberOfLines = 0;
        _noFootprintTips.textAlignment = NSTextAlignmentCenter;
    }
    return _noFootprintTips;
}


@end
