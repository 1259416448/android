//
//  OTWCommentService.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/3.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestCompletionBlock)(id result, NSError *error);

@interface OTWCommentService : NSObject

- (void) commentList:(NSDictionary *) params footprintId:(NSString *)footprintId viewController:(UIViewController *)viewController completion:(requestCompletionBlock)block;

- (void) deleteCommentById:(NSString *)commentId viewController:(UIViewController *)viewController completion:(requestCompletionBlock)block;

@end
