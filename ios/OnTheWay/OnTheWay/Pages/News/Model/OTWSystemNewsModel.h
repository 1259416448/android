//
//  OTWSystemNewsModel.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface OTWSystemNewsModel : NSObject

//系统消息标题
@property (nonatomic,copy) NSString *title;
//系统消息时间
@property (nonatomic,copy) NSString *dateCreatedStr;
//系统消息内容
@property (nonatomic,copy) NSString *content;

@property (nonatomic,strong) NSNumber *dataId;

//@property (nonatomic,copy) NSString *dateCreated;
@property (nonatomic,copy) NSString *dateCreatedFormat;



+ (id) initWithDict:(NSDictionary *)dict;

@end
