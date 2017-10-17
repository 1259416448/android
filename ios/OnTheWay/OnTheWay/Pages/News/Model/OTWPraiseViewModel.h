//
//  OTWPraiseViewModel.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface OTWPraiseViewModel : NSObject

@property (nonatomic,copy) NSString *dateCreatedStr;

@property (nonatomic,copy) NSString *content;

@property (nonatomic, copy) NSString *userNickname;

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, copy) NSString *userHeadImg;

@property (nonatomic, strong) NSNumber *footprintId;

@property (nonatomic, copy) NSString *footprintContent;

@property (nonatomic, strong) NSNumber *dateCreated;

#pragma 根据字典初始化点赞对象
-(OTWPraiseViewModel *)initWithDictionary : (NSDictionary *)dic;

+(OTWPraiseViewModel *) statusWithDictionary : (NSDictionary *)dic;

@end
