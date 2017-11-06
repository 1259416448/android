//
//  OTWMyFansViewController.h
//  OnTheWay
//
//  Created by apple on 2017/10/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"

@protocol OTWMyFansViewControllerDelegate <NSObject>

- (void)refreshData;

@end

@interface OTWMyFansViewController : OTWBaseViewController

@property (nonatomic, assign) BOOL isFromFans;

@property (nonatomic, assign) BOOL isNoFans;

@property (nonatomic, weak) id <OTWMyFansViewControllerDelegate> delegate;


@end
