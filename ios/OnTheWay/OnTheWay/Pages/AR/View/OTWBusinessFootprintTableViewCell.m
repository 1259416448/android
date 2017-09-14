//
//  OTWBusinessFootprintTableViewCell.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/7.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessFootprintTableViewCell.h"
#import "PYPhotosView.h"

#define businessFootprintMarginPadding 5

@interface OTWBusinessFootprintTableViewCell ()

//整体
@property (nonatomic,strong) UIView *commentBGView;

//头像
@property (nonatomic,strong) UIButton *commentUserHeaderImgButton;

//昵称
@property (nonatomic,strong) UIButton *commentUserNicknameButton;

//评论时间
@property (nonatomic,strong) UILabel *commentDateCreatedLabel;

//底部线
@property (nonatomic,strong) UILabel *bottomLine;

//内容
@property (nonatomic,strong) UILabel *contentLabel;

//图片查看
@property (nonatomic,strong) UIView *photoBGView;

//底部内容
@property (nonatomic,strong) UIView *bottomBGView;

//底部回复
@property (nonatomic,strong) UILabel *replyLabel;

//底部点赞按钮
@property (nonatomic,strong) UIView *likeBGView;

//按钮背景图片
@property (nonatomic,strong) UIImageView *likeBGImageView;

@property (nonatomic,strong) UIImage *imageColorD5D5D5;

@property (nonatomic,strong) UIImage *imageColorE50834;

//按钮白色图片信息
@property (nonatomic,strong) UIImageView *likeBGViewWhiteImageView;

//点赞按钮图标
@property (nonatomic,strong) UIImageView *likeImageView;

//点赞数量
@property (nonatomic,strong) UILabel *likeNumLabel;

//+
@property (nonatomic,strong) UILabel *plugLabel;

//点击点赞按钮
@property (nonatomic,strong) UIButton *likeButton;

@end

@implementation OTWBusinessFootprintTableViewCell

static NSString *photoParamsTwo = @"?imageMogr2/thumbnail/!20p";

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *) identifier
{
    return [[OTWBusinessFootprintTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self buildUI];
    }
    return self;
}

/**
 * 构建tableViewCell
 */
- (void) buildUI
{
    [self addSubview:self.commentBGView];
    [self.commentBGView addSubview:self.commentUserHeaderImgButton];
    [self.commentBGView addSubview:self.commentUserNicknameButton];
    [self.commentBGView addSubview:self.commentDateCreatedLabel];
    [self.commentBGView addSubview:self.contentLabel];
    [self.commentBGView addSubview:self.photoBGView];

    [self.commentBGView addSubview:self.bottomBGView];
    [self.bottomBGView addSubview:self.replyLabel];
    [self.bottomBGView addSubview:self.likeBGView];
    [self.likeBGView addSubview:self.likeBGImageView];
    [self.likeBGView addSubview:self.likeBGViewWhiteImageView];
    [self.likeBGView addSubview:self.likeImageView];
    [self.likeBGView addSubview:self.likeNumLabel];
    [self.likeBGView addSubview:self.plugLabel];
    [self.bottomBGView addSubview:self.likeButton];
    
    [self.commentBGView addSubview:self.bottomLine];
}

/**
 * 设置数据
 */
- (void) setData:(OTWBusinessFootprintFrame *) businessFootprintFrame
{
    [self.commentUserHeaderImgButton sd_setImageWithURL:[NSURL URLWithString:businessFootprintFrame.footprintDetail.userHeadImg] forState:UIControlStateNormal];
    self.commentUserHeaderImgButton.imageView.layer.cornerRadius = 15;
    [self.commentUserNicknameButton setTitle:businessFootprintFrame.footprintDetail.userNickname forState:UIControlStateNormal];
    self.commentUserNicknameButton.frame = CGRectMake(self.commentUserHeaderImgButton.MaxX, 16, businessFootprintFrame.nicknameW, 15);
    self.commentDateCreatedLabel.text = businessFootprintFrame.footprintDetail.dateCreatedStr;
    self.contentLabel.text = businessFootprintFrame.footprintDetail.footprintContent;
    
    self.commentBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, businessFootprintFrame.cellHeight);
    CGFloat X = self.commentUserHeaderImgButton.MaxX;
    CGFloat W = SCREEN_WIDTH - X - GLOBAL_PADDING;
    self.commentDateCreatedLabel.frame = CGRectMake(self.commentUserNicknameButton.MinX, self.commentUserNicknameButton.MaxY + 3, W, 10);
    self.contentLabel.frame = CGRectMake(X, self.commentDateCreatedLabel.MaxY+10, W, businessFootprintFrame.contentH);
    
    //图片相关设置
    if(businessFootprintFrame.photoViewH == 0){
        //没有图片
        self.photoBGView.hidden = YES;
        //设置回复、点赞信息 距离顶部位置
        self.bottomBGView.frame = CGRectMake(self.commentUserHeaderImgButton.MaxX, self.contentLabel.MaxY +10 , SCREEN_WIDTH - self.commentUserHeaderImgButton.MaxX , 40);
    }else{
        //有图片
        self.photoBGView.hidden = NO;
        self.photoBGView.frame = CGRectMake(self.contentLabel.MinX, self.contentLabel.MaxY + 5, SCREEN_WIDTH - GLOBAL_PADDING - self.contentLabel.MinX, businessFootprintFrame.photoViewH);
        if(self.photoBGView.subviews && self.photoBGView.subviews.count >0){
            for (UIView *view in self.photoBGView.subviews) {
                [view removeFromSuperview];
            }
        }
        [self.photoBGView addSubview: businessFootprintFrame.photosView];
        self.bottomBGView.frame = CGRectMake(self.commentUserHeaderImgButton.MaxX, self.photoBGView.MaxY +10 , SCREEN_WIDTH - self.commentUserHeaderImgButton.MaxX , 40);
    }
    self.likeBGView.frame = CGRectMake(self.bottomBGView.Witdh - GLOBAL_PADDING - 60, 0, 60, 40);
    self.likeBGView.layer.cornerRadius = 12.5;
    self.likeButton.frame = CGRectMake(self.likeBGView.MinX - 5, self.likeBGView.MinY - 5, 80, 40);
    self.replyLabel.frame = CGRectMake(0, 5, self.bottomBGView.Witdh - self.likeBGView.Witdh - GLOBAL_PADDING - 10, 15);
    //回复信息
    self.replyLabel.text =  [[NSString stringWithFormat:@"%ld",(long)businessFootprintFrame.footprintDetail.footprintCommentNum] stringByAppendingString:   @"条回复"];
    
    if(businessFootprintFrame.footprintDetail.footprintLikeNum > 999){
        self.likeNumLabel.text = @"999";
        self.plugLabel.hidden = NO;
    } else {
        self.likeNumLabel.text = [NSString stringWithFormat:@"%ld",(long)businessFootprintFrame.footprintDetail.footprintLikeNum];
        self.plugLabel.hidden = YES;
    }
    [self setLikeStatus:businessFootprintFrame.footprintDetail.ifLike];
    self.bottomLine.frame = CGRectMake(0, businessFootprintFrame.cellHeight - 0.5, SCREEN_WIDTH, 0.5);
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, businessFootprintFrame.cellHeight);
}

- (void) setLikeStatus:(BOOL) ifLike
{
    if(ifLike){
        self.likeBGImageView.image = self.imageColorE50834;
        self.likeImageView.image = [UIImage imageNamed:@"ar_zan_click"];
        self.likeNumLabel.textColor = [UIColor color_e50834];
        self.plugLabel.textColor = [UIColor color_e50834];
    }else{
        self.likeBGImageView.image = self.imageColorD5D5D5;
        self.likeImageView.image = [UIImage imageNamed:@"ar_zan"];
        self.likeNumLabel.textColor = [UIColor color_202020];
        self.plugLabel.textColor = [UIColor color_202020];
    }
}

#pragma mark - Setter Getter

- (UIView *) commentBGView{
    if(!_commentBGView){
        _commentBGView = [[UIView alloc] init];
        _commentBGView.backgroundColor = [UIColor whiteColor];
    }
    return _commentBGView;
}


- (UIButton *) commentUserHeaderImgButton
{
    if(!_commentUserHeaderImgButton){
        _commentUserHeaderImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentUserHeaderImgButton.imageEdgeInsets  = UIEdgeInsetsMake(15, 15, 0, 10);
        [_commentUserHeaderImgButton addTarget:self action:@selector(userHeaderImgOrNicknameClick:) forControlEvents:UIControlEventTouchUpInside];
        _commentUserHeaderImgButton.frame = CGRectMake(0, 0, 55, 45);
    }
    return _commentUserHeaderImgButton;
}

- (UIButton *) commentUserNicknameButton
{
    if(!_commentUserNicknameButton){
        _commentUserNicknameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentUserNicknameButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_commentUserNicknameButton setTitleColor:[UIColor color_202020] forState:UIControlStateNormal];
        [_commentUserNicknameButton addTarget:self action:@selector(userHeaderImgOrNicknameClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentUserNicknameButton;
}


- (UILabel *) commentDateCreatedLabel
{
    if(!_commentDateCreatedLabel){
        _commentDateCreatedLabel = [[UILabel alloc] init];
        _commentDateCreatedLabel.textColor = [UIColor color_979797];
        _commentDateCreatedLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    }
    return _commentDateCreatedLabel;
}

- (UILabel *) bottomLine
{
    if(!_bottomLine){
        _bottomLine = [[UILabel alloc] init];
        _bottomLine.backgroundColor = [UIColor color_d5d5d5];
    }
    return _bottomLine;
}

- (UILabel *) contentLabel
{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _contentLabel.textColor = [UIColor color_202020];
    }
    return _contentLabel;
}

- (UIView *) photoBGView
{
    if(!_photoBGView){
        _photoBGView = [[UIView alloc] init];
    }
    return _photoBGView;
}

- (UIView *) bottomBGView
{
    if(!_bottomBGView){
        _bottomBGView = [[UIView alloc] init];
        _bottomBGView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBGView;
}

- (UILabel *) replyLabel
{
    if(!_replyLabel){
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _replyLabel.textColor = [UIColor color_979797];
    }
    return _replyLabel;
}

- (UIView *) likeBGView
{
    if(!_likeBGView){
        _likeBGView = [[UIView alloc] init];
        _likeBGView.backgroundColor = [UIColor clearColor];
    }
    return _likeBGView;
}

- (UIImageView *) likeBGImageView
{
    if(!_likeBGImageView){
        _likeBGImageView = [[UIImageView alloc] init];
        _likeBGImageView.frame = CGRectMake(0, 0, 60, 25);
        _likeBGImageView.layer.cornerRadius = 12.5;
        _likeBGImageView.layer.masksToBounds = YES;
    }
    return _likeBGImageView;
}

- (UIImage *) imageColorD5D5D5
{
    if(!_imageColorD5D5D5){
        _imageColorD5D5D5 = [UIImage imageWithColor:[UIColor color_d5d5d5] size:CGSizeMake(60, 25)];
    }
    return _imageColorD5D5D5;
}

- (UIImage *) imageColorE50834
{
    if(!_imageColorE50834){
        _imageColorE50834 = [UIImage imageWithColor:[UIColor color_e50834] size:CGSizeMake(60, 25)];
    }
    return _imageColorE50834;
}

- (UIImageView *) likeBGViewWhiteImageView
{
    if(!_likeBGViewWhiteImageView){
        _likeBGViewWhiteImageView = [[UIImageView alloc] init];
        _likeBGViewWhiteImageView.frame = CGRectMake(0.5, 0.5, 59, 24);
        _likeBGViewWhiteImageView.image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(59, 24)];
        _likeBGViewWhiteImageView.layer.cornerRadius = 12;
        _likeBGViewWhiteImageView.layer.masksToBounds = YES;
    }
    return _likeBGViewWhiteImageView;
}

- (UIImageView *) likeImageView
{
    if(!_likeImageView){
        _likeImageView = [[UIImageView alloc] init];
        _likeImageView.frame = CGRectMake(11.5, 6.5, 12, 12);
        _likeImageView.image = [UIImage imageNamed:@"ar_zan"];
    }
    return _likeImageView;
}

- (UILabel *) likeNumLabel
{
    if(!_likeNumLabel){
        _likeNumLabel = [[UILabel alloc] init];
        _likeNumLabel.backgroundColor = [UIColor clearColor];
        _likeNumLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _likeNumLabel.frame = CGRectMake(self.likeImageView.MaxX + 5, 5.5, 59 - self.likeImageView.MaxX - 5, 14);
    }
    return _likeNumLabel;
}

- (UILabel *) plugLabel
{
    if(!_plugLabel){
        _plugLabel = [[UILabel alloc] init];
        _plugLabel.frame = CGRectMake(60 - 11, 4.5, 8 ,14);
        _plugLabel.text = @"+";
        _plugLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    }
    return _plugLabel;
}

- (UIButton *) likeButton
{
    if(!_likeButton){
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton addTarget:self action:@selector(likeBGTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

#pragma mark - button selector

- (void) userHeaderImgOrNicknameClick:(UIButton *)sender
{
    if(self.block){
        //首先获得Cell：button的父视图是commentBGView -> UITableViewCell
        UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
        self.block(cell);
    }
}

/**
 * 点赞点击
 */
- (void) likeBGTap:(UIButton *)sender
{
    if(self.likeBlock){
        //首先获得Cell：button的父视图是bottomBGView -> commentBGView -> UITableViewCell
        UITableViewCell *cell = (UITableViewCell *) sender.superview.superview.superview;
        self.likeBlock(cell);
    }
}

@end
