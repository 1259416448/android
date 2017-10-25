//
//  OTWSystemNewsCell.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.

#import <UIKit/UIKit.h>
#import "OTWSystemNewsModel.h"

@interface OTWSystemNewsCell : UITableViewCell

@property (nonatomic,strong) OTWSystemNewsModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView systemNewsCellframe:(OTWSystemNewsModel *) frame;

@end
