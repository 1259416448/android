//
//  OTWNoSystemNewViewController.m
//  OnTheWay
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNoSystemNewViewController.h"

@interface OTWNoSystemNewViewController ()

@property(nonatomic,strong) UIImageView *noSystemNewImage;
@property(nonatomic,strong) UILabel *noSystemNewTips;

@end

@implementation OTWNoSystemNewViewController

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
    self.title = @"系统消息";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.noSystemNewImage];
    [self.view addSubview:self.noSystemNewTips];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView*)noSystemNewImage
{
    if (!_noSystemNewImage) {
        CGFloat noSystemNewImageX = (SCREEN_WIDTH - 143)/2.0;
        CGFloat noSystemNewImageY = (SCREEN_HEIGHT - 111)/2.0;
        _noSystemNewImage = [[UIImageView alloc] initWithFrame:CGRectMake(noSystemNewImageX, noSystemNewImageY, 143, 111)];
        [_noSystemNewImage setImage:[UIImage imageNamed:@"qx_wuxiaoxi"]];
    }
    return _noSystemNewImage;
}

- (UILabel*)noSystemNewTips
{
    if (!_noSystemNewTips) {
        CGFloat noSystemNewTipsX = (SCREEN_WIDTH - 93)/2.0;
        CGFloat noSystemNewTipsY = CGRectGetMaxY(self.noSystemNewImage.frame) + 20;
        _noSystemNewTips = [[UILabel alloc] init];
        _noSystemNewTips.frame = CGRectMake(noSystemNewTipsX, noSystemNewTipsY, 93, 42);
        _noSystemNewTips.text = @"系统对你无爱了\n没有话对你说";
        _noSystemNewTips.textColor = [UIColor color_979797];
        [_noSystemNewTips setFont:[UIFont systemFontOfSize:13]];
        _noSystemNewTips.numberOfLines = 0;
        _noSystemNewTips.textAlignment = NSTextAlignmentCenter;
    }
    return _noSystemNewTips;
}

@end
