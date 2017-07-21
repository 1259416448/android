//
//  OTWFootprintChangeAddressArrayModel.h
//  OnTheWay
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWFootprintListModel.h"

@interface OTWFootprintChangeAddressArrayModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property(nonatomic,assign)  BOOL  isClick;

+ (instancetype) initWithDict:(NSDictionary *) dict;
@end
