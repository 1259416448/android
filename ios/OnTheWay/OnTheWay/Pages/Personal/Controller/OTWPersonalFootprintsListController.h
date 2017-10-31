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
#import "OTWNotFundFootprintView.h"

@protocol OTWPersonalFootprintsListControllerDelegate <NSObject>

- (void)refresh;

@end

@interface OTWPersonalFootprintsListController : OTWBaseViewController

@property (nonatomic,assign) BOOL ifMyFootprint;

@property (nonatomic, assign) BOOL isFromFans;

@property (nonatomic,assign) NSString *userId;

@property (nonatomic,assign) NSString *userNickname;

@property (nonatomic,assign) NSString *userHeaderImg;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray<OTWPersonalFootprintsListModel *> *status;

@property (nonatomic,strong) OTWNotFundFootprintView *notFundFootprintView;

@property (nonatomic,assign) BOOL ifInsertCreateCell;

@property (nonatomic, weak) id <OTWPersonalFootprintsListControllerDelegate> delegate;

+(instancetype) initWithIfMyFootprint: (BOOL) ifMyFootprint;

- (void) insertCreateCell;

@property (nonatomic,strong) UIButton *button;

@end

