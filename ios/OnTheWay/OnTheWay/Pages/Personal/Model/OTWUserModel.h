//
//  OTWUserModel.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/11.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWUserModel : NSObject <NSCoding>

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *headImgYuan;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *mobilePhoneNumber;
@property (nonatomic,copy) NSString *headImg;
@property (nonatomic,copy) NSString *name;

+ (instancetype)shared;

/**
 * 归档 将user对象保存到本地文件夹
 */
- (void)dump;

/**
 * 取档 从本地文件夹中获取user对象
 */
- (void)load;

/**
 * 清空数据
 */
- (void)logout;


@end
