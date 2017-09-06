//
//  OTWBusinessActivityTableViewCell.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/5.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTWBusinessActivityTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *) identifier;

- (void) setDate:(NSString *)activityName typeName:(NSString *)typeName typeColor:(UIColor *)typeColor isLast:(BOOL)isLast;

@end
