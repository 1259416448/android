//
//  OTWSearchShopListViewCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/10.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWSearchShopListViewCell.h"

@interface OTWSearchShopListViewCell(){
    UIImageView *shopImageView;
    UILabel *shopName;
    UIImageView *shopAddressIcon;
    UILabel *shopAddress;
    UIImageView *shopPhoneIcon;
    UILabel *shopPhone;
    UIView *claimView;
    UIImageView *claimImageView;
    UILabel *claimText;
}
@end
@implementation OTWSearchShopListViewCell

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
    
    //图片
    shopImageView=[[UIImageView alloc]init];
    shopImageView.frame=CGRectMake(15, 15, 111, 80);
    [shopImageView sd_setImageWithURL:[NSURL URLWithString:[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg" stringByAppendingString:@"?imageView2/1/w/222/h/160"] ]];
    
    [self.contentView addSubview:shopImageView];
    
    //认领view

    claimImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 1.5, 15, 15)];
    claimImageView.image=[UIImage imageNamed:@"ar_renling-1"];
    
    claimText=[[UILabel alloc]init];
    claimText.text=@"认领商家";
    claimText.textColor=[UIColor color_e50834];
    claimText.font=[UIFont systemFontOfSize:13];
    [claimText sizeToFit];
    claimText.frame=CGRectMake(claimImageView.MaxX+2.5, 0, claimText.Witdh, 18);
    
    claimView=[[UIView alloc ]initWithFrame:CGRectMake(SCREEN_WIDTH-claimImageView.Witdh-claimText.Witdh-2.5-15, 15, claimImageView.Witdh+claimText.Witdh+2.5, 18)];
    
    UITapGestureRecognizer  *tapGesturClaim=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForClaim)];
    [claimView addGestureRecognizer:tapGesturClaim];
    
    [self.contentView addSubview:claimView];
    [claimView addSubview:claimImageView];
    [claimView addSubview:claimText];
    
    //商店名称
    shopName=[[UILabel alloc] initWithFrame:CGRectMake(shopImageView.MaxX+10, 15, SCREEN_WIDTH-15-claimView.Witdh-10-shopImageView.MaxX, 20)];
    shopName.font=[UIFont systemFontOfSize:16];
    shopName.textColor=[UIColor color_202020];
    [self.contentView addSubview:shopName];
    
    //商店地址图标
    shopAddressIcon=[[UIImageView alloc] initWithFrame:CGRectMake(shopImageView.MaxX+10, shopName.MaxY+10,8, 10)];
    shopAddressIcon.image=[UIImage imageNamed:@"dinwgei_2"];
    [self.contentView addSubview:shopAddressIcon];
    
    //商店地址
    shopAddress=[[UILabel alloc] initWithFrame:CGRectMake(shopAddressIcon.MaxX+5, shopName.MaxY+10,SCREEN_WIDTH-shopAddressIcon.MaxX-5-15, 12)];
    shopAddress.font=[UIFont systemFontOfSize:13];
    shopAddress.textColor=[UIColor color_979797];
    [self.contentView  addSubview:shopAddress];
    
    //商店电话图标
   shopPhoneIcon=[[UIImageView alloc] initWithFrame:CGRectMake(shopImageView.MaxX+10, shopAddress.MaxY+6.5,8, 10)];
    shopPhoneIcon.image=[UIImage imageNamed:@"dianhua"];
    [self.contentView  addSubview:shopPhoneIcon];
    
    //商店电话号码
    shopPhone=[[UILabel alloc] initWithFrame:CGRectMake(shopPhoneIcon.MaxX+5, shopAddress.MaxY+6.5,SCREEN_WIDTH-shopPhoneIcon.MaxX-5-15, 12)];
    shopPhone.font=[UIFont systemFontOfSize:11];
    shopPhone.textColor=[UIColor color_979797];
    [self.contentView  addSubview:shopPhone];
    
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(shopImageView.frame)+15)];
    
}
- (void)setModel:(OTWSearchShopModel *)model
{
    _model = model;
    shopName.text = _model.name;
    shopAddress.text = _model.address;
    shopPhone.text = _model.contactInfo;
}

-(void)tapActionForClaim{
    DLog(@"认领商家");

}
@end
