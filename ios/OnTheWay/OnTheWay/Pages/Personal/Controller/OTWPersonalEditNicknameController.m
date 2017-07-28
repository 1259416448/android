//
//  OTWPersonalEditNickname.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/9.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalEditNicknameController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWUserModel.h"

@interface OTWPersonalEditNicknameController()

@property (nonatomic,strong) UITextField *nicknameTextField;

@end

@implementation OTWPersonalEditNicknameController

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(self);
    self.customNavigationBar.rightButtonClicked=^{
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
    [nicknameEditView addSubview:self.nicknameTextField];
    
    //第二条线
    UIView *underLineButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 74+0.5+50, SCREEN_WIDTH, 0.5)];
    underLineButtonView.backgroundColor = [UIColor color_d5d5d5];
    [self.view addSubview:underLineButtonView];
    
}

-(void) saveNickname
{
   DLog(@"点击了保存按钮，当前的nickname：%@", self.nicknameTextField.text);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nicknameTextField resignFirstResponder];
}

#pragma mark - Setter Getter

-(UITextField*)nicknameTextField{
    if(!_nicknameTextField){
        _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-15*2, 20)];
        _nicknameTextField.font = [UIFont systemFontOfSize:16];
        _nicknameTextField.textColor = [UIColor color_202020];
        _nicknameTextField.text = [OTWUserModel shared].name;
    }
    return _nicknameTextField;
}


@end




