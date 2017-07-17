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
@property (nonatomic,copy) NSString *newsTitle;
//系统消息时间
@property (nonatomic,copy) NSString *newsTime;
//系统消息内容
@property (nonatomic,copy) NSString *newsContent;

+ (id) initWithDict:(NSDictionary *)dict;

@end
