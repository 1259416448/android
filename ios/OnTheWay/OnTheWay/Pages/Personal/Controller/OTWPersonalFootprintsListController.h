//
//  OTWPersonalFootprintsListController.h
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OTWBaseViewController.h"
#import "OTWPersonalFootprintsListModel.h"
#import <MJRefresh.h>

@interface OTWPersonalFootprintsListController : OTWBaseViewController

@property (nonatomic,assign) BOOL ifMyFootprint;

@property (nonatomic,assign) NSString *userId;

@property (nonatomic,assign) NSString *userNickname;

@property (nonatomic,assign) NSString *userHeaderImg;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray<OTWPersonalFootprintsListModel *> *status;

+(instancetype) initWithIfMyFootprint: (BOOL) ifMyFootprint;

@end

