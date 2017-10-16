//
//  OTWBusinessDetailViewController.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/5.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"

@interface OTWBusinessDetailViewController : OTWBaseViewController

- (void) setOpData:(NSString *)opId;


//纬度
@property (nonatomic,assign) double latitude;
//经度
@property (nonatomic,assign) double longitude;

@end
