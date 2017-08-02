//
//  OTWFindBusinessmenViewCell.h
//  OnTheWay
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindBusinessmenModel;

@interface OTWFindBusinessmenViewCell : UITableViewCell

#pragma mark 首页对象
@property (nonatomic,strong) FindBusinessmenModel *status;

#pragma mark 单元格高度
@property (assign,nonatomic) CGFloat height;

@end
