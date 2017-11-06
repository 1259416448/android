//
//  CreateShopTVTWOCell.h
//  OnTheWay
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateShopModel.h"
#import "CreateShopFormModel.h"

@interface CreateShopTVTWOCell : UITableViewCell

@property (nonatomic,strong) CreateShopModel *createShopModel;

@property (assign,nonatomic) CGFloat cellHeight;

-(void)refreshContent:(CreateShopModel *)createModel;

+(CGFloat)cellHeight:(CreateShopModel *)createModel;

@end
