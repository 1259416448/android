//
//  OTWBusinessListSearchViewController.m
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/10/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessListSearchViewController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWBusinessARViewController.h"

@interface OTWBusinessListSearchViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) UIButton *cancelBtn;

@end

@implementation OTWBusinessListSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}
- (void)buildUI
{
    [self.customNavigationBar addSubview:self.searchTF];
    [self.customNavigationBar addSubview:self.cancelBtn];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
}
- (UITextField *)searchTF
{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 25, SCREEN_WIDTH - 77, 33)];
        _searchTF.layer.cornerRadius = 20;
        _searchTF.placeholder = @"搜索附近的美食、商城";
        _searchTF.returnKeyType = UIReturnKeySearch;//变为搜索按钮
        _searchTF.delegate = self;
        _searchTF.font = [UIFont systemFontOfSize:14];
        _searchTF.layer.masksToBounds = YES;
        _searchTF.layer.borderColor = [UIColor clearColor].CGColor;
        _searchTF.backgroundColor=[[UIColor color_f4f4f4]colorWithAlphaComponent:0.9f];
        _searchTF.layer.borderWidth = 0.5;
        //设置图标
        UIImage *image = [UIImage imageNamed: @"sousuo_1"];
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        iView.contentMode = UIViewContentModeCenter;
        iView.frame = CGRectMake(0, 0, 40 , 33);
        _searchTF.leftView = iView;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTF;
}

-(UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_cancelBtn setTitle: @"取消" forState: UIControlStateNormal];
        _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cancelBtn setTitleColor:[UIColor color_202020]forState:UIControlStateNormal];
        
        _cancelBtn.frame =CGRectMake(self.searchTF.Witdh+30, 25.5+6, 35, 22.5);
        
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.showsTouchWhenHighlighted = NO;
        
    }
    return _cancelBtn;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(searchWithStr:)]) {
        [_delegate searchWithStr:textField.text];
    }
    if (_isFromFind) {
        [OTWLaunchManager sharedManager].BusinessARVC.searchText = textField.text;
        [OTWLaunchManager sharedManager].BusinessARVC.isFromFind = YES;
        [self.navigationController pushViewController:[OTWLaunchManager sharedManager].BusinessARVC animated:NO];
//        [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexAR];
        return YES;
    }
    if (_isFromAR) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"点击了搜索");
    return YES;
}
-(void)cancelBtnClick{
    DLog(@"点击了取消");
    if (_isFromAR) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
