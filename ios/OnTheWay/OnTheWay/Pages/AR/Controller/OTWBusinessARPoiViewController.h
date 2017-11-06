//
//  OTWBusinessARPoiViewController.h
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/9/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTWBaseViewController.h"
#import "ArvixARViewController.h"

typedef void(^requestBackBlock) (id result);

@interface OTWBusinessARPoiViewController : ArvixARViewController

-(void) fetchARShops:(NSDictionary *) params completion:(requestBackBlock) block;

@end
