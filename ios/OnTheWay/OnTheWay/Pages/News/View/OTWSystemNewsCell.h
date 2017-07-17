//
//  OTWSystemNewsCell.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.

#import <UIKit/UIKit.h>
#import "OTWSystemNewsCellFrame.h"

@interface OTWSystemNewsCell : UITableViewCell

@property (nonatomic,strong) OTWSystemNewsCellFrame *systemNewsCellframe;

+ (instancetype)cellWithTableView:(UITableView *)tableView systemNewsCellframe:(OTWSystemNewsCellFrame *) frame;

@end
