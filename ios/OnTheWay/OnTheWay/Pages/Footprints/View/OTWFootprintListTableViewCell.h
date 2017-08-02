//
//  OTWFindListTableViewCell.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTWFootprintListFrame.h"

@interface OTWFootprintListTableViewCell : UITableViewCell

//cell中每条足迹点击事件
@property (nonatomic,copy) void (^tapOne)(NSString *);

- (void)setFootprintListFrame:(OTWFootprintListFrame *) frame;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *) identifier;

@end
