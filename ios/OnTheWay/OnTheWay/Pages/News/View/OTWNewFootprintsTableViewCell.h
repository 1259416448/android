//
//  OTWNewFootprintsTableViewCell.h
//  OnTheWay
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTWFootprintListModel;

@interface OTWNewFootprintsTableViewCell : UITableViewCell

#pragma mark 首页对象
@property (nonatomic,strong) OTWFootprintListModel *status;

#pragma mark 单元格高度
@property (assign,nonatomic) CGFloat height;

-(void) setData:(OTWFootprintListModel *)  data;

@end
