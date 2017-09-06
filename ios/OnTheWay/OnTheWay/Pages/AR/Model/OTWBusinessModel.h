//
//  OTWBusinessModel.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/3.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWFootprintDetailModel.h"
#import "OTWBusinessActivityModel.h"

@interface OTWBusinessModel : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *address;

@property (nonatomic,assign) double *latitude;

@property (nonatomic,assign) double *longitude;

@property (nonatomic,strong) NSString *contactInfo;

@property (nonatomic,strong) NSArray<NSString *> *photoUrls;

@property (nonatomic,strong) NSString *colorCode;

@property (nonatomic,assign) float *weight;

@property (nonatomic,strong) NSSet<NSString *> *typeIds;

@property (nonatomic,assign) BOOL ifLike;

@property (nonatomic,assign) BOOL ifCheckIn;

@property (nonatomic,assign) int collectionNum;

@property (nonatomic,assign) int commentNum;

@property (nonatomic,assign) int businessPhotoNum;

@property (nonatomic,assign) int userPhotoNum;

@property (nonatomic,assign) NSNumber *currentTime;

@property (nonatomic,strong) NSArray<OTWFootprintDetailModel *> *footprints;

@property (nonatomic,strong) NSArray<OTWBusinessActivityModel *> *activitys;

@end
