//
//  OTWPointAnnotation.h
//  OnTheWay
//
//  Created by apple on 2017/8/8.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface OTWPointAnnotation : BMKPointAnnotation

@property (nonatomic, strong) OTWFootprintListModel *footprint;

@end
