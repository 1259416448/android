//
//  OTWNewsModel.h
//  OnTheWay
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWNewsModel : NSObject

//新的足迹动态
@property (nonatomic,copy) NSString *footprintNum;
//新的系统消息
@property (nonatomic,copy) NSString *systemNum;
//新的评论
@property (nonatomic,copy) NSString *CommentNum;
//新的点赞
@property (nonatomic,copy) NSString *likeNum;

+ (id) initWithDict:(NSDictionary *)dict;

@end
