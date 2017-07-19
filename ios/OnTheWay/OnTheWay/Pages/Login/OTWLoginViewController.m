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
#import "OTWCustomNavigationBar.h"
#import "OTWUserModel.h"
#import "OTWLaunchManager.h"




@interface OTWLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *textFeildBGView;
@property (nonatomic, strong) UITextField *phoneNumField;
@property (nonatomic,strong) UITextField *codeNumFileld;
@property (nonatomic,strong) UIButton *codeSentButton;
@property (nonatomic,strong) UIView *codeNumberBGView;
@property (nonatomic,strong) UIView *underLineOneView;
@property (nonatomic,strong) UIView *underLineTwoView;
@property (nonatomic,strong) UIView *underLineThreeView;
@property (nonatomic,strong) UIView *phoneNumberBGView;
@property (nonatomic,strong) UIImageView *phoneNumImageView;
@property (nonatomic,strong) UILabel *phoneNumLabel;
@property (nonatomic,strong) UIImageView *codeImageView;
@property (nonatomic,strong) UILabel *codeLabel;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIView *underLineLeftView;
@property (nonatomic,strong) UILabel *otherLoginLabel;
@property (nonatomic,strong) UIView *underLineRightView;
@property (nonatomic,strong) UIButton *wechatLoginButton;
@property (nonatomic,strong) UIButton *qqLoginButton;
@property (nonatomic,strong) UIButton *weiboLoginButton;
@property (nonatomic,strong) UIActivityIndicatorView *sentCodebuttonActivityIndicatorView;
@property (nonatomic,strong) UILabel *messageTipsLabel;
@property (nonatomic,assign) BOOL requiredLogin;;

@end

@implementation OTWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(self)
    self.customNavigationBar.leftButtonClicked=^{
        [weakself dismissViewControllerAnimated:YES completion:nil];
        //关闭键盘
        [weakself.phoneNumField resignFirstResponder];
        [weakself.codeNumFileld resignFirstResponder];
    };
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleColorChange:)
                                                 name:@"personalViewController"
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//处理接口的通知，把必须登录设置为TRUE
-(void)handleColorChange:(NSNotification*)sender
{
    DLog(@"执行了viewWillAppear loginConroller handleColorChange");
    _requiredLogin = YES;
}

#pragma mark - UI

- (void)buildUI
{
    
    //设置标题
    self.title = @"登录";
    
    //设置左边图标
    UIImage *navLeftImage = [UIImage imageNamed:@"guanbi"];
    
    [self setLeftNavigationImage:navLeftImage];
    
    //self.hiddenCustomNavigation = true;
    
    //大背景
    self.view.backgroundColor = [UIColor color_f4f4f4];
    
    //手机号+验证码输入范围
    [self.view addSubview:self.textFeildBGView];
    
    //插入一条线
    [self.textFeildBGView addSubview:self.underLineOneView];
    
    //手机号区域
    [self.textFeildBGView addSubview:self.phoneNumberBGView];
    
    //手机号图片
    [self.phoneNumberBGView addSubview:self.phoneNumImageView];
    
    //手机好label
    [self.phoneNumberBGView addSubview:self.phoneNumLabel];
    
    //手机号码输入框
    [self.phoneNumberBGView addSubview:self.phoneNumField];
    
    //中间分割线
    [self.textFeildBGView addSubview:self.underLineTwoView];
    
    //验证码View
    [self.textFeildBGView addSubview:self.codeNumberBGView];
    
    //验证码图片View
    [self.codeNumberBGView addSubview:self.codeImageView];
    
    //验证码label
    [self.codeNumberBGView addSubview:self.codeLabel];
    
    //验证码输入框
    [self.codeNumberBGView addSubview:self.codeNumFileld];
    
    //获取验证码按钮
    [self.codeNumberBGView addSubview:self.codeSentButton];
    
    //最下面的线
    [self.textFeildBGView addSubview:self.underLineThreeView];
    
    //普通操作提示
    [self.view addSubview:self.messageTipsLabel];
    
    //登陆按钮
    [self.view addSubview:self.loginButton];
    
    //左边线
    [self.view addSubview:self.underLineLeftView];
    
    //其他登陆文字
    [self.view addSubview:self.otherLoginLabel];
    
    //右边线
    [self.view addSubview:self.underLineRightView];
    
    //微信登陆
    [self.view addSubview:self.wechatLoginButton];
    
    //QQ登陆
    [self.view addSubview:self.qqLoginButton];
    
    //微博登陆
    [self.view addSubview:self.weiboLoginButton];
    
}

#pragma mark - wechatLoginBUttonClickedAction

- (void) wechatLoginBUttonClickedAction
{
    DLog(@"wechat login clicked");
}

#pragma mark - qqLoginBUttonClickedAction

- (void) qqLoginBUttonClickedAction
{
    DLog(@"qq login clicked");
}

#pragma mark - weiboLoginBUttonClickedAction

- (void) weiboLoginBUttonClickedAction
{
    DLog(@"weibo login clicked");
}

#pragma mark - Private methods loginButtonClick

- (void)loginButtonClick
{
    DLog(@"登录");
    //验证 验证手机号 和 输入的验证码
    
    self.messageTipsLabel.text = @"";
    
    if(!self.phoneNumField.text.isMobileNumber){
        DLog(@"输入的手机号码错误！");
        self.messageTipsLabel.text = @"输入的手机号错误";
        return ;
        
    }
    if(self.codeNumFileld.text.length!=6){
        DLog(@"输入的合法验证码！");
        self.messageTipsLabel.text = @"请输入合法验证码";
        return ;
    }
    //关闭键盘
    [self.phoneNumField resignFirstResponder];
    [self.codeNumFileld resignFirstResponder];
    
    //登陆按钮变更为登陆中
    [self.loginButton setTitle:@"登录中..." forState:UIControlStateNormal];
    self.loginButton.userInteractionEnabled = NO;
    //请求用户登陆接口
    [OTWLoginService loginRquest:_phoneNumField.text password:_codeNumFileld.text completion:^(id result, NSError *error) {
        if(result){
            if([[NSString stringWithFormat:@"%@", result[@"code"]] isEqualToString:@"0"]){
                //保存用户信息
                [OTWUserModel shared].userId = result[@"body"][@"id"];
                [OTWUserModel shared].gender = result[@"body"][@"gender"];
                [OTWUserModel shared].headImgYuan = result[@"body"][@"headImgYuan"];
                [OTWUserModel shared].username = result[@"body"][@"username"];
                [OTWUserModel shared].mobilePhoneNumber = result[@"body"][@"mobilePhoneNumber"];
                [OTWUserModel shared].headImg = result[@"body"][@"headImg"];
                [OTWUserModel shared].name = result[@"body"][@"name"];
                [[OTWUserModel shared] dump];
                //登陆成功
                if(self.requiredLogin){
                    [[OTWLaunchManager sharedManager].mainTabController didSelectedItemByIndex:4];
                }
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:self];
            }else{
                [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
                self.loginButton.userInteractionEnabled = YES;
                self.messageTipsLabel.text = result[@"message"];
            }
        }else{
            [self netWorkErrorTips:error];
            [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
            self.loginButton.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark - Private methods codeSentButtonClick
- (void)codeSentButtonClick{
    DLog(@"发送验证码");
    //验证手机号是否合法，合法调用后台接口，发送手机验证码
    
    DLog(@"mobile:%@",_phoneNumField.text);
    
    if(_phoneNumField.text.isMobileNumber){
        self.messageTipsLabel.text = @"";
        [self.codeSentButton setTitle:@"" forState:UIControlStateNormal];
        [self.sentCodebuttonActivityIndicatorView startAnimating];
        [self.phoneNumField resignFirstResponder];
        //请求发送验证码接口
        [OTWLoginService sentLoginCode:_phoneNumField.text completion:^(id result, NSError *error){
            [self.sentCodebuttonActivityIndicatorView stopAnimating];
            if(result){ //请求成功，需要判断code 是否等于 0
                if([[NSString stringWithFormat:@"%@", result[@"code"]] isEqualToString:@"0"]){
                    [self openCodeCountdown];
                }else{
                    [self.codeSentButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.messageTipsLabel.text = result[@"message"];
                }
            }else{ //请求失败，弹出请求失败结果
                [self netWorkErrorTips:error];
                [self.codeSentButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            }
        }];
    }else{
        DLog(@"输入的手机号错误！");
        self.messageTipsLabel.text = @"输入的手机号错误";
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

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    //string 表示当前输入的字符
//
//    DLog(@"string:%@",string);
//
//    DLog(@"textField tag:%ld",textField.tag);
//
//    if (string.length > 11)
//    {
//        return NO;
//    }
//    return YES;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumField resignFirstResponder];
    [self.codeNumFileld resignFirstResponder];
}


#pragma mark - Setter Getter

#pragma mark -手机号码+验证码背景框

-(UIView *)textFeildBGView{
    if(!_textFeildBGView){
        self.textFeildBGView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationHeight + 10, SCREEN_WIDTH, 101.5)];
        self.textFeildBGView.backgroundColor = [UIColor whiteColor];
    }
    return _textFeildBGView;
}


-(UIView*)underLineOneView{
    if(!_underLineOneView){
        _underLineOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _underLineOneView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineOneView;
}

-(UIView*)underLineTwoView{
    if(!_underLineTwoView){
        _underLineTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.phoneNumberBGView.Height+0.5, SCREEN_WIDTH, 0.5)];
        _underLineTwoView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineTwoView;
}

-(UIView*)underLineThreeView{
    if(!_underLineThreeView){
        _underLineThreeView = [[UIView alloc] initWithFrame:CGRectMake(0, _textFeildBGView.Height-0.5, SCREEN_WIDTH, 0.5)];
        _underLineThreeView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineThreeView;
}

-(UIView*)phoneNumberBGView{
    if(!_phoneNumberBGView){
        _phoneNumberBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, self.textFeildBGView.Witdh, 50)];
    }
    return _phoneNumberBGView;
}

-(UIImageView*)phoneNumImageView{
    if(!_phoneNumImageView){
        _phoneNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 13, 15)];
        _phoneNumImageView.image = [UIImage imageNamed:@"shouji"];
    }
    return _phoneNumImageView;
}

-(UILabel*)phoneNumLabel{
    if(!_phoneNumLabel){
        _phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 58, self.phoneNumberBGView.Height)];
        _phoneNumLabel.font = [UIFont systemFontOfSize:16];
        _phoneNumLabel.textColor = [UIColor color_202020];
        _phoneNumLabel.text = @"手机号";
    }
    return _phoneNumLabel;
}

-(UITextField*)phoneNumField{
    if(!_phoneNumField){
        _phoneNumField= [[UITextField alloc] initWithFrame:CGRectMake(96, 0, self.phoneNumberBGView.Witdh - self.phoneNumLabel.MaxX, self.phoneNumberBGView.Height)];
        _phoneNumField.placeholder = @"输入正确手机号";
        _phoneNumField.backgroundColor = [UIColor clearColor];
        _phoneNumField.delegate = self;
        _phoneNumField.tag = 10000;
        _phoneNumField.font = [UIFont systemFontOfSize:14];
        _phoneNumField.textColor = [UIColor color_979797];
        //只输入数字
        _phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneNumField;
}

#pragma mark - 验证码输入框背景View
-(UIView *)codeNumberBGView
{
    if(!_codeNumberBGView){
        _codeNumberBGView = [[UIView alloc] initWithFrame:CGRectMake(0, self.underLineOneView.Height+self.phoneNumberBGView.Height+self.underLineTwoView.Height, SCREEN_WIDTH, 50.5)];
        _codeNumberBGView.backgroundColor = [UIColor whiteColor];
    }
    return _codeNumberBGView;
}

-(UIImageView*)codeImageView{
    if(!_codeImageView){
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 13, 15)];
        _codeImageView.image = [UIImage imageNamed:@"yanzhengma"];
    }
    return _codeImageView;
}

-(UILabel*)codeLabel{
    if(!_codeLabel){
        _codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 58, self.codeNumberBGView.Height)];
        _codeLabel.text = @"验证码";
        _codeLabel.font = [UIFont systemFontOfSize:16];
    }
    return _codeLabel;
}

#pragma mark - 验证码输入框
- (UITextField *)codeNumFileld{
    if(!_codeNumFileld){
        _codeNumFileld = [[UITextField alloc] initWithFrame:CGRectMake(96, 0, SCREEN_WIDTH-15-75-15-96, self.codeNumberBGView.Height)];
        _codeNumFileld.placeholder = @"验证码";
        _codeNumFileld.backgroundColor = [UIColor clearColor];
        _codeNumFileld.delegate = self;
        _codeNumFileld.tag = 10001;
        
        _codeNumFileld.font = [UIFont systemFontOfSize:14];
        _codeNumFileld.textColor = [UIColor color_979797];
        //只输入数字
        _codeNumFileld.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeNumFileld;
}

#pragma mark - 发送验证码按钮
- (UIButton *)codeSentButton
{
    if(!_codeSentButton){
        _codeSentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeSentButton.frame = CGRectMake(SCREEN_WIDTH-15-75, 9.5, 75, 30);
        _codeSentButton.backgroundColor = [UIColor color_e50834];
        [_codeSentButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeSentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codeSentButton addTarget:self action:@selector(codeSentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _codeSentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _codeSentButton.layer.cornerRadius = 4;
        self.sentCodebuttonActivityIndicatorView.frame = _codeSentButton.bounds;
        [_codeSentButton addSubview:self.sentCodebuttonActivityIndicatorView];
        
        
    }
    return _codeSentButton;
}

-(UIButton*)loginButton
{
    if(!_loginButton){
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(30, self.textFeildBGView.MaxY + 50, SCREEN_WIDTH-30*2, 44);
        _loginButton.backgroundColor = [UIColor color_e50834];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginButton.layer.cornerRadius = 4;
    }
    return _loginButton;
}

-(UIView*)underLineLeftView{
    if(!_underLineLeftView){
        _underLineLeftView = [[UIButton alloc] initWithFrame:CGRectMake(0, 325, (SCREEN_WIDTH-75-16.5*2)/2, 0.5)];
        _underLineLeftView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineLeftView;
}

-(UILabel*)otherLoginLabel{
    if(!_otherLoginLabel){
        _otherLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.underLineLeftView.Witdh+16.5,318, 74, 16.5)];
        _otherLoginLabel.text=@"其他登陆方式";
        _otherLoginLabel.textColor = [UIColor color_979797];
        _otherLoginLabel.font = [UIFont systemFontOfSize:12];
    }
    return _otherLoginLabel;
}

-(UIView*)underLineRightView{
    if(!_underLineRightView){
        _underLineRightView = [[UIView alloc] initWithFrame:CGRectMake(self.underLineLeftView.Witdh+self.otherLoginLabel.Witdh+16.5*2, 325, self.underLineLeftView.Witdh+2,0.5)];
        _underLineRightView.backgroundColor = [UIColor color_d5d5d5];
    }
    return _underLineRightView;
}

-(UIButton*)wechatLoginButton{
    if(!_wechatLoginButton){
        _wechatLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wechatLoginButton setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        _wechatLoginButton.frame = CGRectMake((SCREEN_WIDTH-25*3-30*2)/2, 349.5, 25, 25);
        [_wechatLoginButton addTarget:self action:@selector(wechatLoginBUttonClickedAction) forControlEvents:UIControlEventTouchUpInside];
        _wechatLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _wechatLoginButton;
}

-(UIButton*)qqLoginButton{
    if(!_qqLoginButton){
        _qqLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqLoginButton setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        _qqLoginButton.frame = CGRectMake((SCREEN_WIDTH-25*3-30*2)/2+25+30, 349.5, 25, 25);
        [_qqLoginButton addTarget:self action:@selector(qqLoginBUttonClickedAction) forControlEvents:UIControlEventTouchUpInside];
        _qqLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _qqLoginButton;
}

-(UIButton*)weiboLoginButton{
    if(!_weiboLoginButton){
        _weiboLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weiboLoginButton setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
        _weiboLoginButton.frame = CGRectMake((SCREEN_WIDTH-25*3-30*2)/2+25+30+25+30, 349.5, 25, 25);
        [_weiboLoginButton addTarget:self action:@selector(weiboLoginBUttonClickedAction) forControlEvents:UIControlEventTouchUpInside];
        _weiboLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _weiboLoginButton;
}

-(UIActivityIndicatorView*)sentCodebuttonActivityIndicatorView{
    if(!_sentCodebuttonActivityIndicatorView){
        _sentCodebuttonActivityIndicatorView = [[UIActivityIndicatorView alloc] init];
        [_sentCodebuttonActivityIndicatorView setUserInteractionEnabled:YES]; //点击不传递button事件
        [_sentCodebuttonActivityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _sentCodebuttonActivityIndicatorView;
}

-(UILabel*)messageTipsLabel{
    if(!_messageTipsLabel){
        _messageTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (224-50)+(50-20)/2, SCREEN_WIDTH, 20)];
        _messageTipsLabel.textColor = [UIColor color_e50834];
        _messageTipsLabel.font = [UIFont systemFontOfSize:14];
        _messageTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageTipsLabel;
}

- (void) dealloc
{
    DLog(@"????????>>>>>>>>>> loginController");
}

@end
