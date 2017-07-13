//
//  OTWFindModel.h
//  OnTheWay
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface OTWFindStatus : NSObject

@property (nonatomic,assign) long long Id;// 模块的id
@property (nonatomic,copy) NSString *FindTpyeBackgroundImageUrl;//背景图片
@property (nonatomic,copy) NSString *FindTpyeName;//模块名称
@property (nonatomic,copy) NSMutableArray *FindTpyeContentList;//模块内容list

#pragma mark 根据字典初始化模块对象
-(OTWFindStatus *)initWithDictionary:(NSDictionary *)dic;

#pragma mark 初始化模块对象（静态方法）
+(OTWFindStatus *)statusWithDictionary:(NSDictionary *)dic;

@end
