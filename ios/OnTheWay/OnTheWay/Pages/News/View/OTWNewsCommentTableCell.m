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

#define OTWCommentUserNameFontSize [UIFont systemFontOfSize:14]
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
    [self setBackgroundColor:[UIColor whiteColor]];
    //用户头像
    [self addSubview:self.userImageV];
    //用户名
    [self addSubview:self.userNameV];
    //评论时间
    [self addSubview:self.commentTimeV];
    //评论内容
    [self addSubview:self.commentContentV];
    //虚拟背景
//    [self addSubview:self.cellBGV];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 83.5, SCREEN_WIDTH - 15, 0.5)];
    line.backgroundColor = [UIColor color_d5d5d5];
    [self addSubview:line];
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
        _userImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        _userImageV.layer.masksToBounds = YES;
        _userImageV.layer.cornerRadius = 15;
    }
    return _userImageV;
}

- (UILabel *)userNameV
{
    if (!_userNameV) {
        _userNameV = [[UILabel alloc] initWithFrame:CGRectMake(55, 14, SCREEN_WIDTH - 55 - 37, 18)];
        _userNameV.textColor = OTWCommentUserNameFontColor;
        _userNameV.font = OTWCommentUserNameFontSize;
    }
    return _userNameV;
}

- (UILabel *)commentTimeV
{
    if (!_commentTimeV) {
        _commentTimeV = [[UILabel alloc] initWithFrame:CGRectMake(55, CGRectGetMaxY(self.userNameV.frame) + 1, SCREEN_WIDTH - 55 - 37, 14)];
        _commentTimeV.textColor = OTWCommentTimeFontColor;
        _commentTimeV.font = OTWCommentTimeFontSize;
    }
    return _commentTimeV;
}

- (UILabel *)commentContentV
{
    if (!_commentContentV){
        _commentContentV = [[UILabel alloc] initWithFrame:CGRectMake(55, CGRectGetMaxY(self.commentTimeV.frame) + 8, SCREEN_WIDTH - 55 - 37, 15)];
        _commentContentV.textColor = UIColorFromRGB(0x0e0e0e);
        _commentContentV.font = [UIFont systemFontOfSize: 13];
    }
    return _commentContentV;
}

#pragma mark 设置视图
- (void)setCommentModel:(OTWNewsCommentModel *)commentModel
{
//    CGFloat userImageX = 15,userImageY = 15;
//    CGRect userImageRect = CGRectMake(userImageX, userImageY, OTWCommentUserImageWidth, OTWCommentUserImageWidth);
//    _userImageV.frame = userImageRect;
    [_userImageV setImageWithURL:[NSURL URLWithString:commentModel.userHeadImg]];
//    _userImageV.layer.cornerRadius = _userImageV.width/2.0;
//    _userImageV.layer.masksToBounds = YES;
    
//    CGFloat userNameX = CGRectGetMaxX(_userImageV.frame) + OTWSpacing_15;
//    CGFloat userNameY = 17.5;
//    CGSize userNameSize = [commentModel.userNickname sizeWithAttributes:@{NSFontAttributeName:OTWCommentUserNameFontSize}];
//    CGRect userNameRect = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    _userNameV.text = commentModel.userNickname;
//    _userNameV.frame = userNameRect;
    
//    CGSize commentTimeSize = [commentModel.dateCreatedStr sizeWithAttributes:@{NSFontAttributeName:OTWCommentTimeFontSize}];
//    CGFloat commentTimeX = userNameX;
//    CGFloat commentTimeY = CGRectGetMaxY(_userNameV.frame) + 4.5;
//    CGRect commentTimeRect = CGRectMake(commentTimeX, commentTimeY, commentTimeSize.width, commentTimeSize.height);
    _commentTimeV.text = commentModel.dateCreatedStr;
//    _commentTimeV.frame = commentTimeRect;
    
//    CGFloat commentContentX = commentTimeX;
//    CGFloat commentContentY = CGRectGetMaxY(_commentTimeV.frame) + OTWSpacing_10;
//    CGFloat commentContentW = SCREEN_WIDTH - OTWSpacing_15*2 - OTWCommentUserImageWidth - 22;
//    CGRect commentContentRect = CGRectMake(commentContentX, commentContentY, commentContentW, 15);
    NSString *tips = @"";
    if (commentModel.footprintContent && ![commentModel.footprintContent isEqualToString:@""]) {
        tips = [NSString stringWithFormat:@"%@%@",@"评论了这条足迹：",commentModel.footprintContent];
    } else {
        tips = @"评论了这条足迹：";
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:tips];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor color_757575] range:NSMakeRange(0,8)];
    _commentContentV.attributedText = attrString;
    
//    _commentContentV.frame = commentContentRect;
}

- (void)setPraiseModel:(OTWPraiseViewModel *) praise
{
    [_userImageV setImageWithURL:[NSURL URLWithString:praise.userHeadImg]];
    _userNameV.text = praise.userNickname;
    _commentTimeV.text = praise.dateCreatedStr;
    NSString *tips = @"";
    if (praise.footprintContent && ![praise.footprintContent isEqualToString:@""]) {
        tips = [NSString stringWithFormat:@"%@%@",@"赞了这条足迹：",praise.footprintContent];
    } else {
        tips = @"赞了这条足迹：";
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:tips];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor color_757575] range:NSMakeRange(0,7)];
    _commentContentV.attributedText = attrString;
}



@end
