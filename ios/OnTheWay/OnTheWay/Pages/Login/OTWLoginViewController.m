//
//  OTWLoginViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWLoginViewController.h"

@interface OTWLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *textFeildBGView;
@property (nonatomic, strong) UITextField *phoneNumField;

@end

@implementation OTWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)buildUI
{
    self.title = @"登录";
    
    self.textFeildBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 10, SCREEN_WIDTH, 101)];
    self.textFeildBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textFeildBGView];
    
    UIView *phoneNumberBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.textFeildBGView.Witdh, 50)];
    [self.textFeildBGView addSubview:phoneNumberBGView];
    
    UIImageView *phoneNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 13, 15)];
    phoneNumImageView.image = [UIImage imageNamed:@"shouji"];
    [phoneNumberBGView addSubview:phoneNumImageView];
    
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(phoneNumImageView.MaxX + 5, 0, 58, phoneNumberBGView.Height)];
    phoneNumLabel.font = [UIFont systemFontOfSize:16];
    phoneNumLabel.textColor = [UIColor colorWithHexString:@"202020"];
    phoneNumLabel.text = @"手机号";
    [phoneNumberBGView addSubview:phoneNumLabel];
    
     self.phoneNumField= [[UITextField alloc] initWithFrame:CGRectMake(phoneNumLabel.MaxX + 5, 0, phoneNumberBGView.Witdh - phoneNumLabel.MaxX, phoneNumberBGView.Height)];
    self.phoneNumField.placeholder = @"输入正确手机号";
    self.phoneNumField.backgroundColor = [UIColor clearColor];
    self.phoneNumField.delegate = self;
    self.phoneNumField.font = [UIFont systemFontOfSize:14];
    self.phoneNumField.textColor = [UIColor colorWithHexString:@"979797"];
    [phoneNumberBGView addSubview:self.phoneNumField];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(30, self.textFeildBGView.MaxY + 100, SCREEN_WIDTH-30*2, 44);
    loginButton.backgroundColor = [UIColor colorWithHexString:@"e50834"];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    loginButton.layer.cornerRadius = 4;
    [loginButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [loginButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [self.view addSubview:loginButton];
    
    
    
}

#pragma mark - Private methods

- (void)loginButtonClick
{
    DLog(@"登录");
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 11)
    {
        return NO;
    }
        return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumField resignFirstResponder];
}

@end
