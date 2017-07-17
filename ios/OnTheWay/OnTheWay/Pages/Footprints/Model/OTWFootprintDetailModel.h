//
//  OTWFootprintDetailModel.h
//  OnTheWay
//  足迹详情页中展示包含两种数据，一种是足迹详情、一种是评论信息
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWFootprintListModel.h"
#import "OTWCommentModel.h"

@interface OTWFootprintDetailModel : NSObject

@property (nonatomic,strong) OTWFootprintListModel *footprintDetail;
@property (nonatomic,strong) NSMutableArray<OTWCommentModel *> *comments;

+ (id) initWithDict:(NSDictionary *)dict;

@end

