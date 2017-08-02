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
//用户ID
@property (nonatomic,copy) NSNumber *userId;
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

//足迹所有图片,只有获取详情时，才会加载参数
@property (nonatomic,copy) NSArray<NSString *> *footprintPhotoArray;

//足迹总评论数,只有获取详情时，才会加载参数
@property (nonatomic,assign) NSInteger footprintCommentNum;

//足迹总点赞数,只有获取详情时，才会加载参数
@property (nonatomic,assign) NSInteger footprintLikeNum;

@property (nonatomic,strong) NSString *day;

+ (id) initWithDict:(NSDictionary *)dict;

#pragma mark 根据字典初始化模块对象
-(OTWFootprintListModel *)initWithDictionary:(NSDictionary *)dic;

#pragma mark 初始化模块对象（静态方法）
+(OTWFootprintListModel *)statusWithDictionary:(NSDictionary *)dic;

@end
