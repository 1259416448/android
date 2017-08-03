//
//  OTWFootprintDetailViewCell.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTWCommentFrame.h"

@interface OTWFootprintDetailViewCell : UITableViewCell
/**
 *创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString*)identifier;

- (void)setData:(OTWCommentFrame *)data;

@end
