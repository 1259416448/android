//
//  OTWCommentModel.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface OTWCommentModel : NSObject

//评论发布时间
@property (nonatomic,copy) NSNumber *dateCreated;

//评论发布时间字符串
@property (nonatomic,copy) NSNumber *dateCreatedStr;

//用户头像
@property (nonatomic,copy) NSString *userHeadImg;

//用户昵称
@property (nonatomic,copy) NSString *userNickname;

//评论内容
@property (nonatomic,copy) NSString *commentContent;

+ (id) initWithDict:(NSDictionary *)dict;

@end

