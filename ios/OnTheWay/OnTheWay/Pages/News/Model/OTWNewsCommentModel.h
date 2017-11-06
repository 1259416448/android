//
//  OTWCommentModel.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWNewsCommentModel : NSObject

//用户头像
@property (nonatomic,copy) NSString *userHeadImg;
//用户名
@property (nonatomic,copy) NSString *userNickname;
//评论时间
@property (nonatomic,copy) NSString *dateCreatedStr;
//评论内容
@property (nonatomic,copy) NSString *commentContent;
//足迹内容
@property (nonatomic,strong) NSString *footprintContent;
//commentId
@property (nonatomic, strong) NSNumber *commentId;
//userId
@property (nonatomic, strong) NSNumber *userId;
//footprintId
@property (nonatomic, strong) NSNumber *footprintId;



//-(OTWNewsCommentModel *) initWithDictionary: (NSDictionary *)dic;

+(OTWNewsCommentModel *) commentModelWithDictionary : (NSDictionary *)dic;

@end
