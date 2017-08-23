//
//  CreateShopTFCell.m
//  OnTheWay
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "CreateShopTFCell.h"
#import "CreateShopFormModel.h"
#import <MJExtension.h>


#define TFCellPadding_15 15
#define TFCellPadding_5 5
@interface CreateShopTFCell()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *titleV;
@property (nonatomic,strong) UILabel *requireV;
@property (nonatomic,strong) UITextField *textField;

@end

@implementation CreateShopTFCell

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

- (UILabel*)requireV
{
    if (!_requireV) {
        _requireV = [[UILabel alloc] init];
        _requireV.text = @"*";
        [_requireV setFont:[UIFont systemFontOfSize:16]];
        CGFloat requireVX = CGRectGetMaxX(self.titleV.frame) + TFCellPadding_5;
        _requireV.frame = CGRectMake(requireVX, 23.5, 8.5, 10);
        _requireV.textColor = [UIColor redColor];
    }
    return _requireV;
}

- (UITextField*)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = [UIColor color_979797];
        _textField.textAlignment = NSTextAlignmentRight;
        CGFloat textFieldX = CGRectGetMaxX(self.requireV.frame) + TFCellPadding_15;
        CGFloat textFieldW = SCREEN_WIDTH -  CGRectGetMaxX(self.requireV.frame) - TFCellPadding_15 * 2;
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
- (void)refreshContent:(CreateShopModel *)createModel formModel:(CreateShopFormModel *)formModel
{
    [self clearCellData];
    if (!createModel) {
        return;
    }
    _createShopModel = createModel;
    _formModel = formModel;
    self.titleV.text = createModel.title;
    self.textField.placeholder = createModel.placeholder;
    self.textField.text = [formModel valueForKey:createModel.key];
    if (createModel.isRequire) {
        self.requireV.hidden = NO;
    } else {
        self.requireV.hidden = YES;
    }
}

+(CGFloat)cellHeight:(CreateShopModel *)createModel
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
    [_formModel setValue:textField.text forKey:_createShopModel.key];
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
