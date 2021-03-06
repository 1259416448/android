//
//  CreateShopTFCell.h
//  OnTheWay
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateShopModel.h"
#import "CreateShopFormModel.h"

@interface CreateShopTFCell : UITableViewCell

@property (nonatomic,strong) CreateShopModel *createShopModel;

@property (nonatomic,strong) CreateShopFormModel *formModel;

@property (assign,nonatomic) CGFloat cellHeight;

-(void)refreshContent:(CreateShopModel *)createModel formModel:(CreateShopFormModel *)formModel;

+(CGFloat)cellHeight:(CreateShopModel *)createModel;

@end
