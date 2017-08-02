//
//  OTWFootprintDetailViewCell.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintDetailViewCell.h"
#import "OTWCommentModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface OTWFootprintDetailViewCell()

//评论相关 start
@property (nonatomic,strong) UIView *commentBGView;
@property (nonatomic,strong) UIImageView *commentUserHeadImgView;
@property (nonatomic,strong) UILabel *commentUserNicknameLabel;
@property (nonatomic,strong) UILabel *commentDateCreatedLabel;
@property (nonatomic,strong) UILabel *commentContentLabel;
@property (nonatomic,strong) UIView *bottomLine;
//评论相关 end

//当indexPath > 0 时，内容都为评论内容
@property (nonatomic,copy) OTWCommentFrame *commentFrame;

@end

#define footprintContentFont [UIFont systemFontOfSize:17]
#define commentContentFont [UIFont systemFontOfSize:15]
#define padding 15

@implementation OTWFootprintDetailViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString*)identifier{
    OTWFootprintDetailViewCell *cell = [[OTWFootprintDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
   
    return cell;
}

//重写cell生成方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildComment:(OTWCommentFrame *)data
{
    _commentFrame = data;
    DLog(@"获取cell的commontText:%@", _commentFrame.commentModel.commentContent);
    [self addSubview:self.commentBGView];
    [self.commentBGView addSubview:self.commentUserHeadImgView];
    [self.commentBGView addSubview:self.commentUserNicknameLabel];
    [self.commentBGView addSubview:self.commentDateCreatedLabel];
    [self.commentBGView addSubview:self.commentContentLabel];
    [self.commentBGView addSubview:self.bottomLine];
    //设值
    [self.commentUserHeadImgView setImageWithURL:[NSURL URLWithString:_commentFrame.commentModel.userHeadImg]];
    self.commentUserNicknameLabel.text = _commentFrame.commentModel.userNickname;
    self.commentDateCreatedLabel.text = _commentFrame.commentModel.dateCreatedStr;
    self.commentContentLabel.text = _commentFrame.commentModel.commentContent;
}

#pragma mark - Getter Setter

- (UIView *) commentBGView{
    if(!_commentBGView){
        _commentBGView = [[UIView alloc] init];
        _commentBGView.backgroundColor = [UIColor whiteColor];
        _commentBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _commentFrame.cellHeight);
    }
    return _commentBGView;
}

- (UIImageView *) commentUserHeadImgView
{
    if(!_commentUserHeadImgView){
        _commentUserHeadImgView = [[UIImageView alloc] init];
        _commentUserHeadImgView.frame = CGRectMake(padding, 15, 30, 30);
        //设置图片原型
        _commentUserHeadImgView.layer.cornerRadius = _commentUserHeadImgView.Witdh/2.0;
        _commentUserHeadImgView.layer.masksToBounds = YES;
    }
    return _commentUserHeadImgView;
}

- (UILabel *) commentUserNicknameLabel
{
    if(!_commentUserNicknameLabel){
        _commentUserNicknameLabel = [[UILabel alloc] init];
        _commentUserNicknameLabel.textColor = [UIColor color_202020];
        _commentUserNicknameLabel.font = [UIFont systemFontOfSize:14];
        CGFloat X = self.commentUserHeadImgView.MaxX+10;
        CGFloat W = SCREEN_WIDTH - padding - X;
        _commentUserNicknameLabel.frame = CGRectMake(X, 16, W, 15);
    }
    return _commentUserNicknameLabel;
}

- (UILabel *) commentDateCreatedLabel
{
    if(!_commentDateCreatedLabel){
        _commentDateCreatedLabel = [[UILabel alloc] init];
        _commentDateCreatedLabel.textColor = [UIColor color_979797];
        _commentDateCreatedLabel.font = [UIFont systemFontOfSize:12];
        _commentDateCreatedLabel.frame = CGRectMake(self.commentUserNicknameLabel.MinX, self.commentUserNicknameLabel.MaxY+3, self.commentUserNicknameLabel.Witdh, 10);
    }
    return _commentDateCreatedLabel;
}

- (UILabel *) commentContentLabel
{
    if(!_commentContentLabel){
        _commentContentLabel = [[UILabel alloc] init];
        _commentContentLabel.textColor = [UIColor color_202020];
        _commentContentLabel.font = commentContentFont;
        _commentContentLabel.numberOfLines = 0;
        CGFloat X = self.commentUserNicknameLabel.MinX;
        CGFloat W = SCREEN_WIDTH - X - padding;
        _commentContentLabel.frame = CGRectMake(X, self.commentDateCreatedLabel.MaxY+10, W, _commentFrame.contentH);
    }
    return _commentContentLabel;
}

- (UIView *) bottomLine
{
    if(!_bottomLine){
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.commentBGView.Height+0.5, SCREEN_WIDTH, 0.5)];
        _bottomLine.backgroundColor = [UIColor color_d5d5d5];
    }
    return _bottomLine;
}

@end
