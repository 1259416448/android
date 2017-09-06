//
//  OTWBusinessDetailView.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/3.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTWBusinessModel.h"

@protocol OTWBusinessDetailViewDelegate;

@interface OTWBusinessDetailView : UIView

@property (nonatomic,strong) OTWBusinessModel *businessModel;

@property (nonatomic, weak) id<OTWBusinessDetailViewDelegate> delegate;

- (id) initWithBusinessDetailModel:(OTWBusinessModel *) businessModel;

- (void) changeCheckInStatus;

@end

@protocol OTWBusinessDetailViewDelegate <NSObject>

/**
 * 商家优惠信息被点击时，出发事件
 */
- (void)businessTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 更多照片被点击，一般情况是 photo>4 时才触发。
 */
- (void)morePhotoClick:(OTWBusinessDetailView *)detailView businessModel:(OTWBusinessModel *) businessModel;

//去这里点击
- (void)goMapClick:(OTWBusinessDetailView *)detailView businessModel:(OTWBusinessModel *) businessModel;

//签到点击
- (void)checkInClick:(OTWBusinessDetailView *)detailView businessModel:(OTWBusinessModel *) businessModel;
@end
