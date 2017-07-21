//
//  OTWCommentModel.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTWFootprintListModel;

@interface OTWNewsCommentModel : NSObject

//用户头像
@property (nonatomic,copy) NSString *sUserImage;
//用户名
@property (nonatomic,copy) NSString *sUserName;
//评论时间
@property (nonatomic,copy) NSString *sCommentTime;
//评论内容
@property (nonatomic,copy) NSString *sCommentContent;
//足迹内容
@property (nonatomic,strong) OTWFootprintListModel *footprint;

-(OTWNewsCommentModel *) initWithDictionary: (NSDictionary *)dic;

+(OTWNewsCommentModel *) commentModelWithDictionary : (NSDictionary *)dic;

@end
