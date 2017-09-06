//
//  OTWNotCommentView.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNotCommentView.h"

@interface OTWNotCommentView ()

//大家说
@property (nonatomic,strong) UIView *commentHeaderBGView;

//评论图标
@property (nonatomic,strong) UIImageView *commentImageView;

//评论Label
@property (nonatomic,strong) UILabel *commentLabel;

//没有评论显示缺省信息
@property (nonatomic,strong) UIView *notFundCommentBGView;

//抢沙发图片
@property (nonatomic,strong) UIImageView *qiangshafaImageView;

//抢沙发 文字描述
@property (nonatomic,strong) UILabel *qiangshafaLabel;

//底部的线
@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) NSString *titleName;

@end

@implementation OTWNotCommentView


-(id) initWithTitleName:(NSString *)titleName
{
    self = [super init];
    if(self){
        self.titleName = titleName;
        [self buildUI];
    }
    return self;
}

- (void) buildUI
{
    [self addSubview:self.commentHeaderBGView];
    [self.commentHeaderBGView addSubview:self.commentImageView];
    [self.commentHeaderBGView addSubview:self.commentLabel];
    [self addSubview:self.notFundCommentBGView];
    [self.notFundCommentBGView addSubview:self.qiangshafaImageView];
    [self.notFundCommentBGView addSubview:self.qiangshafaLabel];
    [self.notFundCommentBGView addSubview:self.bottomLine];
    [self buildFrame];
    [self setData];
}

- (void) setData
{
    self.commentLabel.text = self.titleName;
}

- (void) buildFrame
{
    self.commentHeaderBGView.frame =CGRectMake(0, 0, SCREEN_WIDTH, 35);
    
    self.commentImageView.frame = CGRectMake(GLOBAL_PADDING, 12.5, 10, 10);
    
    self.commentLabel.frame = CGRectMake(self.commentImageView.MaxX + 5, 10, 45, 15);
    
    self.notFundCommentBGView.frame = CGRectMake(0, self.commentHeaderBGView.MaxY, SCREEN_WIDTH, 170);
    
    self.qiangshafaImageView.frame = CGRectMake((SCREEN_WIDTH - 55 )/2, 40, 55, 72);
    
    self.qiangshafaLabel.frame = CGRectMake((SCREEN_WIDTH - 140) / 2, self.qiangshafaImageView.MaxY, 140, 18.5);
    
    self.bottomLine.frame = CGRectMake(0, self.notFundCommentBGView.Height - 0.5, SCREEN_WIDTH, 0.5);
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.notFundCommentBGView.MaxY);
}

/**
 * 隐藏默认缺省信息
 */
- (void) hiddenDefaultView:(BOOL)hidden
{
    if(hidden){
        self.notFundCommentBGView.hidden = YES;
        self.frame = CGRectMake(0, self.MinY, SCREEN_WIDTH, self.commentHeaderBGView.MaxY);
    }else{
        self.notFundCommentBGView.hidden = NO;
        self.frame = CGRectMake(0, self.MinY, SCREEN_WIDTH, self.notFundCommentBGView.MaxY);
    }
}


#pragma mark - Setter Getter

- (UIView *) commentHeaderBGView
{
    if(!_commentHeaderBGView){
        _commentHeaderBGView = [[UIView alloc] init];
        _commentHeaderBGView.backgroundColor = [UIColor whiteColor];
        _commentHeaderBGView.layer.borderColor = [UIColor color_d5d5d5].CGColor;
        _commentHeaderBGView.layer.borderWidth = 0.5;
    }
    return _commentHeaderBGView;
}

- (UIImageView *) commentImageView
{
    if(!_commentImageView){
        _commentImageView = [[UIImageView alloc] init];
        _commentImageView.image = [UIImage imageNamed:@"ar_dajiashuo"];
    }
    return _commentImageView;
}

- (UILabel *) commentLabel
{
    if(!_commentLabel){
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.text = @"大家说";
        _commentLabel.textColor = [UIColor color_979797];
        _commentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    }
    return _commentLabel;
}

- (UIView *) notFundCommentBGView
{
    if(!_notFundCommentBGView){
        _notFundCommentBGView = [[UIView alloc] init];
        _notFundCommentBGView.backgroundColor = [UIColor whiteColor];
    }
    return _notFundCommentBGView;
}

- (UIImageView *) qiangshafaImageView
{
    if(!_qiangshafaImageView){
        _qiangshafaImageView = [[UIImageView alloc] init];
        _qiangshafaImageView.image = [UIImage imageNamed:@"zj_qiangshafa"];
    }
    return _qiangshafaImageView;
}

- (UILabel *) qiangshafaLabel
{
    if(!_qiangshafaLabel){
        _qiangshafaLabel = [[UILabel alloc] init];
        _qiangshafaLabel.textAlignment = NSTextAlignmentCenter;
        _qiangshafaLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _qiangshafaLabel.textColor = [UIColor color_979797];
        _qiangshafaLabel.text = @"还没人评论~快抢沙发！";
    }
    return _qiangshafaLabel;
}

- (UIView *) bottomLine
{
    if(!_bottomLine){
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor color_d5d5d5];
    }
    return _bottomLine;
}


@end
