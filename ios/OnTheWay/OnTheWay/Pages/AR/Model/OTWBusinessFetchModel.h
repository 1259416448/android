//
//  OTWBusinessFetchModel.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWBusinessFetchModel : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *address;

@property (nonatomic,assign) double latitude;

@property (nonatomic,assign) double longitude;
//联系方式
@property (nonatomic,strong) NSString *contactInfo;

@property (nonatomic,strong) NSArray *typeIds;

@property (nonatomic,strong) NSString *poiDetailUrl;

@property (nonatomic,strong) NSString *poiUid;
//商家颜色值
@property (nonatomic,strong) NSString *colorCode;
//距离
@property (nonatomic,assign) double distance;

+ (id) initWithDict:(NSDictionary *)dict;

@end
