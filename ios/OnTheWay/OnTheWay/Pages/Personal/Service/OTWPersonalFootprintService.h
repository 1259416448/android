//
//  OTWPersonalFootprintService.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/2.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^requestCompletionBlock)(id result, NSError *error);

@interface OTWPersonalFootprintService : NSObject

- (void) userFootprintList:(NSDictionary *) params userId:(NSString *)userId viewController:(UIViewController *)viewController completion:(requestCompletionBlock)block;

- (BOOL) checkIfNotFund:(UIViewController *)viewController;

@end
