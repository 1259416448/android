//
//  OTWPraiseViewTableCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPraiseViewTableCell.h"
#import "OTWPraiseViewModel.h"

#import <SDCycleScrollView.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#define OTWPraiseUserNameFont [UIFont systemFontOfSize:16]
#define OTWPraiseTimeFont [UIFont systemFontOfSize:12]
#define OTWPraiseContentFont [UIFont systemFontOfSize:16]
#define OTWStatusableViewCellUserNameFont [UIFont systemFontOfSize:14]
#define OTWSPraiseTopicTitleFont [UIFont systemFontOfSize:15]
#define OTWSPraiseTopicConentFont [UIFont systemFontOfSize:13]
#define OTWPraiseUserImageWidth 45
#define OTWPraiseUserImageHeight 45
#define OTWPraiseTopicImageWidth 79
#define OTWStatusTableViewCellControlSpacing 10
#define OTWPraiseContentSpacing 5
#define OTWTableViewPadding 15
#define OTWTopicConentHeight 36
#define OTWPraiseReplyButtonWidth 50
#define OTWPraiseReplyButtonHeigth 25


@interface OTWPraiseViewTableCell()<UITextFieldDelegate>
    @property (nonatomic,strong) UIImageView *userImage;
    @property (nonatomic,strong) UILabel *username;
    @property (nonatomic,strong) UIButton *replyButton;
    @property (nonatomic,strong) UIView *cellBG;
    @property (nonatomic,strong) UILabel *time;
    @property (nonatomic,strong) UILabel *content;
    @property (nonatomic,strong) UILabel *topicContent;
    @property (nonatomic,strong) UIView *topicBG;
    @property (nonatomic,strong) UIImageView *topicImage;
    @property (nonatomic,strong) UILabel *topicTitle;
@end

@implementation OTWPraiseViewTableCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

#pragma mark 初始化视图
- (void)initSubView
{
    [self setBackgroundColor:[UIColor color_f4f4f4]];
    //头像
    [self.cellBG addSubview:self.userImage];
    //用户名
    [self.cellBG addSubview:self.username];
    //回复按钮
    [self.cellBG addSubview:self.replyButton];
    //点赞时间
    [self.cellBG addSubview:self.time];
    //点赞提示
    [self.cellBG addSubview:self.content];
    //topic背景
    [self.cellBG addSubview:self.topicBG];
    //topic文章图片
    [self.cellBG addSubview:self.topicImage];
    //topic文章标题
    [self.cellBG addSubview:self.topicTitle];
    //文章内容
    [self.cellBG addSubview:self.topicContent];
    //加入背景
    [self addSubview:self.cellBG];
    
}

-(UIImageView *)userImage
{
    if (!_userImage) {
            _userImage = [[UIImageView alloc] init];
    }
    return _userImage;
}

-(UILabel *)username
{
    if (!_username) {
        _username = [[UILabel alloc] init];
        _username.textColor = [UIColor color_202020];
        _username.font = OTWPraiseUserNameFont;
    }
    return _username;
}

-(UIButton *)replyButton
{
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.backgroundColor = [UIColor color_f4f4f4];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
        //    [_replyButton addTarget:self action:@selector(codeSentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _replyButton.titleLabel.font = OTWSPraiseTopicConentFont;
        _replyButton.layer.cornerRadius = 4;
        _replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _replyButton.titleEdgeInsets = UIEdgeInsetsMake(5, 9.5, 5, 9.5);
    }
    return _replyButton;
}

-(UIView *)cellBG
{
    if (!_cellBG) {
        _cellBG = [[UIView alloc] init];
        _cellBG.backgroundColor = [UIColor whiteColor];
        
    }
    return _cellBG;
}

-(UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = [UIColor color_979797];
        _time.font = OTWPraiseTimeFont;
    }
    return _time;
}

-(UILabel *)content
{
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textColor = [UIColor color_202020];
        _content.font = OTWPraiseContentFont;
    }
    return _content;
}

-(UIView *)topicBG
{
    if (!_topicBG) {
        _topicBG = [[UIView alloc] init];
        _topicBG.backgroundColor = [UIColor color_f4f4f4];
    }
    return _topicBG;
}

-(UIImageView *)topicImage
{
    if (!_topicImage) {
            _topicImage = [[UIImageView alloc] init];
    }
    return _topicImage;
}

-(UILabel *)topicTitle
{
    if (!_topicTitle) {
        _topicTitle = [[UILabel alloc] init];
        _topicTitle.textColor = [UIColor color_202020];
        _topicTitle.font = OTWSPraiseTopicTitleFont;
    }
    return _topicTitle;
}

-(UILabel *)topicContent
{
    if (!_topicContent) {
        _topicContent = [[UILabel alloc] init];
        _topicContent.textColor = [UIColor color_979797];
        _topicContent.font = OTWSPraiseTopicConentFont;
        _topicContent.numberOfLines = 0;
    }
    return _topicContent;
}





#pragma mark 设置视图
- (void)setPraiseModel:(OTWPraiseViewModel *) praise
{
    CGFloat userImageX = 15,userImageY = 15;
    CGRect userImageRect = CGRectMake(userImageX, userImageY, OTWPraiseUserImageWidth, OTWPraiseUserImageHeight);
    [_userImage setImageWithURL:[NSURL URLWithString:praise.profile_image]];
    _userImage.frame = userImageRect;
    _userImage.layer.cornerRadius = _userImage.Witdh/2.0;
    _userImage.layer.masksToBounds = YES;
    
    CGFloat usernameX = CGRectGetMaxX(_userImage.frame) + OTWStatusTableViewCellControlSpacing;
    CGFloat usernameY = 17.5;
    CGSize usernameSize=[praise.username sizeWithAttributes:@{NSFontAttributeName: OTWPraiseUserNameFont}];
    CGRect usernameRect = CGRectMake(usernameX, usernameY, usernameSize.width, usernameSize.height);
    _username.text = praise.username;
    _username.frame = usernameRect;
    
    CGFloat replyButtonX = SCREEN_WIDTH - OTWTableViewPadding - 45;
    CGFloat replyButtonY = userImageY;
    CGRect replyButtonRect = CGRectMake(replyButtonX, replyButtonY, OTWPraiseReplyButtonWidth, OTWPraiseReplyButtonHeigth);
    _replyButton.frame = replyButtonRect;
    
    
    CGSize timeSize = [praise.time sizeWithAttributes:@{NSFontAttributeName:OTWPraiseTimeFont}];
    CGFloat timeX = usernameX;
    CGFloat timeY = CGRectGetMaxY(_userImage.frame) - timeSize.height;
    CGRect timeRect = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    _time.text = praise.time;
    _time.frame = timeRect;
    
    CGFloat contentX = userImageX;
    CGFloat contentY = CGRectGetMaxY(_userImage.frame) + OTWStatusTableViewCellControlSpacing;
    CGFloat conteneW = SCREEN_WIDTH - OTWTableViewPadding*2;
    CGSize contentSize=[praise.content boundingRectWithSize:CGSizeMake(conteneW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: OTWPraiseUserNameFont} context:nil].size;
    CGRect contentRect = CGRectMake(contentX, contentY, conteneW, contentSize.height);
    _content.text = praise.content;
    _content.frame = contentRect;
    
    CGFloat topicBGX = userImageX;
    CGFloat topicBGY = CGRectGetMaxY(_content.frame) + OTWStatusTableViewCellControlSpacing;
    CGFloat topicBGW = SCREEN_WIDTH - OTWTableViewPadding*2;
    CGRect topicBGRect = CGRectMake(topicBGX, topicBGY, topicBGW, OTWPraiseTopicImageWidth);
    _topicBG.frame = topicBGRect;
    
    CGFloat topicImageX = userImageX;
    CGFloat topicImageY = topicBGY;
    CGRect topicImageRect = CGRectMake(topicImageX, topicImageY, OTWPraiseTopicImageWidth, OTWPraiseTopicImageWidth);
    [_topicImage setImageWithURL:[NSURL URLWithString:praise.vedio_url]];
    _topicImage.frame = topicImageRect;
    
    CGFloat topicTitleX = CGRectGetMaxX(_topicImage.frame) + OTWStatusTableViewCellControlSpacing;
    CGFloat topicTitleY =topicImageY + OTWStatusTableViewCellControlSpacing;
    CGSize topicTitleSize = [praise.topicTitle sizeWithAttributes:@{NSFontAttributeName:OTWSPraiseTopicTitleFont}];
    CGRect topicTitleRect = CGRectMake(topicTitleX, topicTitleY, topicTitleSize.width, topicTitleSize.height);
    _topicTitle.text = praise.topicTitle;
    _topicTitle.frame = topicTitleRect;
    
    CGFloat topicContentX = topicTitleX;
    CGFloat topicContentY = CGRectGetMaxY(_topicTitle.frame) + OTWPraiseContentSpacing;
    CGFloat topicContentW = SCREEN_WIDTH - OTWTableViewPadding*2 - OTWPraiseTopicImageWidth - OTWStatusTableViewCellControlSpacing*2;
    CGRect topicContentRect = CGRectMake(topicContentX, topicContentY, topicContentW, OTWTopicConentHeight);
    _topicContent.text = praise.topicContent;
    _topicContent.frame = topicContentRect;
    
    CGFloat cellSpaceH = CGRectGetMaxY(_topicBG.frame) + OTWStatusTableViewCellControlSpacing;
    CGRect cellSpaceRect = CGRectMake(0, 0, SCREEN_WIDTH, cellSpaceH);
    _cellBG.frame = cellSpaceRect;
    
    _height = CGRectGetMaxY(_topicBG.frame) + OTWStatusTableViewCellControlSpacing*2;
}

@end
