//
//  OTWPlaneMapViewController.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"

typedef void(^requestBackBlock) (id result);
@interface OTWPlaneMapViewController : OTWBaseViewController

-(void) fetchARFootprints:(NSDictionary *) params completion:(requestBackBlock) block;

@end
