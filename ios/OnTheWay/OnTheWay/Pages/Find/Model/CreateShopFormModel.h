//
//  CreateShopFormModel.h
//  OnTheWay
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateShopFormModel : NSObject

//姓名
@property (nonatomic, copy)NSString            *name;
//经度
@property (nonatomic, copy)NSString            *latitude;
//纬度
@property (nonatomic, copy)NSString            *longitude;
//联系方式
@property (nonatomic, copy)NSString            *contactInfo;
//联系地址
@property (nonatomic, copy)NSString            *address;
//商家类型
@property (nonatomic, copy)NSString            *shopType;

+ (instancetype) initWithDict:(NSDictionary *) dict;

@end
