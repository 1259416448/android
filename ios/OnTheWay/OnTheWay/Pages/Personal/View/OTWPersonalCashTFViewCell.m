//
//  OTWPersonalCashTFViewCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/29.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalCashTFViewCell.h"
#import "OTWPersonalCashFormModel.h"
#import <MJExtension.h>

#define TFCellPadding_15 15
#define TFCellPadding_5 5

@interface OTWPersonalCashTFViewCell() <UITextFieldDelegate>

@property (nonatomic,strong) UILabel *titleV;
@property (nonatomic,strong) UILabel *requireV;
@property (nonatomic,strong) UITextField *textField;

@end

@implementation OTWPersonalCashTFViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView
{
    //设置cell背景色
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.titleV];
    [self addSubview:self.requireV];
    [self addSubview:self.textField];
}

- (UILabel*)titleV
{
    if (!_titleV) {
        _titleV = [[UILabel alloc] initWithFrame:CGRectMake(TFCellPadding_15, TFCellPadding_15, 70, 20)];
        [_titleV setFont:[UIFont systemFontOfSize:16]];
        [_titleV setBackgroundColor:[UIColor whiteColor]];
    }
    return _titleV;
}



- (UITextField*)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = [UIColor color_979797];
        _textField.textAlignment = NSTextAlignmentRight;
        CGFloat textFieldX = CGRectGetMaxX(self.titleV.frame) + TFCellPadding_15;
        CGFloat textFieldW = SCREEN_WIDTH -  CGRectGetMaxX(self.titleV.frame) - TFCellPadding_15 * 2;
        _textField.frame = CGRectMake(textFieldX, 10, textFieldW, 30);
        _textField.delegate = self;
    }
    return _textField;
}

#pragma mark 清除cell值
- (void)clearCellData
{
    self.titleV.text = @"";
    self.textField.text = @"";
    self.textField.placeholder = @"";
}

#pragma mark 重置设置cellModel
- (void)refreshContent:(OTWPersonalCashModel *)createModel formModel:(OTWPersonalCashFormModel *)formModel 
{
    [self clearCellData];
    if (!createModel) {
        return;
    }
    _OTWPersonalCashModel = createModel;
    _formModel = formModel;
    self.titleV.text = createModel.title;
    self.textField.placeholder = createModel.placeholder;
    self.textField.text = [formModel valueForKey:createModel.key];
    [self.textField setValue:[UIColor color_979797] forKeyPath:@"_placeholderLabel.textColor"];
}

+(CGFloat)cellHeight:(OTWPersonalCashModel *)createModel
{
    if (!createModel) {
        return 50.f;
    }
    return 50.f;
}

#pragma mark 填写框变化检测
- (void)textFiledEditChanged : (NSNotification*)obj
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self addNotification];
}

#pragma mark 文字编辑结束事件
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_formModel setValue:textField.text forKey:_OTWPersonalCashModel.key];
    DLog(@"现有formmodel对象值%@",_formModel.mj_keyValues);
    [self clearNotification];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:nil];
}

- (void)clearNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}



@end
