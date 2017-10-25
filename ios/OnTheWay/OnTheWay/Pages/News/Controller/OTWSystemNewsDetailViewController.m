//
//  OTWSystemNewsDetailViewController.m
//  OnTheWay
//
//  Created by apple on 2017/10/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWSystemNewsDetailViewController.h"

@interface OTWSystemNewsDetailViewController ()

@property (nonatomic, strong) UIView * mainView;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UITextView * detailLabel;


@end

@implementation OTWSystemNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    self.view.backgroundColor=[UIColor color_f4f4f4];
    [self buildUI];
}
- (void)buildUI
{
    [self.view addSubview:self.mainView];
    [self.mainView addSubview:self.titleLabel];
    [self.mainView addSubview:self.timeLabel];
    [self.mainView addSubview:self.detailLabel];
}
- (UIView *)mainView
{
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT - 74)];
        _mainView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _mainView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH - 60, 24)];
        _titleLabel.font = [UIFont systemFontOfSize: 17];
        _titleLabel.textColor = [UIColor color_202020];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.titleLabel.frame) + 4.5, SCREEN_WIDTH - 60, 15)];
        _timeLabel.font = [UIFont systemFontOfSize: 13];
        _timeLabel.textColor = [UIColor color_979797];
    }
    return _timeLabel;
}

- (UITextView *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UITextView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.timeLabel.frame) + 30, SCREEN_WIDTH - 60, SCREEN_HEIGHT - 200)];
        _detailLabel.font = [UIFont systemFontOfSize: 14];
        _detailLabel.textColor = UIColorFromRGB(0x6a6a6a);
        _detailLabel.userInteractionEnabled = NO;
//        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (void)setModel:(OTWSystemNewsModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.dateCreatedStr;
    self.detailLabel.text = model.content;
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
