//
//  OTWNewCommentListViewController.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"

typedef void(^requestBackBlock) (id result);

@interface OTWNewCommentListViewController : OTWBaseViewController

-(void) sendRequest:(NSDictionary *) params completion:(requestBackBlock) block;

@end
