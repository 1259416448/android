//
//  OTWPersonalClaimTableViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalClaimTableViewCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
@interface OTWPersonalClaimTableViewCell (){
    UILabel *claimShopTime;
    UILabel *claimShopTimeBorder;
    UIImageView *claimShopImg;
    UILabel *claimShopCommentCount;
    UILabel *claimShopName;
    UIImageView *claimShopAddressIcon;
    UILabel *claimShopAddress;
    UIImageView *claimShopPhoneIcon;
    UILabel *claimShopPhone;
    UIView *claimShopQuan;
    UIView *claimShopBtnView;
     UILabel *claimShopDetail;
     UILabel *claimShopActive;
//    UIButton *claimShopDetailBtn;
//    UIButton *claimShopActiveBtn;
    UILabel *claimShoBtnViewCut;//中间分割线
    UIView *claimShopCellCut;
    
}
@end
@implementation OTWPersonalClaimTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    claimShopTime=[[UILabel alloc]init];
    claimShopTime.text=@"2017-02-01";
    claimShopTime.frame=CGRectMake(15, 0.5, SCREEN_WIDTH-30, 29);
    claimShopTime.textColor=[UIColor color_979797];
    claimShopTime.font=[UIFont systemFontOfSize:11];
    
    claimShopTimeBorder=[[UILabel alloc]init];
    claimShopTimeBorder.frame=CGRectMake(0, 0, SCREEN_WIDTH, 30);
    claimShopTimeBorder.layer.borderColor=[UIColor color_d5d5d5].CGColor;
    claimShopTimeBorder.layer.borderWidth=0.5;
    [self.contentView addSubview:claimShopTimeBorder];
    [self.contentView addSubview:claimShopTime];
  

        claimShopImg=[[UIImageView alloc]init];
        //这里判断商家是否存在图片
        if(1){
            claimShopImg.frame=CGRectMake(15, claimShopTime.MaxY+10, 111, 80);
            [claimShopImg sd_setImageWithURL:[NSURL URLWithString:[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg" stringByAppendingString:@"?imageView2/1/w/222/h/160"] ]];
            //商店评论条数
            claimShopCommentCount=[[UILabel alloc] init];
            claimShopCommentCount.text=@"123";
            claimShopCommentCount.font=[UIFont systemFontOfSize:12];
            [claimShopCommentCount sizeToFit];
            claimShopCommentCount.frame=CGRectMake(claimShopImg.width-10-claimShopCommentCount .frame.size.width-5,  claimShopImg.Height-20, claimShopCommentCount .frame.size.width+10,15+2.5);
            claimShopCommentCount.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.6f];
            claimShopCommentCount.textColor=[UIColor whiteColor];
            claimShopCommentCount.textAlignment=NSTextAlignmentCenter;
            [claimShopImg addSubview:claimShopCommentCount];
        }else{
            claimShopImg.frame=CGRectMake(0, claimShopTime.MaxY+10, 5, 0);
        }
    [self.contentView addSubview:claimShopImg];

    claimShopName=[[UILabel alloc] initWithFrame:CGRectMake(claimShopImg.MaxX+10, claimShopTime.MaxY+10, SCREEN_WIDTH-claimShopImg.MaxX-10-15, 20)];
    claimShopName.font=[UIFont systemFontOfSize:16];
    claimShopName.text=@"胡大饭馆（东直门总店）";
    claimShopName.textColor=[UIColor color_202020];
    [self.contentView addSubview:claimShopName];
    
    //商店地址图标
    claimShopAddressIcon=[[UIImageView alloc] initWithFrame:CGRectMake(claimShopImg.MaxX+10, claimShopName.MaxY+10,8, 10)];
    claimShopAddressIcon.image=[UIImage imageNamed:@"dinwgei_2"];
    [self.contentView addSubview:claimShopAddressIcon];

    //商店地址
    claimShopAddress=[[UILabel alloc] initWithFrame:CGRectMake(claimShopAddressIcon.MaxX+5, claimShopName.MaxY+10,SCREEN_WIDTH-claimShopImg.Witdh-30-8-10-6.5, 12)];
    claimShopAddress.text=@"东城区东直门内大街233";
    claimShopAddress.font=[UIFont systemFontOfSize:13];
    claimShopAddress.textColor=[UIColor color_979797];
    [self.contentView addSubview:claimShopAddress];
    
    //商店电话图标
    claimShopPhoneIcon=[[UIImageView alloc] initWithFrame:CGRectMake(claimShopImg.MaxX+10, claimShopAddress.MaxY+6.5,8, 10)];
    claimShopPhoneIcon.image=[UIImage imageNamed:@"dianhua"];
    [self.contentView  addSubview:claimShopPhoneIcon];
    
    //商店电话号码
    claimShopPhone=[[UILabel alloc] initWithFrame:CGRectMake(claimShopPhoneIcon.MaxX+5, claimShopAddress.MaxY+6.5,SCREEN_WIDTH-claimShopImg.Witdh-30-8-10-6.5, 12)];
    claimShopPhone.text=@"87474993";
    claimShopPhone.font=[UIFont systemFontOfSize:11];
    claimShopPhone.textColor=[UIColor color_979797];
    [self.contentView addSubview:claimShopPhone];
    
    // 商家券列表
    claimShopQuan=[[UIView alloc]initWithFrame:CGRectMake(claimShopImg.MaxX+10, claimShopPhone.MaxY+6.5,SCREEN_WIDTH-claimShopImg.MaxX-10-15 , 15)];
    for(int i=0;i<4;i++){
        UIImageView *claimShopQuanImg=[[UIImageView alloc]initWithFrame:CGRectMake(i*22.5, 0, 15, 15)];
        claimShopQuanImg.image=[UIImage imageNamed:@"wodekaquan"];
        [claimShopQuan addSubview:claimShopQuanImg];
    }
    [self.contentView addSubview:claimShopQuan];
    
    claimShopBtnView=[[UIView alloc]initWithFrame:CGRectMake(0, claimShopQuan.MaxY+15, SCREEN_WIDTH, 44)];
    claimShopBtnView.layer.borderWidth=0.5;
    claimShopBtnView.layer.borderColor=[UIColor color_d5d5d5].CGColor;
    [self.contentView addSubview:claimShopBtnView];
    
    //商家详情
    claimShopDetail=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.5, (SCREEN_WIDTH-0.5)/2, 43)];
    claimShopDetail.text=@"商家详情";
    claimShopDetail.font=[UIFont systemFontOfSize:14];
    claimShopDetail.textColor=[UIColor color_202020];
    claimShopDetail.backgroundColor=[UIColor color_fbfbfb];
    claimShopDetail.textAlignment=NSTextAlignmentCenter;
    [claimShopBtnView addSubview:claimShopDetail];
    
    _claimShopDetailBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, (SCREEN_WIDTH-0.5)/2, 43)];
    [claimShopBtnView addSubview:_claimShopDetailBtn];
    
    //商家活动
    claimShopActive=[[UILabel alloc]initWithFrame:CGRectMake(claimShopDetail.MaxX+0.5, 0.5, (SCREEN_WIDTH-0.5)/2, 43)];
    claimShopActive.text=@"商家活动";
    claimShopActive.font=[UIFont systemFontOfSize:14];
    claimShopActive.textColor=[UIColor color_202020];
    claimShopActive.backgroundColor=[UIColor color_fbfbfb];
    claimShopActive.textAlignment=NSTextAlignmentCenter;
    [claimShopBtnView addSubview:claimShopActive];
    
    _claimShopActiveBtn=[[UIButton alloc]initWithFrame:CGRectMake(claimShopDetail.MaxX+0.5, 0.5, (SCREEN_WIDTH-0.5)/2, 43)];
     [claimShopBtnView addSubview:_claimShopActiveBtn];
    
    //中间分割线
    claimShoBtnViewCut=[[UILabel alloc]initWithFrame:CGRectMake(claimShopDetail.MaxX, 0.5, 0.5, 43)];
    claimShoBtnViewCut.backgroundColor=[UIColor color_d5d5d5];
    [claimShopBtnView addSubview:claimShoBtnViewCut];
    
    claimShopCellCut=[[UIView alloc]initWithFrame:CGRectMake(0, claimShopBtnView.MaxY, SCREEN_WIDTH, 10)];
    claimShopCellCut.backgroundColor=[UIColor color_f4f4f4];
    [self.contentView addSubview:claimShopCellCut];

    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(claimShopCellCut.frame))];

}

@end
