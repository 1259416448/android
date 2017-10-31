//
//  OTWNewFootprintsTableViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewFootprintsTableViewCell.h"

#import "OTWFootprintListModel.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#define ShopDetailsHeadImgWidth 45 //头像都长宽

#define ShopDetailsCommentImgWidth 130  //评论图片的宽

#define ShopDetailsCommentImgHeight 78  //评论图片的高

#define ShopDetailsIcon 17//图标的大小

#define ShopDetailsHeadNameFont 14//名称字体的大小

#define ShopDetailsCommentFont 15//评论文字的大小

#define ShopDetailsCommentTimeFont 12//评论时间的文字大小

@interface OTWNewFootprintsTableViewCell (){
    UIImageView *_ShopDetailsHeaderImg;//头像
    UILabel *_ShopDetailsUserName;//头像名称
    UILabel *_ShopDetailsCommentTime;//评论时间
    UILabel *_ShopDetailsCommentConten;//评论内容
    UILabel *_ShopDetailsAdress;//地址
    UIImageView *_ShopDetailsAdressIcon;//地址图标
    UIView *_CellBottomBorder;//cell底部边框
    UIView *_line1;
    UIView *_line2;
}

@property (nonatomic,assign) CGFloat photoH;

@end

@implementation OTWNewFootprintsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

#pragma mark 初始化视图
-(void)initSubView{
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    _line2.backgroundColor = [UIColor color_d5d5d5];
    [self.contentView addSubview:_line2];
    
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
    
    //评论图片列表
    _ShopDetailsCommentImgList=[[UIView alloc]init];
    [self.contentView addSubview:_ShopDetailsCommentImgList];
    
    //地址
    _ShopDetailsAdress=[[UILabel alloc]init];
    _ShopDetailsAdress.textColor=[UIColor color_979797];
    _ShopDetailsAdress.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:_ShopDetailsAdress];
    
    //地址图标
    _ShopDetailsAdressIcon=[[UIImageView alloc]init ];
    _ShopDetailsAdressIcon.image=[UIImage imageNamed:@"dinwgei_2"];
    [self.contentView addSubview:_ShopDetailsAdressIcon];

    //cell的边框
    _CellBottomBorder=[[UIView alloc] init];
    _CellBottomBorder.backgroundColor = [UIColor color_f4f4f4];
//    _CellBottomBorder.layer.borderColor=[UIColor color_d5d5d5].CGColor;
//    _CellBottomBorder.layer.borderWidth=0.5;
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    _line1.backgroundColor = [UIColor color_d5d5d5];
    [_CellBottomBorder addSubview:_line1];
    
    [self.contentView addSubview:_CellBottomBorder];

}

#pragma mark 设置模块
-(void)setData:(OTWFootprintListModel *)status{
    //设置头像的大小和位置
    CGRect avatarRect=CGRectMake(15, 15,  ShopDetailsHeadImgWidth, ShopDetailsHeadImgWidth);
    [_ShopDetailsHeaderImg setImageWithURL:[NSURL URLWithString:status.userHeadImg]];
    _ShopDetailsHeaderImg.frame=avatarRect;
    _ShopDetailsHeaderImg.layer.cornerRadius = ShopDetailsHeadImgWidth/2;
    _ShopDetailsHeaderImg.layer.masksToBounds = YES;
    
    //头像名称
    CGRect ShopDetailsUserNameRect=CGRectMake(_ShopDetailsHeaderImg.MaxX+10, 15,  SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10-15, 15);
    _ShopDetailsUserName.frame=ShopDetailsUserNameRect;
    _ShopDetailsUserName.text=status.userNickname;
    
    //评论时间
    CGRect ShopDetailsCommentTimeRect=CGRectMake(_ShopDetailsHeaderImg.MaxX+10, 35, SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10-15, 10);
    _ShopDetailsCommentTime.text=status.dateCreatedStr;
    _ShopDetailsCommentTime.frame=ShopDetailsCommentTimeRect;
    
    //评论内容
    
    CGRect ShopDetailsCommentContenRect=CGRectMake(_ShopDetailsHeaderImg.MaxX+10, _ShopDetailsCommentTime.MaxY+10, SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10-15, 15);
    _ShopDetailsCommentConten.frame=ShopDetailsCommentContenRect;
    _ShopDetailsCommentConten.text=status.footprintContent;
    _ShopDetailsCommentConten.numberOfLines = 0;//文字自适应行数
    [_ShopDetailsCommentConten sizeToFit];//更据文字自动布局
    
    
    
    //评论图片列表
    for (UIImageView *imageView in _ShopDetailsCommentImgList.subviews) {//移除加载的cell
        [imageView removeFromSuperview];
    }
    
    if(status.footprintPhotoArray.count==0){
        _ShopDetailsCommentImgList.frame=CGRectMake(_ShopDetailsHeaderImg.MaxX+10, CGRectGetMaxY(_ShopDetailsCommentConten.frame) + 5, (SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10)/3, 0);
    
    }else{
        if(status.footprintPhotoArray.count%3==0){
            
            _ShopDetailsCommentImgList.frame=CGRectMake(_ShopDetailsHeaderImg.MaxX+10, CGRectGetMaxY(_ShopDetailsCommentConten.frame) + 5, SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10-15, status.footprintPhotoArray.count/3*self.photoH +(status.footprintPhotoArray.count/3-1)*5 );
    
            int k = 0;
            for (int i = 0; i < status.footprintPhotoArray.count / 3; i ++) {
                for (int j = 0; j < 3; j ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j*(SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10-15)/3, i*(self.photoH+5), (SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10-14-15)/3, self.photoH)];
                    imageView.layer.masksToBounds = YES;
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [imageView setImageWithURL:[NSURL URLWithString:[status.footprintPhotoArray[k] stringByAppendingString:@"?imageView2/1/w/194/h/156"]]];
                    imageView.tag = 1000 + k;
                    imageView.userInteractionEnabled = YES;
                    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAt:)]];
                    [_ShopDetailsCommentImgList addSubview:imageView];
                    k++;
                }
            }
        }else{
            _ShopDetailsCommentImgList.frame=CGRectMake(_ShopDetailsHeaderImg.MaxX+10, CGRectGetMaxY(_ShopDetailsCommentConten.frame) + 5, SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10-15, (status.footprintPhotoArray.count/3+1)*self.photoH +status.footprintPhotoArray.count/3*5 );

            int k = 0;
            for (int i = 0; i < status.footprintPhotoArray.count / 3 + 1; i ++) {
                for (int j = 0; j < 3; j ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j*(SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10-14)/3, i*(self.photoH+5), (SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10-14-15)/3, self.photoH)];
                    [imageView setImageWithURL:[NSURL URLWithString:status.footprintPhotoArray[k]]];
                    imageView.layer.masksToBounds = YES;
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.tag = 1000 + k;
                    imageView.userInteractionEnabled = YES;
                    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAt:)]];
                    [_ShopDetailsCommentImgList addSubview:imageView];
                    k++;
                    if (j + i*3 == status.footprintPhotoArray.count-1) {
                        break;
                    }
                }
            }
        }
    }
    _ShopDetailsAdressIcon.frame=CGRectMake(_ShopDetailsHeaderImg.MaxX+10, CGRectGetMaxY(_ShopDetailsCommentImgList.frame)+15, 10, 10);

    _ShopDetailsAdress.frame=CGRectMake(_ShopDetailsAdressIcon.MaxX+5, CGRectGetMaxY(_ShopDetailsCommentImgList.frame)+15-2, SCREEN_WIDTH-_ShopDetailsHeaderImg.MaxX-10-10-15, 12);
    _ShopDetailsAdress.text=status.footprintAddress;
    
    _CellBottomBorder.frame=CGRectMake(0, CGRectGetMaxY(_ShopDetailsAdressIcon.frame)+14, SCREEN_WIDTH, 11);
    _line1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    _line2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_ShopDetailsAdressIcon.frame)+15 + 10)];
    
}
- (void)tapAt:(UITapGestureRecognizer *)tap
{
    NSLog(@"-=-=-=-==-=-=-=--=-%ld",tap.view.tag);
    if (_delegate && [_delegate respondsToSelector:@selector(tapAtIndexPath:AndImgIndex:)]) {
        [_delegate tapAtIndexPath:_indexPath AndImgIndex:tap.view.tag - 1000];
    }
}

-(CGFloat)photoH{
    if(!_photoH || _photoH == 0){
        _photoH=(SCREEN_WIDTH-55-15-14) /3  *78 /97;
    }
    return _photoH;
}


@end
