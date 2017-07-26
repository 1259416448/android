//
//  OTWPlaneMapViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPlaneMapViewController.h"
#import "BottomSheetDemoViewController.h"
#import <STPopup.h>

@interface OTWPlaneMapViewController ()

@property (nonatomic,strong) UIImageView *backImageV;
@property (nonatomic,strong) UIButton *openModalButtonV;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) STPopupController *popupController;

@end

@implementation OTWPlaneMapViewController

//隐藏底边栏
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBase];
}

- (void)setUpBase
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.openModalButtonV];
}

- (UIButton *)openModalButtonV
{
    if (!_openModalButtonV) {
        _openModalButtonV = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect openModalButtonRect = CGRectMake(175, 175, 50, 25);
        _openModalButtonV.frame = openModalButtonRect;
        _openModalButtonV.backgroundColor = [UIColor color_f4f4f4];
        //button 内边距
        _openModalButtonV.titleEdgeInsets = UIEdgeInsetsMake(5, 9.5, 5, 9.5);
        //button 文字居中显示
        _openModalButtonV.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _openModalButtonV.layer.cornerRadius = 4;
        _openModalButtonV.titleLabel.font = [UIFont systemFontOfSize:14];
        [_openModalButtonV setTitle:@"打开" forState:UIControlStateNormal];
        [_openModalButtonV setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
        [_openModalButtonV addTarget:self action:@selector(openModal) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openModalButtonV;
}

- (void)openModal
{
    NSLog(@"打开模态框！");
    _popupController = [[STPopupController alloc] initWithRootViewController:[BottomSheetDemoViewController new]];
    _popupController.style = STPopupStyleBottomSheet;
    _popupController.containerView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_popupController.backgroundView addGestureRecognizer:tapRecognizer];
    [_popupController setNavigationBarHidden:YES];
    [_popupController presentInViewController:self];
}

- (void) tapAction
{
    DLog(@"dianjile ");
    [_popupController dismiss];
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
