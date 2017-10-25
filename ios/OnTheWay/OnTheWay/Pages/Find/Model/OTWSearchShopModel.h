//
//  OTWSearchShopModel.h
//  OnTheWay
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWSearchShopModel : NSObject

@property (nonatomic,strong) NSString *address;

@property (nonatomic,strong) NSString *contactInfo;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *colorCode;


@property (nonatomic,strong) NSNumber *businessId;
@property (nonatomic,strong) NSNumber *distance;
@property (nonatomic,strong) NSNumber *latitude;
@property (nonatomic,strong) NSNumber *longitude;


@end
