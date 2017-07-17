//
//  OTWFootprintDetail.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/16.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWFootprintListModel.h"


@interface OTWFootprintDetailFrame : NSObject

@property (nonatomic,strong) OTWFootprintListModel *footprintDetailModel;
@property (nonatomic,assign) CGFloat contentH;
@property (nonatomic,assign) CGFloat photoViewH;

/**
 * 行高
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
