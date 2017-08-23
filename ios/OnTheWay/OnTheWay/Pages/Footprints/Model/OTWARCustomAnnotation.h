//
//  OTWARCustomAnnotation.h
//  OnTheWay
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ArvixARAnnotation.h"

@interface OTWARCustomAnnotation : ArvixARAnnotation

@property (nonatomic, strong) OTWFootprintListModel *footprint;

- (instancetype)initWithIdentifier:(NSString*)identifier footprint:(OTWFootprintListModel*)footprint location:(CLLocation*)location;

@end
