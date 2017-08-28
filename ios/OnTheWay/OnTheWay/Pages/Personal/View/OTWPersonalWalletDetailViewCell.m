//
//  OTWPersonalWalletDetailViewCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalWalletDetailViewCell.h"
@interface OTWPersonalWalletDetailViewCell(){
    UILabel *name;
    UILabel *balance;
    UILabel *date;
    UILabel *numOfMoney;
}

@end
@implementation OTWPersonalWalletDetailViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    //钱的值
    numOfMoney=[[UILabel alloc]init];
    numOfMoney.text=@"+24";
    numOfMoney.textColor=[UIColor color_e50834];
    numOfMoney.font=[UIFont systemFontOfSize:22];
    [numOfMoney sizeToFit];
    numOfMoney.frame=CGRectMake(SCREEN_WIDTH-15-numOfMoney.Witdh, 0,numOfMoney.Witdh, 70);
    [self.contentView addSubview:numOfMoney];
    
    //名称
    name=[[UILabel alloc]init];
    name.textColor=[UIColor color_202020];
    name.text=@"活动领取红包";
    name.font=[UIFont systemFontOfSize:15];
    name.frame=CGRectMake(15, 15, SCREEN_WIDTH-30-numOfMoney.Witdh, 20);
    [self.contentView addSubview:name];

    
    //余额
    balance=[[UILabel alloc]init];
    balance.textColor=[UIColor color_979797];
    balance.text=@"余额：425.34";
    balance.font=[UIFont systemFontOfSize:12];
    [balance sizeToFit];
    balance.frame=CGRectMake(15, name.MaxY+5, balance.Witdh, 15);
     [self.contentView addSubview:balance];
    
    //日期
    date=[[UILabel alloc]init];
    date.textColor=[UIColor color_979797];
    date.text=@"2028.02.28 12:23:12";
    date.font=[UIFont systemFontOfSize:12];
    date.frame=CGRectMake(balance.MaxX+10, name.MaxY+5, SCREEN_WIDTH-30-balance.Witdh-numOfMoney.Witdh, 15);
     [self.contentView addSubview:date];
}

@end
