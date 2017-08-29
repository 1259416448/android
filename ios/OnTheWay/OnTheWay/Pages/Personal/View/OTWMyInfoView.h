//
//  OTWMyInfoView.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/22.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTWPersonalStatisticsModel.h"
/**
 * 个人中心列表中我的个人信息
 */
@interface OTWMyInfoView : UIView

@property (nonatomic,assign) NSString *userId;

@property (nonatomic,assign) NSString *userNickname;

@property (nonatomic,assign) NSString *userHeaderImg;

@property (nonatomic,strong) OTWPersonalStatisticsModel *statistics;

+ (instancetype) initWithUserInfo:(NSString*)userNickname userId:(NSString*)userId userHeaderImg:(NSString*)userHeaderImg ifMy:(BOOL) ifMy;

/**
 * 设置第一种版面样式 tableView 滚动至顶部
 */
- (void) changeFrameOne;

/**
 * 设置第二种版面样式 tableView 向下滚动
 */
- (void) changeFrameTwo;

- (void) refleshData;
@end
