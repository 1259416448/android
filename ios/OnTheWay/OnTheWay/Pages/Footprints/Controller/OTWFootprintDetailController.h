//
//  OTWFootprintDetailController.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OTWFootprintDetailModel.h"

@interface  OTWFootprintDetailController : OTWBaseViewController

- (void) moveDelegate;
/**
 * 传递数据，或者id等 想获取足迹详情，传入对应的id或者Model即可
 */
@property (nonatomic, strong) NSString *fid;

@end
