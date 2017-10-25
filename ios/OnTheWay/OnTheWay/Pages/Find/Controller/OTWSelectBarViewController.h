//
//  OTWSelectBarViewController.h
//  OnTheWay
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"

@protocol OTWSelectBarViewControllerDelegate <NSObject>

- (void)didSelected :(NSString *)str;

@end

@interface OTWSelectBarViewController : OTWBaseViewController

@property (nonatomic, weak) id <OTWSelectBarViewControllerDelegate> delegate;

@end
