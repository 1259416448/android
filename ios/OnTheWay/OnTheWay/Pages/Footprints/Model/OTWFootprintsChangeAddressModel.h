//
//  OTWFootprintsChangeAddressModel.h
//  OnTheWay
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWFootprintChangeAddressArrayModel.h"

@interface OTWFootprintsChangeAddressModel : NSObject

@property (nonatomic,strong) NSString  *city;
@property (nonatomic,strong) NSMutableArray<OTWFootprintChangeAddressArrayModel*>  *addressArray;

+ (instancetype) initWithDict:(NSDictionary *) dict;

@end
