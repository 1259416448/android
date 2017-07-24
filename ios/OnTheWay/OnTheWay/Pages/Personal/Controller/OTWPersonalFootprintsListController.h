//
//  OTWPersonalFootprintsListController.h
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OTWBaseViewController.h"

@interface OTWPersonalFootprintsListController : OTWBaseViewController

@property (nonatomic,assign) BOOL ifMyFootprint;

+(instancetype) initWithIfMyFootprint: (BOOL) ifMyFootprint;

@end

