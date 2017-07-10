//
//  OTWPersonalEditNickname.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/9.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalEditNicknameController.h"
#import "OTWCustomNavigationBar.h"

@interface OTWPersonalEditNicknameController()

@property (nonatomic,strong) UITextField *nicknameTextField;

@end

@implementation OTWPersonalEditNicknameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavigationBar.leftButtonClicked=^{
        DLog(@"点击了返回按钮");
    };
    WeakSelf(self);
    self.customNavigationBar.rightButtonClicked=^{
        DLog(@"点击了保存按钮");
        [weakself saveNickname];
    };
    
    [self buildUI];
}

#pragma mark - UI
- (void)buildUI
{
    //设置头部信息
    self.title = @"修改名称";
    
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    [self setRightNavigationTitle:@"保存"];
    //设置背景色
    self.view.backgroundColor = [UIColor color_f4f4f4];
    
    //第一条线
    UIView *underLineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 73.5, SCREEN_WIDTH, 0.5)];
    underLineTopView.backgroundColor = [UIColor color_d5d5d5];
    [self.view addSubview:underLineTopView];
    
    //设置nickname修改背景
    UIView *nicknameEditView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 50)];
    nicknameEditView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nicknameEditView];
    
    //nickname输入框
    _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-15*2, 20)];
    _nicknameTextField.font = [UIFont systemFontOfSize:16];
    _nicknameTextField.textColor = [UIColor color_202020];
    _nicknameTextField.text = @"想一个很长的名字";
    
    [nicknameEditView addSubview:_nicknameTextField];
    
    //第二条线
    UIView *underLineButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 74+0.5+50, SCREEN_WIDTH, 0.5)];
    underLineButtonView.backgroundColor = [UIColor color_d5d5d5];
    [self.view addSubview:underLineButtonView];
    
}

-(void) saveNickname
{
   DLog(@"点击了保存按钮，当前的nickname：%@", self.nicknameTextField.text);
}

@end




