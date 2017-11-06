//
//  OTWAddNewShopNextViewController.h
//  OnTheWay
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"
#import "OTWSearchShopModel.h"

@class CreateShopFormModel;

@interface OTWAddNewShopNextViewController : OTWBaseViewController

@property (nonatomic,strong) CreateShopFormModel *createShopFormData;

@property (nonatomic, strong) OTWSearchShopModel * model;

@property (nonatomic, assign) BOOL isFromSearchShop;


@end
