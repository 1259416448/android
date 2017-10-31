//
//  OTWNewFootprintsTableViewCell.h
//  OnTheWay
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTWNewFootprintsTableViewCellDelegate <NSObject>

- (void)tapAtIndexPath:(NSIndexPath *)indexPath AndImgIndex:(NSInteger)index;

@end

@class OTWFootprintListModel;

@interface OTWNewFootprintsTableViewCell : UITableViewCell

#pragma mark 首页对象
@property (nonatomic,strong) OTWFootprintListModel *status;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIView *ShopDetailsCommentImgList;//评论图片列表



#pragma mark 单元格高度
@property (assign,nonatomic) CGFloat height;

@property (nonatomic,weak) id <OTWNewFootprintsTableViewCellDelegate> delegate;


-(void) setData:(OTWFootprintListModel *)  data;

@end
