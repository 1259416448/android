//
//  OTWARShopViewController.h
//  OnTheWay
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"
#import "ArvixARViewController.h"

typedef void(^requestBackBlock) (id result);

@interface OTWARShopViewController : ArvixARViewController

-(void) fetchARFootprints:(NSDictionary *) params completion:(requestBackBlock) block;

@end
