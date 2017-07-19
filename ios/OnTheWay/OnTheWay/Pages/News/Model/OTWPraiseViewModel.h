//
//  OTWPraiseViewModel.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface OTWPraiseViewModel : NSObject

@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *content;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *profile_image;

@property (nonatomic, copy) NSString *vedio_url;

@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, copy) NSString *topicContent;

#pragma 根据字典初始化点赞对象
-(OTWPraiseViewModel *)initWithDictionary : (NSDictionary *)dic;

+(OTWPraiseViewModel *) statusWithDictionary : (NSDictionary *)dic;

@end
