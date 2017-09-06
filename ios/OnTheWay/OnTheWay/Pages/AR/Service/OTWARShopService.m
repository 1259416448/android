//
//  OTWARShopService.m
//  OnTheWay
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWARShopService.h"

@implementation OTWARShopService

static NSString *arShopList = @"/app/business/search/{type}";

+(void)getARShopList:(NSDictionary *)params completion:(requestCompletionBlock)block responseCache:(PPHttpRequestCache)responseCache
{
    [OTWNetworkManager doGET:[arShopList stringByReplacingOccurrencesOfString:@"{type}" withString:params[@"type"]] parameters:params responseCache:^(id reponseCache){
        if(responseCache){
            responseCache(reponseCache);
        }
    } success:^(id responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
