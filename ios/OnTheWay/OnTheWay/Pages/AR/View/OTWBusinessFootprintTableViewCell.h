//
//  OTWBusinessFootprintTableViewCell.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/7.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTWBusinessFootprintFrame.h"

typedef void(^ButtonClickBlock)(UITableViewCell *cell);

@interface OTWBusinessFootprintTableViewCell : UITableViewCell

@property (nonatomic,copy) ButtonClickBlock block;

@property (nonatomic,copy) ButtonClickBlock likeBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *) identifier;

- (void) setData:(OTWBusinessFootprintFrame *) businessFootprintFrame;

@end
