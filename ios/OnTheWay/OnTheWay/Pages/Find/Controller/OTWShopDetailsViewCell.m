//
//  OTWShopDetailsViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWShopDetailsViewCell.h"

#import "OTWFootprintListModel.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#define ShopDetailsHeadImgWidth 30 //头像都长宽

#define ShopDetailsCommentImgWidth 130  //评论图片的宽

#define ShopDetailsCommentImgHeight 78  //评论图片的高

#define ShopDetailsIcon 17//图标的大小

#define ShopDetailsHeadNameFont 14//名称字体的大小

#define ShopDetailsCommentFont 15//评论文字的大小

#define ShopDetailsCommentTimeFont 12//评论时间的文字大小

@interface OTWShopDetailsViewCell(){
    UIImageView *_ShopDetailsHeaderImg;//头像
    UILabel *_ShopDetailsUserName;//头像名称
    UILabel *_ShopDetailsCommentTime;//评论时间
    UILabel *_ShopDetailsCommentConten;//评论内容
    UIView *_ShopDetailsIconList;//图标列表
    UIView *_ShopDetailsCommentImgList;//评论图片列表
    UIView *_CellBottomBorder;//cell底部边框
}

@property (nonatomic,strong) UIButton * ZanImageView;
@property (nonatomic,strong) UIButton * PinglunImageView;
@property (nonatomic,strong) UIButton * FenxiangImageView;

@end

@implementation OTWShopDetailsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

#pragma mark 初始化视图
-(void)initSubView{
    
        //头像控件
        _ShopDetailsHeaderImg=[[UIImageView alloc]init];
        [self.contentView addSubview:_ShopDetailsHeaderImg];
        //头像名称
        _ShopDetailsUserName=[[UILabel alloc]init];
        _ShopDetailsUserName.textColor=[UIColor color_202020];
        _ShopDetailsUserName.font=[UIFont systemFontOfSize:ShopDetailsHeadNameFont];
        [self.contentView addSubview:_ShopDetailsUserName];
        //评论时间
        _ShopDetailsCommentTime=[[UILabel alloc]init];
        _ShopDetailsCommentTime.textColor=[UIColor color_979797];
        _ShopDetailsCommentTime.font=[UIFont systemFontOfSize:ShopDetailsCommentTimeFont];
        [self.contentView addSubview:_ShopDetailsCommentTime];
    
        //评论内容
        _ShopDetailsCommentConten=[[UILabel alloc] init];
        _ShopDetailsCommentConten.textColor=[UIColor color_202020];
        _ShopDetailsCommentConten.font=[UIFont systemFontOfSize:ShopDetailsCommentFont];
        [self.contentView addSubview:_ShopDetailsCommentConten];

        //图标列表
        _ShopDetailsIconList=[[UIView alloc] init];
        [self.contentView addSubview:_ShopDetailsIconList];

        //评论图片列表
        _ShopDetailsCommentImgList=[[UIView alloc]init];
        [self.contentView addSubview:_ShopDetailsCommentImgList];
    
        //cell的边框
        _CellBottomBorder=[[UIView alloc] init];
        _CellBottomBorder.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        _CellBottomBorder.layer.borderWidth=0.5;
        [self.contentView addSubview:_CellBottomBorder];


}
#pragma mark 设置模块
-(void)setStatus:(OTWFootprintListModel *)status{
    //设置头像的大小和位置
    CGRect avatarRect=CGRectMake(15, 15,  ShopDetailsHeadImgWidth, ShopDetailsHeadImgWidth);
    [_ShopDetailsHeaderImg setImageWithURL:[NSURL URLWithString:[status.userHeadImg stringByAppendingString:@"?imageView2/1/w/60/h/60"]]];
    _ShopDetailsHeaderImg.frame=avatarRect;
    _ShopDetailsHeaderImg.layer.cornerRadius = ShopDetailsHeadImgWidth/2;
    _ShopDetailsHeaderImg.layer.masksToBounds = YES;
    
    //头像名称
    CGRect ShopDetailsUserNameRect=CGRectMake(55, 15,  SCREEN_WIDTH-55-15, 15);
    _ShopDetailsUserName.frame=ShopDetailsUserNameRect;
    _ShopDetailsUserName.text=status.userNickname;
    
     //评论时间
    CGRect ShopDetailsCommentTimeRect=CGRectMake(55, 35, SCREEN_WIDTH-55-15, 10);
    _ShopDetailsCommentTime.text=status.dateCreatedStr;
    _ShopDetailsCommentTime.frame=ShopDetailsCommentTimeRect;
    
    //评论内容

    CGRect ShopDetailsCommentContenRect=CGRectMake(55, 55, SCREEN_WIDTH-55-15, 15);
    _ShopDetailsCommentConten.frame=ShopDetailsCommentContenRect;
    _ShopDetailsCommentConten.text=status.footprintContent;
    _ShopDetailsCommentConten.numberOfLines = 0;//文字自适应行数
    [_ShopDetailsCommentConten sizeToFit];//更据文字自动布局
    
    
    
    //评论图片列表
    //图标列表
    for (UIImageView *imageView in _ShopDetailsCommentImgList.subviews) {//移除加载的cell
        [imageView removeFromSuperview];
    }
    
    if(status.footprintPhotoArray.count==0){
        _ShopDetailsCommentImgList.frame=CGRectMake(55, CGRectGetMaxY(_ShopDetailsCommentConten.frame) + 5, (SCREEN_WIDTH-55)/3, 0);
        
        _ShopDetailsIconList.frame=CGRectMake(SCREEN_WIDTH-126, CGRectGetMaxY(_ShopDetailsCommentImgList.frame)+15, 126, ShopDetailsIcon);
    }else{
        if(status.footprintPhotoArray.count%3==0){
            
            _ShopDetailsCommentImgList.frame=CGRectMake(55, CGRectGetMaxY(_ShopDetailsCommentConten.frame) + 5, SCREEN_WIDTH-55-15, status.footprintPhotoArray.count/3*78 +(status.footprintPhotoArray.count/3-1)*5 );
            _ShopDetailsIconList.frame=CGRectMake(SCREEN_WIDTH-126, CGRectGetMaxY(_ShopDetailsCommentImgList.frame)+15, 126, ShopDetailsIcon);
            for (int i = 0; i < status.footprintPhotoArray.count / 3; i ++) {
                for (int j = 0; j < 3; j ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j*(SCREEN_WIDTH-55-15)/3, i*(78+5), (SCREEN_WIDTH-55-14-15)/3, 78)];
                    imageView.layer.masksToBounds = YES;
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [imageView setImageWithURL:[NSURL URLWithString:[status.footprintPhotoArray[i] stringByAppendingString:@"?imageView2/1/w/194/h/156"]]];
                    [_ShopDetailsCommentImgList addSubview:imageView];
                }
            }
        }else{
            _ShopDetailsCommentImgList.frame=CGRectMake(55, CGRectGetMaxY(_ShopDetailsCommentConten.frame) + 5, SCREEN_WIDTH-55-15, (status.footprintPhotoArray.count/3+1)*78 +status.footprintPhotoArray.count/3*5 );
            _ShopDetailsIconList.frame=CGRectMake(SCREEN_WIDTH-126, CGRectGetMaxY(_ShopDetailsCommentImgList.frame)+15, 126, ShopDetailsIcon);
            for (int i = 0; i < status.footprintPhotoArray.count / 3 + 1; i ++) {
                for (int j = 0; j < 3; j ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j*(SCREEN_WIDTH-55-14)/3, i*(78+5), (SCREEN_WIDTH-55-14-15)/3, 78)];
                    [imageView setImageWithURL:[NSURL URLWithString:status.footprintPhotoArray[i]]];
                    imageView.layer.masksToBounds = YES;
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [_ShopDetailsCommentImgList addSubview:imageView];
                    if (j + i*3 == status.footprintPhotoArray.count-1) {
                        break;
                    }
                }
            }
        }
    }
    
    [_ShopDetailsIconList addSubview:self.FenxiangImageView];
    [_ShopDetailsIconList addSubview:self.PinglunImageView];
    [_ShopDetailsIconList addSubview:self.ZanImageView];
    
    [_ZanImageView addTarget:self action:@selector(ZanClick) forControlEvents:UIControlEventTouchUpInside];
    [_PinglunImageView addTarget:self action:@selector(PinglunClick) forControlEvents:UIControlEventTouchUpInside];
    [_FenxiangImageView addTarget:self action:@selector(FenxiangClick) forControlEvents:UIControlEventTouchUpInside];
    
       _CellBottomBorder.frame=CGRectMake(0, CGRectGetMaxY(_ShopDetailsIconList.frame)+14, SCREEN_WIDTH, 0.5);
 
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_ShopDetailsIconList.frame)+15)];

}

-(UIButton*)ZanImageView{
    if(!_ZanImageView){
        _ZanImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
        [_ZanImageView setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
        
    }
    return _ZanImageView;
}

-(UIButton*)PinglunImageView{
    if(!_PinglunImageView){
        _PinglunImageView = [[UIButton alloc] initWithFrame:CGRectMake(47, 0, 17, 17)] ;
        [_PinglunImageView setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
        
    }
    return _PinglunImageView;
}

-(UIButton*)FenxiangImageView{
    if(!_FenxiangImageView){
        _FenxiangImageView = [[UIButton alloc] initWithFrame:CGRectMake(47+30+17, 0, 17, 17)] ;
        [_FenxiangImageView setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        
    }
    return _FenxiangImageView;
}

-(void)ZanClick{
    DLog(@"我点击了ZanClick");
}

-(void)PinglunClick{
    DLog(@"我点击了PinglunClick");
}
-(void)FenxiangClick{
    DLog(@"我点击了FenxiangClick");
}

@end
