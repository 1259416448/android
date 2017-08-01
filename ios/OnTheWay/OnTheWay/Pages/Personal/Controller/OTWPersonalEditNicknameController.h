//
//  OTWPersonalEditNickname.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/9.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^requestCompletionBlock) (id result, NSError *error);

@interface OTWPersonalEditNicknameController : OTWBaseViewController

-(void) sendRequest:(NSDictionary *) params completion:(requestCompletionBlock)block;

@end
