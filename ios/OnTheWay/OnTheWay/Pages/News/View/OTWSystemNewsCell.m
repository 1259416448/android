 //
//  OTWSystemNewsCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWSystemNewsCell.h"
#import "OTWSystemNewsCellFrame.h"
#import "OTWSystemNewsModel.h"


#define OTWSystemNewsTitleFont [UIFont systemFontOfSize:16]
#define OTWSystemNewsTimeFont [UIFont systemFontOfSize:11]
#define OTWSystemNewsContentFont [UIFont systemFontOfSize:13]

@interface OTWSystemNewsCell()

@property (nonatomic,strong) UIView *newsBGView;

@property (nonatomic,strong) UILabel *newsTitleLabel;

@property (nonatomic,strong) UILabel *newsTimeLabel;

@property (nonatomic,strong) UILabel *newsContentLabel;

@end

@implementation OTWSystemNewsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView systemNewsCellframe:(OTWSystemNewsCellFrame *) frame
{
    OTWSystemNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemNewsCell"];
    if (!cell) {
        cell = [[OTWSystemNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemNewsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSystemNewsFrame:frame];
        cell.backgroundColor=[UIColor whiteColor];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.newsBGView];
        [self.newsBGView addSubview:self.newsTitleLabel];
        [self.newsBGView addSubview:self.newsTimeLabel];
        [self.newsBGView addSubview:self.newsContentLabel];
    }
    return self;
}

-(void)setSystemNewsFrame:(OTWSystemNewsCellFrame *) frame
{
    _systemNewsCellframe = frame;
    [self settingData];
    [self settingFrame];
    
    
}

- (void)settingData
{
    OTWSystemNewsModel *model = self.systemNewsCellframe.newsmodel;
    [self.newsTitleLabel setText:model.newsTitle];
    [self.newsTimeLabel setText:model.newsTime];
    [self.newsContentLabel setText:model.newsContent];
    
}

- (void)settingFrame
{
    self.newsBGView.frame = self.systemNewsCellframe.newsBGF;
    self.newsTitleLabel.frame = self.systemNewsCellframe.newsTitleF;
    self.newsTimeLabel.frame = self.systemNewsCellframe.newsTimeF;
    self.newsContentLabel.frame = self.systemNewsCellframe.newsContentF;
}

- (UILabel *)newsTitleLabel
{
    if (!_newsTitleLabel) {
        _newsTitleLabel = [[UILabel alloc] init];
        _newsTitleLabel.font = OTWSystemNewsTitleFont;
        _newsTitleLabel.textColor = [UIColor color_202020];
    }
    return _newsTitleLabel;
}

-(UILabel *)newsTimeLabel
{
    if (!_newsTimeLabel) {
        _newsTimeLabel = [[UILabel alloc] init];
        _newsTimeLabel.font = OTWSystemNewsTimeFont;
        _newsTimeLabel.textColor = [UIColor color_979797];
    }
    return _newsTimeLabel;
}

-(UILabel *)newsContentLabel
{
    if (!_newsContentLabel) {
        _newsContentLabel = [[UILabel alloc] init];
        _newsContentLabel.font = OTWSystemNewsContentFont;
        _newsContentLabel.textColor = [UIColor color_979797];
        _newsContentLabel.numberOfLines = 0;
    }
    return _newsContentLabel;
}

-(UIView *)newsBGView
{
    if (!_newsBGView) {
        _newsBGView = [[UIView alloc] init];
        _newsBGView.backgroundColor = [UIColor clearColor];
    }
    return _newsBGView;
}


@end
