//
//  OTWPersonalCashTVTableViewCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/29.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalCashTVTableViewCell.h"
#import "OTWPersonalCashFormModel.h"
#import <MJExtension.h>

#define TFCellPadding_15 15
#define TFCellPadding_5 5

@interface OTWPersonalCashTVTableViewCell() <UITextFieldDelegate>

@property (nonatomic,strong) UILabel *titleV;
@property (nonatomic,strong) UILabel *rightContentV;
@property (nonatomic,strong) UIView *rightContentViewV;
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UINavigationController *mainControl;

@end
@implementation OTWPersonalCashTVTableViewCell

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
    [self addSubview:self.rightContentViewV];
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
-(UIView*)rightContentViewV{
    if(!_rightContentViewV){
        _rightContentViewV=[[UIView alloc]init];
    }
    [_rightContentViewV addSubview:self.rightContentV];
    
    UITapGestureRecognizer  *tapGestur=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForChooseBank)];
    [_rightContentViewV addGestureRecognizer:tapGestur];
    return _rightContentViewV;
}

- (UILabel*)rightContentV
{
    if (!_rightContentV) {
        _rightContentV = [[UILabel alloc] init];
        [_rightContentV setFont:[UIFont systemFontOfSize:14]];
        _rightContentV.textColor = [UIColor color_979797];
        _rightContentV.textAlignment = NSTextAlignmentRight;
           }
    return _rightContentV;
}
- (UIImageView*)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 7, 12)];
        [_backImageView setImage:[UIImage imageNamed:@"arrow_right"]];
    }
    return _backImageView;
}

#pragma mark 清除cell值
- (void)clearCellData
{
    self.titleV.text = @"";
    self.rightContentV.text=@"";
}

#pragma mark 重置设置cellModel
- (void)refreshContent:(OTWPersonalCashModel *)createModel formModel:(OTWPersonalCashFormModel *)formModel control:(UINavigationController *)control
{
    [self clearCellData];
    if (!createModel) {
        return;
    }
    _OTWPersonalCashModel = createModel;
    _formModel = formModel;
    self.mainControl = control;
    self.titleV.text = createModel.title;
    CGFloat rightContentVX = CGRectGetMaxX(self.titleV.frame) + TFCellPadding_15;
    CGFloat rightContentVW = SCREEN_WIDTH -  CGRectGetMaxX(self.titleV.frame) - TFCellPadding_15 * 2  - 12;
    self.rightContentViewV.frame = CGRectMake(rightContentVX, TFCellPadding_15, rightContentVW+self.backImageView.Witdh+10, 20);
    self.rightContentV.frame=CGRectMake(0, 0, rightContentVW, 20);
    self.rightContentV.text=createModel.placeholder;

    [self setAccessoryView:self.backImageView];
}

+(CGFloat)cellHeight:(OTWPersonalCashModel *)createModel
{
    if (!createModel) {
        return 50.f;
    }
    return 50.f;
}
-(void)tapActionForChooseBank{
    DLog(@"点击了选择银行卡");
}

@end
