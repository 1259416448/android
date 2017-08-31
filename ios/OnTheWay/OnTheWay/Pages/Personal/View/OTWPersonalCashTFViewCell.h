//
//  OTWPersonalCashTFViewCell.h
//  OnTheWay
//
//  Created by UI002 on 2017/8/29.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OTWPersonalCashModel.h"
#import "OTWPersonalCashFormModel.h"

@interface OTWPersonalCashTFViewCell : UITableViewCell

@property (nonatomic,strong) OTWPersonalCashModel *OTWPersonalCashModel;

@property (nonatomic,strong) OTWPersonalCashFormModel *formModel;

@property (assign,nonatomic) CGFloat cellHeight;

-(void)refreshContent:(OTWPersonalCashModel *)createModel formModel:(OTWPersonalCashFormModel *)formModel;

+(CGFloat)cellHeight:(OTWPersonalCashModel *)createModel;
@end
