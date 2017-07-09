//
//  OTWLoginViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWLoginViewController.h"
#import <MBProgressHUD.h>
#import "NSString+RegexCategory.h"
#import "OTWLoginService.h"



@interface OTWLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *textFeildBGView;
@property (nonatomic, strong) UITextField *phoneNumField;
@property (nonatomic,strong) UITextField *codeNumFileld;
@property (nonatomic,strong) UIButton *codeSentButton;

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
    //self.title = @"登录";
    
    self.hiddenCustomNavigation = true;
    
    //大背景
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    self.textFeildBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 10, SCREEN_WIDTH, 103)];
    self.textFeildBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textFeildBGView];
    
    //插入一条线
    UIView *underLineOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    underLineOneView.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"];
    [self.textFeildBGView addSubview:underLineOneView];
    
    //手机号
    UIView *phoneNumberBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.textFeildBGView.Witdh, 50)];
    [self.textFeildBGView addSubview:phoneNumberBGView];
    
    UIImageView *phoneNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 13, 15)];
    phoneNumImageView.image = [UIImage imageNamed:@"shouji"];
    [phoneNumberBGView addSubview:phoneNumImageView];
    
    UILabel *phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 58, phoneNumberBGView.Height)];
    phoneNumLabel.font = [UIFont systemFontOfSize:16];
    phoneNumLabel.textColor = [UIColor colorWithHexString:@"202020"];
    phoneNumLabel.text = @"手机号";
    [phoneNumberBGView addSubview:phoneNumLabel];
    
    self.phoneNumField= [[UITextField alloc] initWithFrame:CGRectMake(96, 0, phoneNumberBGView.Witdh - phoneNumLabel.MaxX, phoneNumberBGView.Height)];
    self.phoneNumField.placeholder = @"输入正确手机号";
    self.phoneNumField.backgroundColor = [UIColor clearColor];
    self.phoneNumField.delegate = self;
    self.phoneNumField.tag = 10000;
    
    self.phoneNumField.font = [UIFont systemFontOfSize:14];
    self.phoneNumField.textColor = [UIColor colorWithHexString:@"979797"];
    //只输入数字
    self.phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    //把定义好的UITextField 加入到上层View容器中
    [phoneNumberBGView addSubview:self.phoneNumField];
    
    UIView *underLineTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, phoneNumberBGView.Height, SCREEN_WIDTH, 0.5)];
    underLineTwoView.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"];
    [self.textFeildBGView addSubview:underLineTwoView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(30, self.textFeildBGView.MaxY + 100, SCREEN_WIDTH-30*2, 44);
    loginButton.backgroundColor = [UIColor colorWithHexString:@"e50834"];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    loginButton.layer.cornerRadius = 4;
//    [loginButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [loginButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [self.view addSubview:loginButton];
    
    //验证码View
    UIView *codeNumberBGView = [[UIView alloc] initWithFrame:CGRectMake(0, underLineOneView.Height+phoneNumberBGView.Height+underLineTwoView.Height, SCREEN_WIDTH, 50)];
    codeNumberBGView.backgroundColor = [UIColor whiteColor];
    //加入主视图
    [self.textFeildBGView addSubview:codeNumberBGView];
    
    //验证码图片View
    UIImageView *codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 13, 15)];
    codeImageView.image = [UIImage imageNamed:@"yanzhengma"];
    
    //加入验证码View中
    [codeNumberBGView addSubview:codeImageView];
    
    //验证码label
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 58, codeNumberBGView.Height)];
    codeLabel.text = @"验证码";
    codeLabel.font = [UIFont systemFontOfSize:16];
    [codeNumberBGView addSubview:codeLabel];
    
    //验证码输入框
    self.codeNumFileld = [[UITextField alloc] initWithFrame:CGRectMake(96, 0, SCREEN_WIDTH-15-75-15-96, codeNumberBGView.Height)];
    self.codeNumFileld.placeholder = @"验证码";
    self.codeNumFileld.backgroundColor = [UIColor clearColor];
    self.codeNumFileld.delegate = self;
    self.codeNumFileld.tag = 10001;
    
    self.codeNumFileld.font = [UIFont systemFontOfSize:14];
    self.codeNumFileld.textColor = [UIColor colorWithHexString:@"979797"];
    //只输入数字
    self.codeNumFileld.keyboardType = UIKeyboardTypeNumberPad;
    [codeNumberBGView addSubview:_codeNumFileld];
    
    //获取验证码按钮
    _codeSentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeSentButton.frame = CGRectMake(SCREEN_WIDTH-15-75, 9.5, 75, 30);
    _codeSentButton.backgroundColor = [UIColor colorWithRed:229/255.0 green:8/255.0 blue:52/255.0 alpha:1/1.0];
    [_codeSentButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeSentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeSentButton addTarget:self action:@selector(codeSentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _codeSentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _codeSentButton.layer.cornerRadius = 4;
    [codeNumberBGView addSubview:_codeSentButton];
    
    //最下面的线
    UIView *underLineThreeView = [[UIView alloc] initWithFrame:CGRectMake(0, _textFeildBGView.Height-1, SCREEN_WIDTH, 0.5)];
    underLineThreeView.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"];
    [self.textFeildBGView addSubview:underLineThreeView];
    
    
    
    
    
    
    
}

#pragma mark - Private methods loginButtonClick

- (void)loginButtonClick
{
    DLog(@"登录");
}
#pragma mark - Private methods codeSentButtonClick
- (void)codeSentButtonClick{
    DLog(@"发送验证码");
    //验证手机号是否合法
    
   // MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    
    
    //[self.view addSubview:hud];
   // hud.label.font = [UIFont systemFontOfSize:13];
   // hud.label.text = @"Loading...";
    
   // [hud showAnimated:YES];
    
   // [hud hideAnimated:YES afterDelay:5];
    
    
    //[self openCodeCountdown];
    
    //验证手机号是否合法，合法调用后台接口，发送手机验证码
    
    DLog(@"mobile:%@",_phoneNumField.text);
    
    if(_phoneNumField.text.isMobileNumber){
        //请求发送验证码接口
        [OTWLoginService sentLoginCode:_phoneNumField.text completion:nil];
        
        [self openCodeCountdown];
        
    }else{
        DLog(@"输入的手机号码错误！");
    }
}

// 开启倒计时效果
#pragma mark - Private methods openCodeCountdown
-(void)openCodeCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.codeSentButton setTitle:@"重新发送" forState:UIControlStateNormal];
                self.codeSentButton.userInteractionEnabled = YES;
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.codeSentButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                self.codeSentButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string 表示当前输入的字符
    
    DLog(@"string:%@",string);
    
    DLog(@"textField tag:%ld",textField.tag);
    
    if (string.length > 11)
    {
        return NO;
    }
        return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumField resignFirstResponder];
    [self.codeNumFileld resignFirstResponder];
}



@end
