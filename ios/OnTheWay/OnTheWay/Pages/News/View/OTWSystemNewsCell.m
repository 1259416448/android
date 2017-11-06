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

@property (nonatomic,strong) UIImageView *arrow;


@property (nonatomic,strong) UILabel *newsTitleLabel;

@property (nonatomic,strong) UILabel *newsTimeLabel;

@property (nonatomic,strong) UILabel *newsContentLabel;

@end

@implementation OTWSystemNewsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView systemNewsCellframe:(OTWSystemNewsModel *) frame
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
        [self.newsBGView addSubview:self.arrow];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 92.5, SCREEN_WIDTH - 15, 0.5)];
        line.backgroundColor = [UIColor color_d5d5d5];
        [self.newsBGView addSubview:line];
    }
    return self;
}

-(void)setSystemNewsFrame:(OTWSystemNewsModel *) frame
{
    _model = frame;
    [self settingData];
//    [self settingFrame];
    
    
}

- (void)settingData
{
    OTWSystemNewsModel *model = self.model;
    [self.newsTitleLabel setText:model.title];
    [self.newsTimeLabel setText:model.dateCreatedStr];
    [self.newsContentLabel setText:model.content];
    
}
- (void)layoutSubviews
{
    CGFloat padding = 15;
    
    //系统消息标题
    CGFloat newsTitleX = 15;
    CGFloat newsTitleY = 15;
    CGFloat newsTitleW = SCREEN_WIDTH - 2*padding - 12 - 100;
    CGFloat newsTitleH = 20;
    _newsTitleLabel.frame = CGRectMake(newsTitleX, newsTitleY, newsTitleW, newsTitleH);
    
    //系统时间
    CGFloat newsTimeX = SCREEN_WIDTH - padding - 100;
    CGFloat newsTimeY = 15;
    CGFloat newsTimeW = 100;
    CGFloat newsTimeH = 12;
    _newsTimeLabel.frame = CGRectMake(newsTimeX, newsTimeY, newsTimeW, newsTimeH);
    
    //系统消息内容
    CGFloat newsContentX = 15;
    CGFloat newsContentY = newsTitleH + newsTitleY + 5;
    CGFloat newsContentW = SCREEN_WIDTH - 15 - 77;
    CGFloat newsContentH = 38;
    _newsContentLabel.frame = CGRectMake(newsContentX, newsContentY, newsContentW, newsContentH);
    
    _newsBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    
    self.arrow.frame = CGRectMake(SCREEN_WIDTH - 15 - 7, (93 - 12) / 2, 7, 12);
    
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
        _newsTimeLabel.textAlignment = NSTextAlignmentRight;
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

-(UIImageView *)arrow
{
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 15 - 7, (self.frame.size.height - 12) / 2, 7, 12)];
        _arrow.image = [UIImage imageNamed:@"arrow_right"];
    }
    return _arrow;
}


@end
