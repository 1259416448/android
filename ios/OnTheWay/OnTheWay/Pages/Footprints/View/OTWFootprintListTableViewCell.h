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

@property (nonatomic,strong) OTWFootprintListFrame *footprintListFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
