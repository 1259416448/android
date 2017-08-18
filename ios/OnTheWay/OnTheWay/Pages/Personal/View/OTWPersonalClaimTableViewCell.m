//
//  OTWPersonalClaimTableViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalClaimTableViewCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "OTWPersonalClaimModel.h"

@interface OTWPersonalClaimTableViewCell (){
    UIImageView *claimShopOtherInfoIconImg;
    UILabel *claimShopOtherInfoNameLebel;
    UIImageView *claimShopOtherInfoLeftArrow;
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
    claimShopOtherInfoIconImg=[[UIImageView alloc]init];
    [self.contentView addSubview:claimShopOtherInfoIconImg];
    
    claimShopOtherInfoLeftArrow=[[UIImageView alloc]init];
    [self.contentView addSubview:claimShopOtherInfoLeftArrow];
    
    claimShopOtherInfoNameLebel=[[UILabel alloc]init];
    [self.contentView addSubview:claimShopOtherInfoNameLebel];

}
- (void)setStatus:(OTWPersonalClaimModel *)status{
    claimShopOtherInfoIconImg.frame=CGRectMake(15, 16.5, 17, 17);
    claimShopOtherInfoIconImg.image=[UIImage imageNamed:status.claimShopOtherInfoIcon];
    
    claimShopOtherInfoLeftArrow.image=[UIImage imageNamed:@"arrow_right"];
    claimShopOtherInfoLeftArrow.frame=CGRectMake(SCREEN_WIDTH-15-7, 19, 7, 12);
    
    claimShopOtherInfoNameLebel.text=status.claimShopOtherInfoName;
    claimShopOtherInfoNameLebel.textColor=[UIColor color_202020];
    claimShopOtherInfoNameLebel.font=[UIFont systemFontOfSize:15];
    claimShopOtherInfoNameLebel.frame=CGRectMake(claimShopOtherInfoIconImg.MaxX+10, 15, 65, 20);

    
}
@end
