//
//  OTWPersonalSiteGanderViewController.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "OTWBaseViewController.h"

typedef void(^requestCompletionBlock) (id result, NSError *error);

@interface OTWPersonalSiteGanderViewController : OTWBaseViewController

-(void) sendRequest:(NSDictionary *) params completion:(requestCompletionBlock)block;

@end
