//
//  OTWBusinessFootprintFrame.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/7.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWFootprintListModel.h"
#import "PYPhotosView.h"

@interface OTWBusinessFootprintFrame : NSObject

//足迹详情信息
@property (nonatomic,strong) OTWFootprintListModel *footprintDetail;

//内容高
@property (nonatomic,assign) CGFloat contentH;

//照片高
@property (nonatomic,assign) CGFloat photoViewH;

/**
 * 行高
 */
@property (nonatomic, assign) CGFloat cellHeight;

//照片高度
@property (nonatomic,assign) CGFloat photoH;

//照片宽度
@property (nonatomic,assign) CGFloat photoW;

//昵称宽度
@property (nonatomic,assign) CGFloat nicknameW;

//图片浏览信息
@property (nonatomic,strong) PYPhotosView *photosView;

@property (nonatomic,assign) long likeTime;

@property (nonatomic,assign) BOOL ifSubLike;

- (id) initWithFootprint:(OTWFootprintListModel *)footprint;

@end
