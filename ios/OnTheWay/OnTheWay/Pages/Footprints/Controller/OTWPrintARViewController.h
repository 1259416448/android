//
//  OTWPrintARViewController.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArvixARViewController.h"

typedef void(^requestBackBlock) (id result);

@interface OTWPrintARViewController : ArvixARViewController

-(void) fetchARFootprints:(NSDictionary *) params completion:(requestBackBlock) block;

@end
