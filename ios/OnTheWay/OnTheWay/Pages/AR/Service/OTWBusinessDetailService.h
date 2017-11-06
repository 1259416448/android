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

/**
 * businessId 商家ID
 * currentTime 商家详情请求时返回的时间戳
 * completion 请求完成的回调处理
 */
- (void) fetchBusinessFootprints:(NSString *)businessId  currentTime:(NSNumber *)currentTime completion:(requestCompletionBlock)block;

/**
 * 获取分页中的当前分页大小
 */
- (int) getDefaultPageSize;

- (int) getDefaultPageNumber;

- (void) setNumber:(int)number;

@end
