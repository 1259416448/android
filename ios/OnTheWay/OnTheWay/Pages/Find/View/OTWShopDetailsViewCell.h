//
//  OTWShopDetailsViewCell.h
//  OnTheWay
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"

@class OTWFootprintListModel;

@interface OTWShopDetailsViewCell : UITableViewCell

#pragma mark 首页对象
@property (nonatomic,strong) OTWFootprintListModel *status;

#pragma mark 单元格高度
@property (assign,nonatomic) CGFloat height;

@end
