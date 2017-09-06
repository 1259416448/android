//
//  OTWBusinessDetailService.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/5.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessDetailService.h"

@implementation OTWBusinessDetailService

static NSString *businessDetailUrl = @"/app/business/view/{id}";

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

@end
