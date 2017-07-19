//
//  OTWPersonalFootprintsListModel.h
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWPersonalFootprintMonthDataModel.h"

@interface OTWPersonalFootprintsListModel  : NSObject

@property (nonatomic,strong) NSString  *month;
@property (nonatomic,strong) NSMutableArray<OTWPersonalFootprintMonthDataModel *>  *monthData;

+ (instancetype) initWithDict:(NSDictionary *) dict;

@end
