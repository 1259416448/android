//
//  OTWARCustomAnnotation.h
//  OnTheWay
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ArvixARAnnotation.h"
#import "OTWBusinessFetchModel.h"

@interface OTWARCustomAnnotation : ArvixARAnnotation

@property (nonatomic, strong) OTWFootprintListModel *footprint;
@property (nonatomic, strong) OTWBusinessFetchModel *arShop;

- (instancetype)initWithIdentifier:(NSString*)identifier footprint:(OTWFootprintListModel*)footprint location:(CLLocation*)location;

- (instancetype)initWithIdentifier:(NSString*)identifier arShop:(OTWBusinessFetchModel*)arShop location:(CLLocation*)location;

@end
