//
//  OTWBusinessDetailService.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/5.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessDetailService.h"

@interface OTWBusinessDetailService ()

//当前页
@property (nonatomic,assign) int number;

//每天大小
@property (nonatomic,assign) int size;

@end

@implementation OTWBusinessDetailService

static NSString *businessDetailUrl = @"/app/business/view/{id}";
static NSString *businessFootprintUrl= @"/app/business/footprint/search/{id}";

- (void) fetchBusinessDetail:(NSString *)opId completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doGET:[businessDetailUrl stringByReplacingOccurrencesOfString:@"{id}" withString:opId] parameters:nil success:^(id responseObject) {
        if(block){
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if(block){
            block(nil,error);
        }
    }];
}

/**
 * businessId 商家ID
 * currentTime 商家详情请求时返回的时间戳
 * completion 请求完成的回调处理
 */
- (void) fetchBusinessFootprints:(NSString *)businessId  currentTime:(NSNumber *)currentTime completion:(requestCompletionBlock)block
{
    NSDictionary *params;
    if(self.size == 0){
        self.size = 10;
    }
    if(self.number == 0){
        self.number = 1;
    }
    if(currentTime){
        params = @{
                   @"currentTime":currentTime,
                   @"number":[NSNumber numberWithInt:self.number],
                   @"size":[NSNumber numberWithInt:self.size]
                   };
    }else{
        params = @{
                   @"number":[NSNumber numberWithInt:self.number],
                   @"size":[NSNumber numberWithInt:self.size]
                   };
    }
    [OTWNetworkManager doGET:[businessFootprintUrl stringByReplacingOccurrencesOfString:@"{id}" withString:businessId] parameters:params success:^(id responseObject) {
        if(block){
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if(block){
            block(nil,error);
        }
    }];
}

- (int) getDefaultPageSize
{
    if(self.size == 0) self.size = 10;
    return self.size;
}

- (int) getDefaultPageNumber
{
    return self.number;
}

- (void) setNumber:(int)number
{
    _number= number;
}

@end
