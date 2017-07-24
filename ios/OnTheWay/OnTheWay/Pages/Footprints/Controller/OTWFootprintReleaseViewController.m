//
//  OTWFootprintReleaseViewController.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintReleaseViewController.h"

@interface OTWFootprintReleaseViewController ()

@property (nonatomic,strong) UIView *rightNavigationBarView;

@end

@implementation OTWFootprintReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bulidUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) bulidUI
{
    self.title = @"发布足迹";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor=[UIColor color_f4f4f4];
    [self setRightNavigationBarView:self.rightNavigationBarView];
    
}

- (UIView *) rightNavigationBarView
{
    if(!_rightNavigationBarView){
        _rightNavigationBarView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-32, 31, 32, 22.5)];
        _rightNavigationBarView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 22.5)];
        titleLabel.text = @"发布";
        titleLabel.textColor = [UIColor color_202020];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightNavigationBarView addSubview:titleLabel];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footprintReleaseTap)];
        [_rightNavigationBarView addGestureRecognizer:tapGesturRecognizer];
    }
    return _rightNavigationBarView;
}

#pragma mark - 右侧按钮点击

- (void) footprintReleaseTap
{
    
}


@end
