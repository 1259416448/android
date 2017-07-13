//
//  OTWFootprintListFrame.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTWFootprintListModel;

@interface OTWFootprintListFrame : NSObject

@property (nonatomic,assign) CGRect userHeadImgF;

@property (nonatomic,assign) CGRect footprintPhotoImgF;

@property (nonatomic,assign) CGRect userNicknameF;

@property (nonatomic,assign) CGRect footprintContentF;

@property (nonatomic,assign) CGRect footprintAddressF;

@property (nonatomic,assign) CGRect dataCreatedF;

@property (nonatomic,assign) CGRect footprintAddressImageF;

@property (nonatomic,assign) CGRect dataCreatedImageF;

@property (nonatomic,assign) CGRect footprintBGF;

@property (nonatomic,strong) OTWFootprintListModel *footprint;

/**
 * 行高
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
