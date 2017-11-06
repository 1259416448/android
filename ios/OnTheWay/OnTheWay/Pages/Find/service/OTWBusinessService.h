//
//  OTWBusinessService.h
//  OnTheWay
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestCompletionBlock)(id result, NSError *error);
@interface OTWBusinessService : NSObject

+(void) createBusiness:(NSDictionary *) params completion:(requestCompletionBlock)block;

@end
