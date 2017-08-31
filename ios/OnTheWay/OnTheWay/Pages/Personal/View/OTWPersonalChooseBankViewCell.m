//
//  OTWPersonalChooseBankViewCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalChooseBankViewCell.h"
@interface OTWPersonalChooseBankViewCell(){
    UIImageView *bankImg;
    UILabel *bankName;
   
}

@end@implementation OTWPersonalChooseBankViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    bankImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 14, 20, 20)];
    bankImg.image=[UIImage imageNamed:@"wd_zhaoshang"];
    bankImg.layer.masksToBounds=YES;
    bankImg.layer.cornerRadius = bankImg.frame.size.width / 2;
    [self.contentView addSubview:bankImg];
    
    bankName=[[UILabel alloc]init];
    bankName.text=@"招商银行";
    bankName.textColor=[UIColor color_202020];
    bankName.font=[UIFont systemFontOfSize:16];
    [bankName sizeToFit];
    bankName.frame=CGRectMake(bankImg.MaxX+10, 15, SCREEN_WIDTH-bankImg.MaxX-15, 20);
    [self.contentView addSubview:bankName];
}

@end
