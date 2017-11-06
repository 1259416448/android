//
//  OTWSystemNewService.h
//  OnTheWay
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestCompletionBlock)(id result, NSError *error);

@interface OTWSystemNewService : NSObject

+(void)loadAllSystemNews:(NSDictionary *) params completion:(requestCompletionBlock)block;

+(void)loadAllNewComments:(NSDictionary *) params completion:(requestCompletionBlock)block responseCacheFun:(PPHttpRequestCache) responseCacheFun;

@end
