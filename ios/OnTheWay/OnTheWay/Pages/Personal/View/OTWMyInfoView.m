//
//  OTWMyInfoView.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/22.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWMyInfoView.h"
#import "UIImage+RoundedCorner.h"

#define infoLabelFont [UIFont fontWithName:@"PingFangSC-Regular" size:14]
#define userNickNameFont [UIFont fontWithName:@"PingFangSC-Medium" size:16]


@interface OTWMyInfoView ()

@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UIView *headerImgBg;
@property (nonatomic,strong) UIImageView *headerLagerImgBG;
@property (nonatomic,strong) UIImageView *headerImg;
@property (nonatomic,strong) UIView *fansBGView;
@property (nonatomic,strong) UILabel *fansLabel;
@property (nonatomic,strong) UILabel *fansNumLabel;
@property (nonatomic,strong) UIView *centerLine;
@property (nonatomic,strong) UIView *likeBGView;
@property (nonatomic,strong) UILabel *likeLabel;
@property (nonatomic,strong) UILabel *likeNumLabel;


@property (nonatomic,assign) BOOL ifMy;

@end

@implementation OTWMyInfoView

+ (instancetype) initWithUserInfo:(NSString*)userNickname userId:(NSString*)userId userHeaderImg:(NSString*)userHeaderImg ifMy:(BOOL) ifMy
{
    OTWMyInfoView *info = [[OTWMyInfoView alloc] init];
    info.userId = userId;
    info.userNickname = userNickname;
    info.userHeaderImg = userHeaderImg;
    info.ifMy = ifMy;
    info.userInteractionEnabled = YES;
    [info buildUI];
    return info;
}

- (void) buildUI
{
    [self addSubview:self.headerImgBg];
    [self.headerImgBg addSubview:self.headerLagerImgBG];
    [self.headerImgBg addSubview:self.headerImg];
    [self addSubview:self.userName];
    [self addSubview:self.fansBGView];
//    [self.fansBGView addSubview:self.fansLabel];
    [self.fansBGView addSubview:self.fansNumLabel];
    if(self.ifMy){
        [self addSubview:self.centerLine];
        [self addSubview:self.likeBGView];
        [self.likeBGView addSubview:self.likeLabel];
        [self.likeBGView addSubview:self.likeNumLabel];
    }
}

- (void) changeFrameOne
{
    CGFloat headerImgBgW = 98;
    CGFloat padding = 15;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.Height);
    self.headerImgBg.frame = CGRectMake((SCREEN_WIDTH-98)/2, 69, headerImgBgW , headerImgBgW);
    self.headerLagerImgBG.frame = CGRectMake(0, 0, headerImgBgW, headerImgBgW);
    self.headerImg.frame = CGRectMake(4, 4, 90 , 90);
    
    CGFloat userNameW = SCREEN_WIDTH - padding * 2;
    CGSize userNicknameSize = [OTWUtils sizeWithString:self.userNickname font:userNickNameFont maxSize:CGSizeMake(userNameW, 22.5)];
    userNameW = userNicknameSize.width;
    self.userName.frame = CGRectMake((SCREEN_WIDTH - userNameW) / 2,self.headerImgBg.MaxY+8 , userNameW , 22.5);
    self.userName.textAlignment=NSTextAlignmentCenter;
    if(self.ifMy){
        self.centerLine.frame = CGRectMake((SCREEN_WIDTH - 1)/2, self.userName.MaxY + 11.5, 1, 10);
        self.likeBGView.frame = CGRectMake(self.centerLine.MaxX + 10 , self.userName.MaxY + 10, SCREEN_WIDTH / 2 - 10 - padding , 13);
        self.likeNumLabel.frame = CGRectMake(self.likeLabel.MaxX + 5 , 0, self.likeBGView.Witdh - self.likeLabel.Witdh - 5, 13);
        CGSize textSize = [self getFansLabelSize];
        self.fansBGView.frame = CGRectMake((SCREEN_WIDTH - 1)/2 - 10 - textSize.width - 5 - 25, self.userName.MaxY + 10, 25 + 5 + textSize.width, 13);
        self.fansNumLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.fansBGView.frame), 13);
    }else{
        CGSize textSize = [self getFansLabelSize];
        self.fansBGView.frame = CGRectMake((SCREEN_WIDTH - textSize.width - 5 - 25)/2, self.userName.MaxY + 10, 25 + 5 + textSize.width, 13);
        self.fansNumLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.fansBGView.frame), 13);
    }
}

- (void) changeFrameTwo
{
    CGFloat headerImgBgW = 49;
    CGFloat marginUserNickName = 15;
    CGFloat headerImgBgX = 15;
    CGRect headerImgBgF = CGRectMake(headerImgBgX, 66 , headerImgBgW , headerImgBgW);
    CGFloat userNameW = SCREEN_WIDTH - CGRectGetMaxX(headerImgBgF) - 15 - marginUserNickName;
    //计算当前昵称允许的最大
    CGSize userNickNameSize = [OTWUtils sizeWithString:self.userNickname font:userNickNameFont maxSize:CGSizeMake(userNameW, 22.5)];
    CGRect userNameF = CGRectMake(CGRectGetMaxX(headerImgBgF) + marginUserNickName , 71.5, userNickNameSize.width, 22.5);
    
    CGSize textSize = [self getFansLabelSizeTwo:userNameW];
    CGRect fansBGViewF = CGRectMake(CGRectGetMinX(userNameF),CGRectGetMaxY(userNameF)+ 5, textSize.width + 25 + 5, 13);
    CGRect fansNumLabelF = CGRectMake(0 , 0, textSize.width + 25 + 5, 13);
    CGRect temp;
    if(self.ifMy){
        CGRect centerLineF = CGRectMake(CGRectGetMaxX(fansBGViewF) + 10,CGRectGetMaxY(userNameF) + 6.5, 1, 10);
        CGFloat likeBGViewW = userNameW - CGRectGetWidth(fansBGViewF) - 10 * 2 - 1;
        CGFloat likeNumLabelW = likeBGViewW - self.likeLabel.MaxX - 5;
        CGSize likeTextSize = [OTWUtils sizeWithString:[NSString stringWithFormat:@"%ld",(long)self.statistics.likeNum] font:infoLabelFont maxSize:CGSizeMake(likeNumLabelW, 13)];
        likeNumLabelW = likeTextSize.width;
        likeBGViewW = likeNumLabelW + self.likeLabel.MaxX +5;
        CGRect likeBGViewF = CGRectMake(CGRectGetMaxX(centerLineF) + 10, CGRectGetMaxY(userNameF) + 5, likeBGViewW, 13);
        temp = likeBGViewF;
        CGRect likeNumLabelF = CGRectMake(self.likeLabel.MaxX + 5, 0,likeNumLabelW, 13);
        self.centerLine.frame = centerLineF;
        self.likeBGView.frame = likeBGViewF;
        self.likeNumLabel.frame = likeNumLabelF;
    }else{
        temp = fansBGViewF;
    }

    //计算一下当前总长度
    
    //头像 + 昵称
    CGFloat one = CGRectGetMaxX(userNameF);
    //头像 + 粉丝 + 关注
    CGFloat two = CGRectGetMaxX(temp);
    //比较选择以谁为基准进行居中移动
    CGFloat x ; //整体偏移量
    if(one < two){
        //屏幕宽 - two - 默认padding 15
         x =  (SCREEN_WIDTH - two - 15) / 2 ;
    }else{
         x = (SCREEN_WIDTH - one - 15) /2 ;
    }
    if(x > 0){
        self.frame = CGRectMake(x, 0, SCREEN_WIDTH, self.Height);
    }
    
    self.headerImgBg.frame = headerImgBgF;
    self.headerLagerImgBG.frame = CGRectMake(0, 0, headerImgBgW, headerImgBgW);
    self.headerImg.frame = CGRectMake(2, 2, 45 , 45);
    self.userName.frame = userNameF;
    self.fansBGView.frame = fansBGViewF;
    self.fansNumLabel.frame = fansNumLabelF;
}
-(void) refleshData
{
    NSString * str = [NSString stringWithFormat:@"粉丝 %ld",(long)self.statistics.fansNum];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    // 设置字体和设置字体的范围
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:12.f]
                    range:NSMakeRange(0, 2)];
    if (_ifMy) {
        self.fansNumLabel.textAlignment = NSTextAlignmentRight;
    }else{
        self.fansNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    self.fansNumLabel.attributedText = attrStr;

    self.likeNumLabel.text = [NSString stringWithFormat:@"%ld",(long)self.statistics.likeNum];
}

-(CGSize) getFansLabelSize
{
    CGFloat maxW = SCREEN_WIDTH / 2 - 10 - 25 - 5 - 15;
    if(!self.ifMy){
        maxW = SCREEN_WIDTH - 25 - 5 - 15 * 2;
    }
    CGSize textSize = [OTWUtils sizeWithString:[NSString stringWithFormat:@"%ld",(long)self.statistics.fansNum] font:infoLabelFont maxSize:CGSizeMake(maxW, 13)];
    return textSize;
}

-(CGSize) getFansLabelSizeTwo:(CGFloat)userNameW
{
    CGFloat maxW = userNameW / 2 - 25 - 5 - 10;
    if(!self.ifMy){
        maxW = userNameW - 25 - 5;
    }
    CGSize textSize = [OTWUtils sizeWithString:[NSString stringWithFormat:@"%ld",(long)self.statistics.fansNum] font:infoLabelFont maxSize:CGSizeMake(maxW, 13)];
    return textSize;
}

#pragma mark - Setter Getter

- (UIView*)headerImgBg{
    if(!_headerImgBg){
        _headerImgBg=[[UIView alloc] init];
        _headerImgBg.layer.masksToBounds = YES;
        _headerImgBg.backgroundColor=[UIColor clearColor];
    }
    return _headerImgBg;
}

-(UIImageView*)headerImg{
    if(!_headerImg){
        _headerImg=[[UIImageView alloc]init];
        [_headerImg sd_setImageWithURL:[NSURL URLWithString:_userHeaderImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(image){
                _headerImg.image = [image roundedCornerImageWithCornerRadius:80];
            }
        }];
    }
    return _headerImg;
}

-(UILabel*)userName{
    if(!_userName){
        _userName=[[UILabel alloc] init];
        _userName.text=_userNickname;
        _userName.textColor=[UIColor whiteColor];
        _userName.textAlignment=NSTextAlignmentCenter;
        _userName.font=userNickNameFont;
        _userName.textAlignment=NSTextAlignmentLeft;
    }
    return _userName;
}

-(UIView*)centerLine
{
    if(!_centerLine){
        _centerLine = [[UIView alloc] init];
        _centerLine.backgroundColor = [UIColor whiteColor];
    }
    return _centerLine;
}

-(UIView *)fansBGView{
    if(!_fansBGView){
        _fansBGView = [[UIView alloc] init];
    }
    return _fansBGView;
}

-(UILabel *) fansLabel
{
    if(!_fansLabel){
        _fansLabel = [[UILabel alloc] init];
        _fansLabel.textColor = [UIColor color_ffe8e3];
        _fansLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _fansLabel.frame = CGRectMake(0, 0, 25, 13);
        _fansLabel.text = @"粉丝";
    }
    return _fansLabel;
}

-(UILabel *) fansNumLabel
{
    if(!_fansNumLabel){
        _fansNumLabel = [[UILabel alloc] init];
        _fansNumLabel.font = infoLabelFont;
        _fansNumLabel.textColor = [UIColor color_ffe8e3];
        _fansNumLabel.textAlignment = NSTextAlignmentRight;

    }
    return _fansNumLabel;
}

-(UIView *)likeBGView{
    if(!_likeBGView){
        _likeBGView = [[UIView alloc] init];
    }
    return _likeBGView;
}

-(UILabel *) likeLabel
{
    if(!_likeLabel){
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.textColor = [UIColor color_ffe8e3];
        _likeLabel.frame = CGRectMake(0, 0, 25, 13);
        _likeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _likeLabel.text = @"关注";
    }
    return _likeLabel;
}

-(UILabel *) likeNumLabel
{
    if(!_likeNumLabel){
        _likeNumLabel = [[UILabel alloc] init];
        _likeNumLabel.font = infoLabelFont;
        _likeNumLabel.textColor = [UIColor color_ffe8e3];

    }
    return _likeNumLabel;
}

-(UIImageView *)headerLagerImgBG
{
    if(!_headerLagerImgBG){
        _headerLagerImgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 98, 98)];
        _headerLagerImgBG.image = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(98, 98)];
        _headerLagerImgBG.image = [_headerLagerImgBG.image roundedCornerImageWithCornerRadius:49];
    }
    return _headerLagerImgBG;
}
//- (UIButton * )fansBtn
//{
//    if (!_fansBtn) {
//        _fansBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 144 + 64, SCREEN_WIDTH / 2, 30)];
//        _fansBtn.backgroundColor = [UIColor clearColor];
//        [_fansBtn addTarget:self action:@selector(tapAtFans) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _fansBtn;
//}
//- (UIButton * )attentionBtn
//{
//    if (!_attentionBtn) {
//        _attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 144 + 64, SCREEN_WIDTH / 2, 30)];
//        _attentionBtn.backgroundColor = [UIColor clearColor];
//        [_attentionBtn addTarget:self action:@selector(tapAtAttentionv) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _attentionBtn;
//}

-(OTWPersonalStatisticsModel *) statistics
{
    if(!_statistics){
        _statistics = [[OTWPersonalStatisticsModel alloc] init];
        _statistics.likeNum = 0;
        _statistics.fansNum = 0;
    }
    return _statistics;
}
@end
