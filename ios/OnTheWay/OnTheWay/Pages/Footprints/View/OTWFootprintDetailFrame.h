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
@property (nonatomic,assign) CGFloat nicknameH;
@property (nonatomic,assign) CGFloat photoViewH;
@property (nonatomic,assign) CGFloat dateCreatedStrW;

/**
 * 行高
 */
@property (nonatomic, assign) CGFloat cellHeight;

//是否输入商家详情页进入
@property (nonatomic, assign) BOOL ifBusiness;

@end
