//
//  OTWSystemNewsCellFrame.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <Foundation/Foundation.h>

@class OTWSystemNewsModel;

@interface OTWSystemNewsCellFrame : NSObject

@property (nonatomic,assign) CGRect newsTitleF;

@property (nonatomic,assign) CGRect newsTimeF;

@property (nonatomic,assign) CGRect newsContentF;

@property (nonatomic,strong) OTWSystemNewsModel *newsmodel;

@property (nonatomic,assign) CGRect newsBGF;

@property (nonatomic,assign) CGFloat cellHeight;

@end
