//
//  OTWFindListModel.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWFootprintListModel : NSObject

//用户头像
@property (nonatomic,copy) NSString *userHeadImg;
//用户昵称
@property (nonatomic,copy) NSString *userNickname;
//足迹内容
@property (nonatomic,copy) NSString *footprintContent;
//足迹发布地址
@property (nonatomic,copy) NSString *footprintAddress;
//足迹发布时间
@property (nonatomic,copy) NSNumber *dateCreated;
//足迹发布时间字符串 例如 1天前 2天前等
@property (nonatomic,copy) NSString *dateCreatedStr;
//足迹封面图片
@property (nonatomic,copy) NSString *footprintPhoto;
//足迹ID
@property (nonatomic,copy) NSNumber *footprintId;
//足迹附件类型 图片 或者 视频
@property (nonatomic,copy) NSString *footprintType;

- (id) initWithDict:(NSDictionary *)dict;

+ (id) footprintWithDict:(NSDictionary *)dict;

@end
