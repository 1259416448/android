//
//  CreateShopPicCell.h
//  OnTheWay
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateShopModel.h"
#import "CreateShopFormModel.h"

@interface CreateShopPicCell : UITableViewCell

@property (nonatomic,strong) CreateShopModel *createShopModel;

@property (nonatomic,strong) CreateShopFormModel *formModel;

@property (assign,nonatomic) CGFloat cellHeight;

-(void)refreshContent:(CreateShopModel *)createModel formModel:(CreateShopFormModel *)formModel control:(UINavigationController*)control;

+(CGFloat)cellHeight:(CreateShopModel *)createModel;

@end
