////
////  CHBaseAlertView.m
////  HuBanMerchants
////
////  Created by andy on 2016/12/27.
////  Copyright © 2016年 北京致硕网络公司. All rights reserved.
////
//
//#import "CHBaseAlertView.h"
//#import "Masonry.h"
////#import "UIUtils.h"
//
//typedef void(^ClickBlock)(NSInteger index);
//
//@interface CHBaseAlertView()
//
//@property(nonatomic, copy)NSArray *titleArray;
//
//@property(nonatomic, copy)NSArray *messageArray;
//
//@property(nonatomic, copy)NSArray *buttonTitleArrray;
//
//@property(nonatomic, copy)ClickBlock clickBlock;
//
//@property(nonatomic, strong)UIView *grayMaskView;
//
//@property(nonatomic, strong)UIView *alertView;
//
//@property(nonatomic, strong)UILabel *titleLabel;
//
//@property(nonatomic, strong)UILabel *messageLabel;
//@property(nonatomic, strong)UIButton *firstButton;
//
//@property(nonatomic, strong)UIButton *secondButton;
//
//@property(nonatomic, strong)UIView *acrossLineView;
//
//@property(nonatomic, strong)UIView *verticalLineView;
//
//@property(nonatomic, assign)CGFloat alertHeight;
//@end
//
//@implementation CHBaseAlertView
//static CHBaseAlertView *_instace;
//
//static dispatch_queue_t que;
//
///**
// 自定义弹出框
// 
// @param titleArray        标题数组(通过数组换行)
// @param messageArray      内容数组(通过数组换行)
// @param buttonTitleArrray 按钮文字数组(字典数组：{@"color":[uicolor blackcolor],@"title":title})
// @param clickBlock        点击的第几个，0开始
// */
//+ (CHBaseAlertView *)shareBaseAlertViewWithTitleArray:(NSArray *)titleArray
//                            messageArray:(NSArray *)messageArray
//                       buttonTitleArrray:(NSArray *)buttonTitleArrray
//                              clickBlock:(void (^)(NSInteger index))clickBlock {
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instace = [[self alloc] init];
//        _instace.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        _instace.backgroundColor = [UIColor clearColor];
//        
//    });
//    _instace.titleArray = titleArray;
//    _instace.messageArray = messageArray;
//    _instace.buttonTitleArrray = buttonTitleArrray;
//    _instace.clickBlock = clickBlock;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_instace displayView];
//
//    });
//    return _instace;
//}
//
//
//- (void)displayView {
//    self.titleLabel.text = @"";
//    self.messageLabel.text = @"";
//    [self.firstButton setTitle:@"" forState:UIControlStateNormal];
//    [self.secondButton setTitle:@"" forState:UIControlStateNormal];
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    [self addSubview:self.grayMaskView];
//    [self.grayMaskView addSubview:self.alertView];
//    
////    无标题，有内容
////    if ([UIUtils isEmptyWithObject:self.titleArray] && ![UIUtils isEmptyWithObject:self.messageArray]) {
////        
////        
////    }
//    self.alertHeight = 44 + 0.5 + 20 + 20;
//    //有标题，没有内容
//    if (![UIUtils isEmptyWithObject:self.titleArray] && [UIUtils isEmptyWithObject:self.messageArray]) {
//        
//        [self loadTitle];
//        
//        
//    }
//    //有标题，也有内容
//    else if (![UIUtils isEmptyWithObject:self.titleArray] && ![UIUtils isEmptyWithObject:self.messageArray]) {
//        [self loadTitleAndMesage];
//    }
//    
//    
//    
//    [self loadTitleButton];
//    [keyWindow addSubview:self];
//
//    
//
//}
//
//- (void)loadTitleButton {
//    
//    NSInteger index = 0;
//    for (NSDictionary *dict in self.buttonTitleArrray) {
//        index++;
//        UIColor *color = dict[@"color"];
//        NSString *title = dict[@"title"];
//        
//        if (color == nil) {
//            color = [UIColor blueColor];
//        }
//        if ([UIUtils isEmptyString:title]) {
//            title = @"确定";
//        }
//        
//        if (index == 1) {
//            [self.firstButton setTitle:title forState:UIControlStateNormal];
//            [self.firstButton setTitleColor:color forState:UIControlStateNormal];
//        }
//        else if (index == 2) {
//            [self.secondButton setTitle:title forState:UIControlStateNormal];
//            [self.secondButton setTitleColor:color forState:UIControlStateNormal];
//
//        }
//        
//    }
//
//    //没有按钮
//    if (index == 0) {
//        
//    }
//    //1个按钮
//    else if (index == 1) {
//        [self.alertView addSubview:self.firstButton];
//        [self.alertView addSubview:self.acrossLineView];
//        [self.firstButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.alertView.mas_left);
//            make.right.equalTo(self.alertView.mas_right);
//            make.bottom.equalTo(self.alertView.mas_bottom);
//            make.height.mas_equalTo(44);
//        }];
//        [self.acrossLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.alertView.mas_left);
//            make.right.equalTo(self.alertView.mas_right);
//            make.bottom.equalTo(self.firstButton.mas_top);
//            make.height.mas_equalTo(0.5);
//        }];
//    }
//    //2个按钮
//    else if (index==2) {
//        [self.alertView addSubview:self.firstButton];
//        [self.alertView addSubview:self.secondButton];
//        [self.alertView addSubview:self.verticalLineView];
//        [self.alertView addSubview:self.acrossLineView];
//        [self.firstButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.alertView.mas_left);
//            make.width.mas_equalTo((270-1)/2.0);
//            make.bottom.equalTo(self.alertView.mas_bottom);
//            make.height.mas_equalTo(44);
//        }];
//        [self.secondButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo((270-1)/2.0);
//            make.right.equalTo(self.alertView.mas_right);
//            make.bottom.equalTo(self.alertView.mas_bottom);
//            make.height.mas_equalTo(44);
//        }];
//        [self.acrossLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.alertView.mas_left);
//            make.right.equalTo(self.alertView.mas_right);
//            make.bottom.equalTo(self.firstButton.mas_top);
//            make.height.mas_equalTo(0.5);
//        }];
//        
//        [self.verticalLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.firstButton.mas_right);
//            make.width.mas_equalTo(0.5);
//            make.bottom.equalTo(self.alertView.mas_bottom);
//            make.height.mas_equalTo(44);
//        }];
//
//       
//        
//        
//    }
//    
//}
//
//- (void)buttonAction:(UIButton *)sender {
//    if (sender == self.firstButton
//        ) {
//        if (self.clickBlock) {
//            self.clickBlock(0);
//        }
//        self.titleArray = @[];
//        self.messageArray = @[];
//        self.buttonTitleArrray = @[];
//    }
//    else if (sender == self.secondButton) {
//        if (self.clickBlock) {
//            self.clickBlock(1);
//        }
//        self.titleArray = @[];
//        self.messageArray = @[];
//        self.buttonTitleArrray = @[];
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.titleLabel.text = @"";
//        self.messageLabel.text = @"";
//        [self.firstButton setTitle:@"" forState:UIControlStateNormal];
//        [self.secondButton setTitle:@"" forState:UIControlStateNormal];
//        [self.firstButton removeFromSuperview];
//        [self.secondButton removeFromSuperview];
//        [self removeFromSuperview];
//
//    });
//    
//    
//    
//}
//
//- (void)loadTitle {
//    CGFloat titleHeight = 0.0;
//    NSString * string = @"";
//    NSInteger index= 0 ;
//    for (NSString *title in self.titleArray) {
//        titleHeight = titleHeight +  [UIUtils commentHeight:title uiFont:[UIFont systemFontOfSize:17] labelWeight:240];
//        
//        if (index==0) {
//            string = title;
//        }
//        else {
//            string = [NSString stringWithFormat:@"\n%@",title];
//        }
//        index++;
//    }
//    self.titleLabel.text = string;
//    self.alertHeight = self.alertHeight+titleHeight;
//    [self.titleLabel sizeToFit];
//
//    self.alertView.bounds = CGRectMake(0, 0, 270, self.alertHeight);
//    self.alertView.center = self.center;
//    
//    self.titleLabel.frame = CGRectMake(15, 20, 240, titleHeight);
//    [self.alertView addSubview:self.titleLabel];
//    
//}
//
//
//
//
//
//- (void)loadTitleAndMesage {
//    CGFloat titleHeight = 0.0;
//    
//    NSInteger titleIndex = 0;
//    NSString *titleString = @"";
//    for (NSString *title in self.titleArray) {
//        titleHeight = titleHeight +  [UIUtils commentHeight:title uiFont:[UIFont systemFontOfSize:17] labelWeight:240];
//        if (titleIndex==0) {
//            titleString = title;
//        }
//        else {
//            titleString = [NSString stringWithFormat:@"%@\n%@",titleString,title];
//        }
//
//        titleIndex++;
//        
//    }
//    CGFloat messageHeight = 0.0;
//    NSString *messageString = @"";
//    
//    NSInteger messageIndex = 0;
//    for (NSString *message in self.messageArray) {
//        messageHeight = messageHeight +  [UIUtils commentHeight:message uiFont:[UIFont systemFontOfSize:14] labelWeight:240];
//        
//        if (messageIndex==0) {
//            messageString = message;
//        }
//        else {
//            messageString = [NSString stringWithFormat:@"%@\n%@",messageString,message];
//        }
//        
//        messageIndex++;
//
//        
//    }
//    [self.alertView addSubview:self.titleLabel];
//    [self.alertView addSubview:self.messageLabel];
//    self.titleLabel.text = titleString;
//    self.messageLabel.text = messageString;
//    [self.titleLabel sizeToFit];
//    [self.messageLabel sizeToFit];
//    self.alertHeight = self.alertHeight+titleHeight+messageHeight+10;
//    
//    self.alertView.bounds = CGRectMake(0, 0, 270, self.alertHeight);
//    self.alertView.center = self.center;
//    self.titleLabel.frame = CGRectMake(15, 20, 240, titleHeight);
//
//    self.messageLabel.frame = CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame)+10, 240, messageHeight);
//    
//    
//}
//
//+ (id)allocWithZone:(struct _NSZone *)zone
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instace = [super allocWithZone:zone];
//        
//    });
//    return _instace;
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    return _instace;
//}
//
//- (UIView *)grayMaskView {
//    if (!_grayMaskView) {
//        _grayMaskView = ({
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            view.backgroundColor = UIColorFromRGBAlpha(0x000000, 0.4);
//            
//            view;
//            
//        });
//    }
//    return _grayMaskView;
//}
//
//- (UIView *)alertView {
//    if (!_alertView) {
//        _alertView = ({
//            UIView *view = [[UIView alloc]init];
//            view.bounds = CGRectMake(0, 0, 270, 120);
//            view.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//            view.backgroundColor = [UIColor color_EFEFf4];
//            view.layer.cornerRadius = 8;
//            [view.layer setMasksToBounds:YES];
//
//            view;
//            
//        });
//    }
//    return _alertView;
//}
//
//- (UILabel *)titleLabel {
//    if (!_titleLabel) {
//        _titleLabel = ({
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//            label.textColor = UIColorFromRGB(0x181818);
//            label.font = [UIFont systemFontOfSize:17];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.numberOfLines = 0;
//            label;
//            
//        });
//    }
//    return _titleLabel;
//}
//
//- (UILabel *)messageLabel {
//    if (!_messageLabel) {
//        _messageLabel = ({
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//            label.textColor = UIColorFromRGB(0x181818);
//            label.font = [UIFont systemFontOfSize:14];
//            label.textAlignment = NSTextAlignmentCenter;
//            label.numberOfLines = 0;
//            label;
//            
//        });
//    }
//    return _messageLabel;
//}
//
//- (UIButton *)firstButton {
//    if (!_firstButton) {
//        _firstButton = ({
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.titleLabel.font = [UIFont systemFontOfSize:17];
//            [button setBackgroundImage:[UIUtils imageWithColor:UIColorFromRGBAlpha(0xefeff4, 1)] forState:UIControlStateHighlighted];
//            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//            [button setBackgroundImage:[UIUtils imageWithColor:UIColorFromRGBAlpha(0xefeff4, 1)] forState:UIControlStateNormal];
//            button;
//            
//        });
//    }
//    return _firstButton;
//}
//
//- (UIButton *)secondButton {
//    if (!_secondButton) {
//        _secondButton = ({
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.titleLabel.font = [UIFont systemFontOfSize:17];
//            
//            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//            ButtonBlueClick;
//            [button setBackgroundImage:[UIUtils imageWithColor:UIColorFromRGBAlpha(0xefeff4, 1)] forState:UIControlStateHighlighted];
//            [button setBackgroundImage:[UIUtils imageWithColor:UIColorFromRGBAlpha(0xefeff4, 1)] forState:UIControlStateNormal];
//            button;
//            
//        });
//    }
//    return _secondButton;
//}
//
//- (UIView *)acrossLineView {
//    if (!_acrossLineView) {
//        _acrossLineView = ({
//            UIView *view = [[UIView alloc]init];
//            view.backgroundColor = UIColorFromRGB(0xD9D9D9);
//            view;
//            
//        });
//    }
//    return _acrossLineView;
//}
//
//- (UIView *)verticalLineView {
//    if (!_verticalLineView) {
//        _verticalLineView = ({
//            UIView *view = [[UIView alloc]init];
//            view.backgroundColor = UIColorFromRGB(0xD9D9D9);
//            view;
//        });
//    }
//    return _verticalLineView;
//}
//
//@end
