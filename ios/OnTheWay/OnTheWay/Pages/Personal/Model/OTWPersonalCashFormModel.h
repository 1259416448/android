//
//  OTWPersonalCashFormModel.h
//  OnTheWay
//
//  Created by UI002 on 2017/8/29.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWPersonalCashFormModel : NSObject
//姓名
@property (nonatomic, copy)NSString            *name;
//卡号
@property (nonatomic, copy)NSString            *bankCard;
//银行
@property (nonatomic, copy)NSString            *bankName;

+ (instancetype) initWithDict:(NSDictionary *) dict;
@end
