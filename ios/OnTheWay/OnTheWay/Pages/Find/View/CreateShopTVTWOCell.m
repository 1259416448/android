//
//  CreateShopTVTWOCell.m
//  OnTheWay
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "CreateShopTVTWOCell.h"

#define TFCellPadding_15 15
#define TFCellPadding_5 5
@interface CreateShopTVTWOCell()

@property (nonatomic,strong) UILabel *titleV;
@property (nonatomic,strong) UILabel *childTitleV;

@end

@implementation CreateShopTVTWOCell

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
    self.detailTextLabel.textColor = [UIColor color_979797];
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.titleV];
    [self addSubview:self.childTitleV];
}

- (UILabel*)titleV
{
    if (!_titleV) {
        _titleV = [[UILabel alloc] initWithFrame:CGRectMake(TFCellPadding_15, TFCellPadding_15, 100, 20)];
        [_titleV setFont:[UIFont systemFontOfSize:16]];
        [_titleV setBackgroundColor:[UIColor whiteColor]];
    }
    return _titleV;
}

- (UILabel*)childTitleV
{
    if (!_childTitleV) {
        _childTitleV = [[UILabel alloc] initWithFrame:CGRectMake(TFCellPadding_15, CGRectGetMaxY(self.titleV.frame) + 5, 110, 20)];
        [_childTitleV setFont:[UIFont systemFontOfSize:14]];
        [_childTitleV setBackgroundColor:[UIColor whiteColor]];
        _childTitleV.textColor = [UIColor color_999999];
    }
    return _childTitleV;
}

+(CGFloat)cellHeight:(CreateShopModel *)createModel
{
    if (!createModel) {
        return 50.f;
    }
    return 75.f;
}

#pragma mark 清除cell值
- (void)clearCellData
{
    self.titleV.text = @"";
    self.childTitleV.text = @"";
}

#pragma mark 重置cell值
- (void)refreshContent:(CreateShopModel *)createModel
{
    [self clearCellData];
    if (!createModel) {
        return;
    }
    _createShopModel = createModel;
    self.titleV.text = createModel.title;
    self.childTitleV.text = createModel.placeholder;
}

@end
