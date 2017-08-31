//
//  OTWARShopService.h
//  OnTheWay
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestCompletionBlock)(id result, NSError *error);

@interface OTWARShopService : NSObject

+(void) getARShopList:(NSDictionary *)params completion:(requestCompletionBlock)block responseCache:(PPHttpRequestCache) responseCache;

@end
