//
//  OTWPersonalFootprintsListTableViewCell.h
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OTWPersonalFootprintMonthDataModel.h"

@interface OTWPersonalFootprintsListTableViewCell : UITableViewCell

//cell中每条足迹点击事件
@property (nonatomic,copy) void (^tapOne)(NSString *);

//cell中点击相机发布
@property (nonatomic,copy) void (^tapRelease)();

-(void) setData:(OTWPersonalFootprintMonthDataModel *)  data;

@property (nonatomic,assign) BOOL ifMyFootprint;

@end
