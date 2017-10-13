//
//  OTWFindBusinessmenController.h
//  OnTheWay
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface OTWFindBusinessmenViewController : OTWBaseViewController

//纬度
@property (nonatomic,assign) double latitude;
//经度
@property (nonatomic,assign) double longitude;

@property (nonatomic,assign) BOOL isFromAR;

//商家分类ID
@property (nonatomic,strong) NSString * typeId;

//筛选分类数据
@property(nonatomic,strong) NSMutableArray *siftSortArr;



@end

