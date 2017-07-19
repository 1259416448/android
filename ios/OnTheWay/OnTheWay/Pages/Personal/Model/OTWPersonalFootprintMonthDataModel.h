//
//  OTWPersonalFootprintMonthDataModel.h
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWFootprintListModel.h"

@interface OTWPersonalFootprintMonthDataModel : NSObject

@property (nonatomic,strong) NSString *day;
@property (nonatomic,strong) NSMutableArray<OTWFootprintListModel *> *dayData;

+ (instancetype) initWithDict:(NSDictionary *) dict;

@end
