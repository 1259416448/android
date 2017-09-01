//
//  OTWPersonalHistroyPayeeViewCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/28.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalHistroyPayeeViewCell.h"
@interface OTWPersonalHistroyPayeeViewCell(){
    UIImageView *bankImg;
    UILabel *userName;
    UILabel *bankName;
    UILabel *bankCard;
}

@end
@implementation OTWPersonalHistroyPayeeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    bankImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 12.5, 40, 40)];
    bankImg.image=[UIImage imageNamed:@"wd_zhaoshang"];
    bankImg.layer.masksToBounds=YES;
    bankImg.layer.cornerRadius = bankImg.frame.size.width / 2;
    [self.contentView addSubview:bankImg];
    
    userName=[[UILabel alloc]initWithFrame:CGRectMake(bankImg.MaxX+15, 12.5, SCREEN_WIDTH-bankImg.MaxX-15-15, 20)];
    userName.text=@"糖金梅";
    userName.textColor=[UIColor color_202020];
    userName.font=[UIFont systemFontOfSize:16];
    [self.contentView addSubview:userName];
    
    bankCard=[[UILabel alloc]init];
    bankCard.text=@"622212****4343";
    bankCard.textColor=[UIColor color_979797];
    bankCard.font=[UIFont systemFontOfSize:13];
    [bankCard sizeToFit];
    bankCard.frame=CGRectMake(bankImg.MaxX+15, userName.MaxY+5, bankCard.Witdh, 15);
    [self.contentView addSubview:bankCard];
    
    bankName=[[UILabel alloc]init];
    bankName.text=@"招商银行";
    bankName.textColor=[UIColor color_979797];
    bankName.font=[UIFont systemFontOfSize:13];
    [bankName sizeToFit];
    bankName.frame=CGRectMake(bankCard.MaxX+5, userName.MaxY+5, bankName.Witdh, 15);
    [self.contentView addSubview:bankName];
}

@end
