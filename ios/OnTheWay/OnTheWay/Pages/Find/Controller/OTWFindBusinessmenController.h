//
//  OTWFindBusinessmenController.h
//  OnTheWay
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OTWFootprintSearchParams.h"

@interface OTWFindBusinessmenViewController : OTWBaseViewController

//纬度
@property (nonatomic,assign) double latitude;
//经度
@property (nonatomic,assign) double longitude;

@property (nonatomic,assign) BOOL isFromAR;

//商家分类ID
@property (nonatomic,strong) NSString * typeId;

@property (nonatomic,strong) NSString * sortId;

@property (nonatomic,strong) NSString * firstID;

//查询对象
@property (nonatomic,strong) OTWFootprintSearchParams *arShopSearchParams;


//筛选分类数据
@property(nonatomic,strong) NSMutableArray *siftSortArr;

- (void)getShopsList;



@end

