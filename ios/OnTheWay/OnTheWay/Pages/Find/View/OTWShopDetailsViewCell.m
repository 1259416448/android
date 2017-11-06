//
//  OTWShopDetailsViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/17.
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

@interface OTWShopDetailsViewCell (){
    UIImageView *_ShopDetailsHeaderImg;//头像
    UILabel *_ShopDetailsUserName;//头像名称
    UILabel *_ShopDetailsCommentTime;//评论时间
    UILabel *_ShopDetailsCommentConten;//评论内容
    UIView *_ShopDetailsIconList;//图标列表
    UIView *_ShopDetailsCommentImgList;//评论图片列表
    UIView *_CellBottomBorder;//cell底部边框
    UILabel *_totalComment;
}

@property (nonatomic,strong) UIView * ZanImageView;
@property (nonatomic,strong) UIView * FenxiangImageView;
@property (nonatomic,assign) CGFloat photoH;

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
    
    _totalComment=[[UILabel alloc] init];
    _totalComment.textColor=[UIColor color_979797];
    _totalComment.font=[UIFont systemFontOfSize:11];
    [self.contentView addSubview:_totalComment];
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
        
        _ShopDetailsIconList.frame=CGRectMake(SCREEN_WIDTH-130-15, CGRectGetMaxY(_ShopDetailsCommentImgList.frame)+15, 130, ShopDetailsIcon);
    }else{
        if(status.footprintPhotoArray.count%3==0){
            
            _ShopDetailsCommentImgList.frame=CGRectMake(55, CGRectGetMaxY(_ShopDetailsCommentConten.frame) + 5, SCREEN_WIDTH-55-15, status.footprintPhotoArray.count/3*self.photoH +(status.footprintPhotoArray.count/3-1)*5 );
            _ShopDetailsIconList.frame=CGRectMake(SCREEN_WIDTH-130-15, CGRectGetMaxY(_ShopDetailsCommentImgList.frame)+15, 130, ShopDetailsIcon);
            for (int i = 0; i < status.footprintPhotoArray.count / 3; i ++) {
                for (int j = 0; j < 3; j ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j*(SCREEN_WIDTH-55-15)/3, i*(self.photoH+5), (SCREEN_WIDTH-55-14-15)/3, self.photoH)];
                    imageView.layer.masksToBounds = YES;
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [imageView setImageWithURL:[NSURL URLWithString:[status.footprintPhotoArray[i] stringByAppendingString:@"?imageView2/1/w/194/h/156"]]];
                    [_ShopDetailsCommentImgList addSubview:imageView];
                }
            }
        }else{
            _ShopDetailsCommentImgList.frame=CGRectMake(55, CGRectGetMaxY(_ShopDetailsCommentConten.frame) + 5, SCREEN_WIDTH-55-15, (status.footprintPhotoArray.count/3+1)*self.photoH +status.footprintPhotoArray.count/3*5 );
            _ShopDetailsIconList.frame=CGRectMake(SCREEN_WIDTH-130-15, CGRectGetMaxY(_ShopDetailsCommentImgList.frame)+15, 130, ShopDetailsIcon);
            for (int i = 0; i < status.footprintPhotoArray.count / 3 + 1; i ++) {
                for (int j = 0; j < 3; j ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j*(SCREEN_WIDTH-55-14)/3, i*(self.photoH+5), (SCREEN_WIDTH-55-14-15)/3, self.photoH)];
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
    _totalComment.frame=CGRectMake(55, CGRectGetMaxY(_ShopDetailsIconList.frame)-15, SCREEN_WIDTH-55-15-140, 15);
        _totalComment.text=[[NSString stringWithFormat:@"%ld", (long)status.footprintCommentNum]  stringByAppendingString:@" 条回复"];
    
    //[_ShopDetailsIconList addSubview:self.FenxiangImageView];
    [_ShopDetailsIconList addSubview:self.ZanImageView];
    
//    [_ZanImageView addTarget:self action:@selector(ZanClick) forControlEvents:UIControlEventTouchUpInside];
//    [_PinglunImageView addTarget:self action:@selector(PinglunClick) forControlEvents:UIControlEventTouchUpInside];
//    [_FenxiangImageView addTarget:self action:@selector(FenxiangClick) forControlEvents:UIControlEventTouchUpInside];
    
    _CellBottomBorder.frame=CGRectMake(0, CGRectGetMaxY(_ShopDetailsIconList.frame)+14, SCREEN_WIDTH, 0.5);
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_ShopDetailsIconList.frame)+15)];
    
}

-(UIView*)ZanImageView{
    if(!_ZanImageView){
        _ZanImageView = [[UIView alloc] init];
        _ZanImageView.layer.borderWidth=0.5;
        _ZanImageView.layer.borderColor=[UIColor color_c4c4c4].CGColor;
        _ZanImageView.layer.cornerRadius=12;
        _ZanImageView.layer.masksToBounds = YES;
        
        UIImageView *zanIcon=[[UIImageView alloc]initWithFrame:CGRectMake(11.5, 6, 12, 12)];
        zanIcon.image=[UIImage imageNamed:@"zan"];
        
        UILabel *zanName=[[UILabel alloc]init];
        zanName.text=@"123";
        zanName.font=[UIFont systemFontOfSize:12];
        zanName.textColor=[UIColor color_202020];
        [zanName sizeToFit];
        zanName.frame=CGRectMake(zanIcon.MaxX+5, 4, zanName.Witdh, 16.5);
        
        [_ZanImageView addSubview:zanIcon];
        [_ZanImageView addSubview:zanName];
        
        UITapGestureRecognizer  *tapGesturZan=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ZanClick)];
        [_ZanImageView addGestureRecognizer:tapGesturZan];
        
        _ZanImageView.frame=CGRectMake(_ShopDetailsIconList.Witdh-(23+zanName.Witdh+zanIcon.Witdh+5), 0, 23+zanName.Witdh+zanIcon.Witdh+5, 25);
    }
    return _ZanImageView;
}

//-(UIView*)FenxiangImageView{
//    if(!_FenxiangImageView){
//        _FenxiangImageView = [[UIView alloc] initWithFrame:CGRectMake(self.ZanImageView.MaxX+10, 0, 60, 25)] ;
//        _FenxiangImageView.layer.borderWidth=0.5;
//        _FenxiangImageView.layer.borderColor=[UIColor color_c4c4c4].CGColor;
//        _FenxiangImageView.layer.cornerRadius=12;
//        _FenxiangImageView.layer.masksToBounds = YES;
//        
//        UIImageView *shareIcon=[[UIImageView alloc]initWithFrame:CGRectMake(9.5, 6, 12, 12)];
//        shareIcon.image=[UIImage imageNamed:@"fenxiang"];
//        
//        UILabel *shareName=[[UILabel alloc]initWithFrame:CGRectMake(shareIcon.MaxX+5, 4, 25, 16.5)];
//        shareName.text=@"分享";
//        shareName.font=[UIFont systemFontOfSize:12];
//        shareName.textColor=[UIColor color_202020];
//        
//        [_FenxiangImageView addSubview:shareIcon];
//        [_FenxiangImageView addSubview:shareName];
//        UITapGestureRecognizer  *tapGesturFenxiang=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(FenxiangClick)];
//        [_FenxiangImageView addGestureRecognizer:tapGesturFenxiang];
//        
//    }
//    return _FenxiangImageView;
//}

-(void)ZanClick{
    DLog(@"我点击了ZanClick");
}

//-(void)FenxiangClick{
//    DLog(@"我点击了FenxiangClick");
//}

-(CGFloat)photoH{
    if(!_photoH || _photoH == 0){
        _photoH=(SCREEN_WIDTH-55-15-14) /3  *78 /97;
    }
    return _photoH;
}


@end
