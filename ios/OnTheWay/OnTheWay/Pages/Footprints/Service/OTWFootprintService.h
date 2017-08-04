//
//  OTWFootprintService.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^requestCompletionBlock)(id result, NSError *error);

@interface OTWFootprintService : NSObject

+(void) footprintRelease:(NSDictionary *) params completion:(requestCompletionBlock)block;

+(void) getFootprintList:(NSDictionary *)params completion:(requestCompletionBlock)block responseCache:(PPHttpRequestCache) responseCache;

+(void) getFootprintDetailById:(NSString *)footprintId completion:(requestCompletionBlock)block;

+(void) releaseComment:(NSDictionary *) params completion:(requestCompletionBlock)block;

+(void) likeFootprint:(NSDictionary *) params completion:(requestCompletionBlock)block;

+(void) deleteFootprintById:(NSString *) footprintId viewController:(UIViewController *)viewController completion:(requestCompletionBlock)block;


@end
