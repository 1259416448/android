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

@property (nonatomic,strong) NSString *contactInfo;

@property (nonatomic,strong) NSArray *typeIds;

@property (nonatomic,strong) NSString *poiDetailUrl;

@property (nonatomic,strong) NSString *poiUid;

@end
