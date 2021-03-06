//
//  OTWFootprintsViewController.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^requestBackBlock) (id result);

@interface OTWFootprintsViewController : OTWBaseViewController

-(void) fetchFootprints:(NSDictionary *) params completion:(requestBackBlock) block;

@end
