//
//  OTWBusinessSortModel.h
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/9/22.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWBusinessDetailSortModel.h"

@interface OTWBusinessSortModel : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *colorCode;

@property (nonatomic,assign) NSNumber * typeId;

@property (nonatomic,assign) BOOL selected;

@property (nonatomic,strong) NSMutableArray<OTWBusinessDetailSortModel *> *children;

@end
