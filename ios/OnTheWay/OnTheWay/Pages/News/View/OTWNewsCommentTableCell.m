//
//  OTWNewsCommentTableCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewsCommentTableCell.h"

#import <SDCycleScrollView.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#define OTWCommentUserNameFontColor [UIColor color_202020];
#define OTWCommentTimeFontColor [UIColor color_979797];
#define OTWCommentReplyButtonColor [UIColor color_f4f4f4];

#define OTWCommentUserNameFontSize [UIFont systemFontOfSize:16]
#define OTWCommentTimeFontSize [UIFont systemFontOfSize:12]
#define OTWCommentButtonFontSize [UIFont systemFontOfSize:13]
#define OTWTopicTitleFontSize [UIFont systemFontOfSize:15]

#define OTWCommentUserImageWidth 45
#define OTWSpacing_15 15
#define OTWSpacing_10 10
#define OTWSpacing_5 5

@interface OTWNewsCommentTableCell()

@property (nonatomic,strong) UIView *cellBGV;
@property (nonatomic,strong) UIImageView *userImageV;
@property (nonatomic,strong) UILabel *userNameV;
@property (nonatomic,strong) UILabel *commentTimeV;
@property (nonatomic,strong) UILabel *commentContentV;
@property (nonatomic,strong) UIButton *replyButtonV;

@property (nonatomic,strong) UIView *topicBGV;
@property (nonatomic,strong) UIImageView *topicImageV;
@property (nonatomic,strong) UILabel *topicuserNameV;
@property (nonatomic,strong) UILabel *topicContentV;

@end


@implementation OTWNewsCommentTableCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self iniSubView];
    }
    return self;
}


#pragma mark 初始化cell视图
- (void)iniSubView
{
    //设置cell背景色
    [self setBackgroundColor:[UIColor color_f4f4f4]];
    //用户头像
    [self.cellBGV addSubview:self.userImageV];
    //用户名
    [self.cellBGV addSubview:self.userNameV];
    //评论时间
    [self.cellBGV addSubview:self.commentTimeV];
    //评论内容
    [self.cellBGV addSubview:self.commentContentV];
    //回复按钮
    [self.cellBGV addSubview:self.replyButtonV];
    //足迹背景
    [self.cellBGV addSubview:self.topicBGV];
    //足迹显示图片
    [self.cellBGV addSubview:self.topicImageV];
    //发表足迹用户名
    [self.cellBGV addSubview:self.topicuserNameV];
    //足迹内容
    [self.cellBGV addSubview:self.topicContentV];
    //虚拟背景
    [self addSubview:self.cellBGV];
    
}

- (UIView *)cellBGV
{
    if (!_cellBGV) {
        _cellBGV = [[UIView alloc] init];
        _cellBGV.backgroundColor = [UIColor whiteColor];
    }
    return _cellBGV;
}

- (UIImageView *)userImageV
{
    if (!_userImageV) {
        _userImageV = [[UIImageView alloc] init];
    }
    return _userImageV;
}

- (UILabel *)userNameV
{
    if (!_userNameV) {
        _userNameV = [[UILabel alloc] init];
        _userNameV.textColor = OTWCommentUserNameFontColor;
        _userNameV.font = OTWCommentUserNameFontSize;
    }
    return _userNameV;
}

- (UILabel *)commentTimeV
{
    if (!_commentTimeV) {
        _commentTimeV = [[UILabel alloc] init];
        _commentTimeV.textColor = OTWCommentTimeFontColor;
        _commentTimeV.font = OTWCommentTimeFontSize;
    }
    return _commentTimeV;
}

- (UILabel *)commentContentV
{
    if (!_commentContentV){
        _commentContentV = [[UILabel alloc] init];
        _commentContentV.textColor = OTWCommentUserNameFontColor;
        _commentContentV.font = OTWCommentUserNameFontSize;
        _commentContentV.numberOfLines = 0;
    }
    return _commentContentV;
}

- (UIButton *)replyButtonV
{
    if (!_replyButtonV) {
        _replyButtonV = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButtonV.backgroundColor = OTWCommentReplyButtonColor;
        //button 内边距
        _replyButtonV.titleEdgeInsets = UIEdgeInsetsMake(5, 9.5, 5, 9.5);
        //button 文字居中显示
        _replyButtonV.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _replyButtonV.layer.cornerRadius = 4;
        _replyButtonV.titleLabel.font = OTWCommentButtonFontSize;
        [_replyButtonV setTitle:@"回复" forState:UIControlStateNormal];
        [_replyButtonV setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
    }
    return _replyButtonV;
}


- (UIView *)topicBGV
{
    if (!_topicBGV) {
        _topicBGV = [[UIView alloc] init];
        _topicBGV.backgroundColor = [UIColor color_f4f4f4];
    }
    return _topicBGV;
}

- (UIImageView *)topicImageV
{
    if (!_topicImageV) {
        _topicImageV = [[UIImageView alloc] init];
    }
    return _topicImageV;
}

- (UILabel *)topicuserNameV
{
    if (!_topicuserNameV) {
        _topicuserNameV = [[UILabel alloc] init];
        _topicuserNameV.textColor = OTWCommentUserNameFontColor;
        _topicuserNameV.font = OTWTopicTitleFontSize;
    }
    return _topicuserNameV;
}

- (UILabel *)topicContentV
{
    if (!_topicContentV){
        _topicContentV = [[UILabel alloc] init];
        _topicContentV.textColor = OTWCommentTimeFontColor;
        _topicContentV.font = OTWCommentButtonFontSize;
    }
    return _topicContentV;
}

#pragma mark 设置视图
- (void)setCommentModel:(OTWNewsCommentModel *)commentModel
{
    CGFloat userImageX = 15,userImageY = 15;
    CGRect userImageRect = CGRectMake(userImageX, userImageY, OTWCommentUserImageWidth, OTWCommentUserImageWidth);
    _userImageV.frame = userImageRect;
    [_userImageV setImageWithURL:[NSURL URLWithString:commentModel.sUserImage]];
    _userImageV.layer.cornerRadius = _userImageV.width/2.0;
    _userImageV.layer.masksToBounds = YES;
    
    CGFloat userNameX = CGRectGetMaxX(_userImageV.frame) + OTWSpacing_15;
    CGFloat userNameY = 17.5;
    CGSize userNameSize = [commentModel.sUserName sizeWithAttributes:@{NSFontAttributeName:OTWCommentUserNameFontSize}];
    CGRect userNameRect = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    _userNameV.text = commentModel.sUserName;
    _userNameV.frame = userNameRect;
    
    CGSize commentTimeSize = [commentModel.sCommentTime sizeWithAttributes:@{NSFontAttributeName:OTWCommentTimeFontSize}];
    CGFloat commentTimeX = userNameX;
    CGFloat commentTimeY = CGRectGetMaxY(_userNameV.frame) + 4.5;
    CGRect commentTimeRect = CGRectMake(commentTimeX, commentTimeY, commentTimeSize.width, commentTimeSize.height);
    _commentTimeV.text = commentModel.sCommentTime;
    _commentTimeV.frame = commentTimeRect;
    
    CGFloat commentContentX = userImageX;
    CGFloat commentContentY = CGRectGetMaxY(_userImageV.frame) + OTWSpacing_10;
    CGFloat commentContentW = self.frame.size.width - OTWSpacing_15*2;
    CGSize commentContentSize = [commentModel.sCommentContent boundingRectWithSize:CGSizeMake(commentContentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:OTWCommentUserNameFontSize} context:nil].size;
    CGRect commentContentRect = CGRectMake(commentContentX, commentContentY, commentContentW, commentContentSize.height);
    _commentContentV.text = commentModel.sCommentContent;
    _commentContentV.frame = commentContentRect;
    
    CGFloat replyButtonX = self.frame.size.width - OTWSpacing_15 - 45;
    CGFloat replyButtonY = userNameY;
    CGRect replyButtonRect = CGRectMake(replyButtonX, replyButtonY, 50, 25);
    _replyButtonV.frame = replyButtonRect;
    
    CGFloat topicBGVX = userImageX;
    CGFloat topicBGVY = CGRectGetMaxY(_commentContentV.frame) + OTWSpacing_10;
    CGFloat topicBGVW = self.frame.size.width - OTWSpacing_15*2;
    CGRect topicBGRect = CGRectMake(topicBGVX, topicBGVY, topicBGVW, 79);
    _topicBGV.frame = topicBGRect;
    
    CGFloat topicImageX = userImageX;
    CGFloat topicImageY = topicBGVY;
    CGRect topicImageRect = CGRectMake(topicImageX, topicImageY, 79, 79);
    _topicImageV.frame = topicImageRect;
    [_topicImageV setImageWithURL:[NSURL URLWithString:commentModel.footprint.userHeadImg]];
    
    CGFloat topicuserNameVX = CGRectGetMaxX(_topicImageV.frame) + OTWSpacing_10;
    CGFloat topicuserNameVY = topicImageY + OTWSpacing_10;
    CGSize topicuserNameSize = [commentModel.footprint.userNickname sizeWithAttributes:@{NSFontAttributeName:OTWTopicTitleFontSize}];
    CGRect topicuserNameRect = CGRectMake(topicuserNameVX, topicuserNameVY, topicuserNameSize.width, topicuserNameSize.height);
    _topicuserNameV.text = commentModel.footprint.userNickname;
    _topicuserNameV.frame = topicuserNameRect;
    
    CGFloat topicContentX = topicuserNameVX;
    CGFloat topicContentY = CGRectGetMaxY(_topicuserNameV.frame) + OTWSpacing_5;
    CGFloat topicContentW = self.frame.size.width - OTWSpacing_15*2 - 79 - OTWSpacing_10*2;
    CGSize topicContentSize = [commentModel.footprint.footprintContent boundingRectWithSize:CGSizeMake(topicContentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:OTWCommentButtonFontSize} context:nil].size;
    CGRect topicContentRect = CGRectMake(topicContentX, topicContentY, topicContentW, topicContentSize.height);
    _topicContentV.text = commentModel.footprint.footprintContent;
    _topicContentV.frame = topicContentRect;
    
    CGFloat cellBGH = CGRectGetMaxY(_topicBGV.frame) + OTWSpacing_10;
    CGRect cellBGRect = CGRectMake(0, 0, self.frame.size.width, cellBGH);
    _cellBGV.frame = cellBGRect;
    
    _height = CGRectGetMaxY(_cellBGV.frame) + OTWSpacing_10;

}
@end
