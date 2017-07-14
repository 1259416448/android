//
//  OTWFindBusinessMenFrame.h
//  OnTheWay
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <Foundation/Foundation.h>

@class FindBusinessmenModel;

@interface OTWFindBusinessmenFrame : NSObject

@property (nonatomic,assign) CGRect userNameF;

@property (nonatomic,assign) CGRect needTimeF;

@property (nonatomic,assign) CGRect distanceF;

@property (nonatomic,assign) CGRect addressContentF;

//@property (nonatomic,assign) CGRect couponsF;

@property(nonatomic,assign) CGRect addressImageF;

@property (nonatomic,assign) CGRect findBusinessBGF;

@property (nonatomic,strong) FindBusinessmenModel *findBusinessmen;

/**
 * 行高
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
