//
//  OTWBusinessExpand.h
//  OnTheWay
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWBusinessExpand : NSObject
//证件号码
@property (nonatomic, copy)NSString            *certificateNumber;
//证件类型
@property (nonatomic, copy)NSString            *certificateType;
//手机号码
@property (nonatomic, copy)NSString            *mobilePhoneNumber;
//提交人姓名
@property (nonatomic, copy)NSString            *name;
//组织机构代码
@property (nonatomic, copy)NSString            *organizationNumber;

+ (instancetype) initWithDict:(NSDictionary *) dict;

@end
