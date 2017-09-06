//
//  OTWBusinessDetailService.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/5.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestCompletionBlock)(id result, NSError *error);

@interface OTWBusinessDetailService : NSObject

- (void) fetchBusinessDetail:(NSString *)opId completion:(requestCompletionBlock)block;

@end
