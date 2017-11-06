//
//  CreateShopTVCell.m
//  OnTheWay
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "CreateShopTVCell.h"
#import "OTWSelectBarViewController.h"

#define TFCellPadding_15 15
#define TFCellPadding_5 5
@interface CreateShopTVCell()<OTWSelectBarViewControllerDelegate>

@property (nonatomic,strong) UILabel *titleV;
@property (nonatomic,strong) UILabel *requireV;
@property (nonatomic,strong) UILabel *rightContentV;
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UINavigationController *mainControl;

@end

@implementation CreateShopTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    [self addSubview:self.rightContentV];
}

- (UILabel*)titleV
{
    if (!_titleV) {
        _titleV = [[UILabel alloc] init];
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
        _requireV.textColor = [UIColor redColor];
    }
    return _requireV;
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

+(CGFloat)cellHeight:(CreateShopModel *)createModel
{
    if (!createModel) {
        return 50.f;
    }
    return 50.f;
}

#pragma mark 清除cell值
- (void)clearCellData
{
    self.titleV.text = @"";
    self.rightContentV.text = @"";
}

#pragma mark 重置cell值
- (void)refreshContent:(CreateShopModel *)createModel formModel:(CreateShopFormModel *)formModel control:(UINavigationController *)control
{
    [self clearCellData];
    if (!createModel) {
        return;
    }
    _createShopModel = createModel;
    _formModel = formModel;
    self.mainControl = control;
    if (createModel.isRequire) {
        self.requireV.hidden = NO;
    } else {
        self.requireV.hidden = YES;
    }
    
    self.titleV.frame = CGRectMake(TFCellPadding_15, TFCellPadding_15, createModel.titileW, 20);
    self.titleV.text = createModel.title;
    
    CGFloat requireVX = CGRectGetMaxX(self.titleV.frame) + TFCellPadding_5;
    self.requireV.frame = CGRectMake(requireVX, 23.5, 8.5, 10);
    
    if (createModel.cellType == CreateSHopCellType_TV_BACK) {
        CGFloat rightContentVX = CGRectGetMaxX(self.requireV.frame) + TFCellPadding_15;
        CGFloat rightContentVW = SCREEN_WIDTH -  CGRectGetMaxX(self.requireV.frame) - TFCellPadding_15 * 2 - 13 - 12;
        _rightContentV.frame = CGRectMake(rightContentVX, TFCellPadding_15, rightContentVW, 20);
        [self setAccessoryView:self.backImageView];
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toChildView)];
        [_rightContentV addGestureRecognizer:labelTapGestureRecognizer];
        _rightContentV.userInteractionEnabled = YES;
    } else {
        CGFloat rightContentVX = CGRectGetMaxX(self.requireV.frame) + TFCellPadding_15;
        CGFloat rightContentVW = SCREEN_WIDTH -  CGRectGetMaxX(self.requireV.frame) - TFCellPadding_15 * 2;
        _rightContentV.frame = CGRectMake(rightContentVX, TFCellPadding_15, rightContentVW, 20);
    }
    
    if ([formModel valueForKey:createModel.key] && ![[formModel valueForKey:createModel.key] isEqualToString:@""]) {
        self.rightContentV.text = [formModel valueForKey:createModel.key];
    } else {
        self.rightContentV.text = createModel.placeholder;
    }
    
}

- (void)toChildView
{
    if ([_createShopModel.title isEqualToString:@"证件类型"]) {
    }else{
        OTWSelectBarViewController *addNewShopNextVC = [[OTWSelectBarViewController alloc] init];
        addNewShopNextVC.delegate = self;
        [self.mainControl pushViewController:addNewShopNextVC animated:NO];
    }
}

- (void)didSelected:(NSString *)str
{
    if (_delegate && [_delegate respondsToSelector:@selector(didChangeType:)]) {
        [_delegate didChangeType:str];
    }
}

@end
