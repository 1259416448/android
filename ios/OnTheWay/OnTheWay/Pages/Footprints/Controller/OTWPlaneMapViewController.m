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
#import "OTWFootprintReleaseViewController.h"

@interface OTWPlaneMapViewController ()

@property (nonatomic,strong) UIImageView *backImageV;
@property (nonatomic,strong) UIButton *openModalButtonV;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) STPopupController *popupController;

@property (nonatomic,strong) UIView * ARdituImageView;
@property (nonatomic,strong) UIView * fabuImageView;
@property (nonatomic,strong) UIView * pingmianImageView;

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
    
    [self test];
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

#pragma mark - test

- (void)test
{
    //设置标题
    self.title = @"地图列表";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    [self.view addSubview:self.ARdituImageView];
    [self.view addSubview:self.fabuImageView];
    [self.view addSubview:self.pingmianImageView];
}

-(UIView*)ARdituImageView{
    if(!_ARdituImageView){
        _ARdituImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50-50-4, SCREEN_HEIGHT-30-49, 50, 50)] ;
        _ARdituImageView.backgroundColor = [UIColor clearColor];
        [(UIControl *)_ARdituImageView addTarget:self action:@selector(ARdituClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgARditu=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgARditu.image=[UIImage imageNamed:@"ar_ARditu"];
        [_ARdituImageView addSubview:imgARditu];
    }
    return _ARdituImageView;
}

-(UIView*)fabuImageView{
    if(!_fabuImageView){
        _fabuImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50-50-50-8, SCREEN_HEIGHT-30-49, 50, 50)] ;
        _fabuImageView.backgroundColor = [UIColor clearColor];
        [(UIControl *)_fabuImageView addTarget:self action:@selector(fubuClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgfabu=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgfabu.image=[UIImage imageNamed:@"ar_fabu"];
        [_fabuImageView addSubview:imgfabu];
    }
    return _fabuImageView;
}

-(UIView*)pingmianImageView{
    if(!_pingmianImageView){
        _pingmianImageView = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-50, SCREEN_HEIGHT-30-49, 50, 50)] ;
        _pingmianImageView.backgroundColor = [UIColor clearColor];
        [(UIControl *)_pingmianImageView addTarget:self action:@selector(pingmianClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imgpingmian=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgpingmian.image=[UIImage imageNamed:@"ar_list"];
        [_pingmianImageView addSubview:imgpingmian];
        
    }
    return _pingmianImageView;
}

- (void)ARdituClick
{
    NSLog(@"点击了ARdituClick");
    [self.navigationController popViewControllerAnimated:NO];
    [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexAR];
}

- (void)fubuClick
{
    NSLog(@"点击了fubuClick");
    if(![[OTWLaunchManager sharedManager] showLoginViewWithController:self completion:nil]){
        OTWFootprintReleaseViewController *releaseVC = [[OTWFootprintReleaseViewController alloc] init];
        [self.navigationController pushViewController:releaseVC animated:YES];
    };
}

- (void)pingmianClick
{
    NSLog(@"点击了pingmianClick");
    [self.navigationController popViewControllerAnimated:NO];
    [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexFootprints];
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
