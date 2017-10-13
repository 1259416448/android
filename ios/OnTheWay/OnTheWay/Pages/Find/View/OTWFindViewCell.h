//
//  OTWFindViewCell.h
//  OnTheWay
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <UIKit/UIKit.h>

@class OTWFindStatus;

@protocol OTWFindViewCellDelegate <NSObject>

- (void)selectedWithTypeId:(NSNumber *)typeId andIndexpath:(NSIndexPath *)indexpath;

@end

@interface OTWFindViewCell : UITableViewCell


#pragma mark 首页对象
@property (nonatomic,strong) OTWFindStatus *status;

#pragma mark 单元格高度
@property (assign,nonatomic) CGFloat height;

@property (nonatomic,strong) NSIndexPath *indexPath;


@property (nonatomic, weak) id <OTWFindViewCellDelegate> delegate;


@end
