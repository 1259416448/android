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
@property(nonatomic,strong) UIView *cellBGV;
    @property (nonatomic,strong) UILabel *username;
    @property (nonatomic,strong) UILabel *time;
    @property (nonatomic,strong) UILabel *content;
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
    [self setBackgroundColor:[UIColor whiteColor]];
    //头像
    [self.cellBGV addSubview:self.userImage];
    //用户名
    [self.cellBGV addSubview:self.username];
    //点赞时间
    [self.cellBGV addSubview:self.time];
    //点赞提示
    [self.cellBGV addSubview:self.content];
    [self addSubview:self.cellBGV];
    
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

-(UIView*)cellBGV
{
    if (!_cellBGV) {
        _cellBGV = [[UIView alloc] init];
        _cellBGV.backgroundColor = [UIColor whiteColor];
    }
    return _cellBGV;
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
    
    CGSize timeSize = [praise.time sizeWithAttributes:@{NSFontAttributeName:OTWPraiseTimeFont}];
    CGFloat timeX = usernameX;
    CGFloat timeY = CGRectGetMaxY(_username.frame) + 3;
    CGRect timeRect = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    _time.text = praise.time;
    _time.frame = timeRect;
    
    CGFloat contentX = timeX;
    CGFloat contentY = CGRectGetMaxY(_time.frame) + OTWStatusTableViewCellControlSpacing;
    CGFloat conteneW = SCREEN_WIDTH - OTWTableViewPadding*2;
    CGSize contentSize=[praise.content boundingRectWithSize:CGSizeMake(conteneW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: OTWPraiseUserNameFont} context:nil].size;
    CGRect contentRect = CGRectMake(contentX, contentY, conteneW, contentSize.height);
    _content.text = praise.content;
    _content.frame = contentRect;
    
    _height = 84 + 15;
}

@end
