//
//  OTWFindBusinessmenViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFindBusinessmenViewCell.h"
#import "OTWFindBusinessmenModel.h"


#define OTWFindBusinessmenNameFont [UIFont systemFontOfSize:17]
#define OTWFindBusinessmenTimeFont [UIFont systemFontOfSize:13]
#define OTWFindBusinessmenfooterFont [UIFont systemFontOfSize:11]

@interface OTWFindBusinessmenViewCell(){
    UILabel *userNameLabel;
    UILabel *needTimeLabel;
    UILabel *distanceLabel;
    UILabel *addressLabel;
    UIImageView *addressImageView;
    UIView *couponsView;
}

@end

@implementation OTWFindBusinessmenViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
   self.contentView.layer.borderWidth=0.25;
    self.contentView.layer.borderColor=[UIColor color_d5d5d5].CGColor;
    //商家名称
    userNameLabel=[[UILabel alloc]init];
    userNameLabel.textColor=[UIColor color_202020];
    userNameLabel.font=[UIFont systemFontOfSize:17];
    [self.contentView addSubview:userNameLabel];
    //距离
    distanceLabel=[[UILabel alloc]init];
    distanceLabel.textColor=[UIColor color_e50834];
    distanceLabel.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:distanceLabel];
    //地址
    addressLabel=[[UILabel alloc]init];
    addressLabel.textColor=[UIColor color_979797];
    addressLabel.font=[UIFont systemFontOfSize:11];
    [self.contentView addSubview:addressLabel];
    //地址图标
    addressImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:addressImageView];
    //行走世间
    needTimeLabel=[[UILabel alloc]init];
    needTimeLabel.textColor=[UIColor color_979797];
    needTimeLabel.font=[UIFont systemFontOfSize:11];
    [self.contentView addSubview:needTimeLabel];
    //优惠券
    couponsView=[[UIView alloc]init];
    [self.contentView addSubview:couponsView];
}

#pragma mark 设置模块
-(void)setStatus:(FindBusinessmenModel *)status{
    
    //根据名称计算占用空间大小
//       CGSize userNameLabelSize=[status.BusinessmenName  sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
    userNameLabel.text=status.BusinessmenName;
    userNameLabel.font=[UIFont systemFontOfSize:17];
    [userNameLabel sizeToFit];
    if((userNameLabel .frame.size.width+status.coupons.count*20+70)>SCREEN_WIDTH){
        CGRect userNameLabelRect=CGRectMake(15, 15,SCREEN_WIDTH-40-status.coupons.count*20-30,18);
        userNameLabel.frame=userNameLabelRect;
    }else{
        CGRect userNameLabelRect=CGRectMake(15, 15,userNameLabel .frame.size.width,18);
        userNameLabel.frame=userNameLabelRect;
    }

    //根据list个数来计算图标模块的大小
    CGRect couponsViewRec=CGRectMake(userNameLabel .frame.size.width+15,15,status.coupons.count*20,15);
    couponsView.frame=couponsViewRec;
    
    for (UIImageView *imageView in  couponsView.subviews) {//移除加载的图片
        [imageView removeFromSuperview];
    }
    //循环显示图标
    for (int i = 0; i < status.coupons.count; i ++) {
        //显示图标
        UIImageView *iconImageView = [[UIImageView alloc]init];
        iconImageView.image=[UIImage imageNamed:status.coupons[i]];
        iconImageView.frame=CGRectMake(2.5, 0, 15, 15);
        UIView *iconBox=[[UIView alloc] init];
        
        //设置图标模块的view
        iconBox.frame=CGRectMake((i*20), 0, 15, 15);
        [couponsView addSubview:iconBox];
        [iconBox addSubview:iconImageView];
        
    }
    
    //距离
    CGRect distanceLabelRect = CGRectMake(SCREEN_WIDTH-15-40, 15, 40, 12);
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.text=status. BusinessmenDistance;
    distanceLabel.frame=distanceLabelRect;
    
    //地址图标
    UIImageView *addressImageBoxView = [[UIImageView alloc]init];
    addressImageBoxView.image=[UIImage imageNamed:@"dinwgei_2"];
    addressImageBoxView.frame=CGRectMake(15,44, 8, 10);
    [addressImageView addSubview:addressImageBoxView];
    
    //行走世间
    CGRect needTimeLabelRect=CGRectMake( SCREEN_WIDTH-15-80, 43,80,12);
    needTimeLabel.text=status. BusinessmenNeedTime;
    needTimeLabel.textAlignment = NSTextAlignmentRight;
    needTimeLabel.frame=needTimeLabelRect;
    
    //地址
    CGRect addressLabelRect=CGRectMake( 28, 43,SCREEN_WIDTH-30-80-10,12);
    addressLabel.text=status. BusinessmenAddress;
    addressLabel.frame=addressLabelRect;
   }




@end

