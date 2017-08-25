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
@property (nonatomic,strong) UIButton *commentUserHeaderImgButton;
@property (nonatomic,strong) UIButton *commentUserNicknameButton;
@property (nonatomic,strong) UILabel *commentDateCreatedLabel;
@property (nonatomic,strong) UILabel *commentContentLabel;
@property (nonatomic,strong) UIView *bottomLine;
//评论相关 end

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
        [self.contentView addSubview:self.commentBGView];
        //[self.commentBGView addSubview:self.commentUserHeadImgView];
        [self.commentBGView addSubview:self.commentUserHeaderImgButton];
        //[self.commentBGView addSubview:self.commentUserNicknameLabel];
        [self.commentBGView addSubview:self.commentUserNicknameButton];
        [self.commentBGView addSubview:self.commentDateCreatedLabel];
        [self.commentBGView addSubview:self.commentContentLabel];
        [self.commentBGView addSubview:self.bottomLine];
    }
    return self;
}

- (void)setData:(OTWCommentFrame *)data
{
    //设值
    //这里是图片圆角处理
//    [self.commentUserHeaderImgButton sd_setImageWithURL:[NSURL URLWithString:data.commentModel.userHeadImg] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if(image){
//            [self.commentUserHeaderImgButton setImage:[image roundedCornerImageWithCornerRadius:80] forState:UIControlStateNormal];
//        }
//    }];
    [self.commentUserHeaderImgButton sd_setImageWithURL:[NSURL URLWithString:data.commentModel.userHeadImg] forState:UIControlStateNormal];
    self.commentUserHeaderImgButton.imageView.layer.cornerRadius = 15;
    [self.commentUserNicknameButton setTitle:data.commentModel.userNickname forState:UIControlStateNormal];
    //这里需要设置按钮的frame
    self.commentUserNicknameButton.frame = CGRectMake(self.commentUserHeaderImgButton.MaxX, 16, data.nicknameW, 15);
    self.commentDateCreatedLabel.text = data.commentModel.dateCreatedStr;
    self.commentContentLabel.text = data.commentModel.commentContent;
    //设置frame
    self.commentBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, data.cellHeight);
    CGFloat X = self.commentUserHeaderImgButton.MaxX;
    CGFloat W = SCREEN_WIDTH - X - padding;
    self.commentDateCreatedLabel.frame = CGRectMake(self.commentUserNicknameButton.MinX, self.commentUserNicknameButton.MaxY + 3, W, 10);
    self.commentContentLabel.frame = CGRectMake(X, self.commentDateCreatedLabel.MaxY+10, W, data.contentH);
}

#pragma mark - Getter Setter

- (UIView *) commentBGView{
    if(!_commentBGView){
        _commentBGView = [[UIView alloc] init];
        _commentBGView.backgroundColor = [UIColor whiteColor];
    }
    return _commentBGView;
}

- (UILabel *) commentDateCreatedLabel
{
    if(!_commentDateCreatedLabel){
        _commentDateCreatedLabel = [[UILabel alloc] init];
        _commentDateCreatedLabel.textColor = [UIColor color_979797];
        _commentDateCreatedLabel.font = [UIFont systemFontOfSize:12];
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

#pragma mark - button selector

- (void) userHeaderImgOrNicknameClick:(UIButton *)sender
{
    if(self.block){
        //首先获得Cell：button的父视图是commentBGView -> contentView，再上一层才是UITableViewCell
        UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview;
        self.block(cell);
    }
}
@end
