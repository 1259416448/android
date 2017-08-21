//
//  OTWARViewController.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArvixARViewController.h"

/**
 * AR视图类， 采用继承的方式 对AR进行二次开发。
 * 可以在相机上添加自定义图标和事件等
 */

typedef void(^requestBackBlock) (id result);

@interface OTWARViewController : ArvixARViewController

-(void) fetchARFootprints:(NSDictionary *) params completion:(requestBackBlock) block;

@end
