//
//  OTWFootprintService.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintService.h"

@implementation OTWFootprintService

static NSString *footprintReleaseUrl = @"/app/footprint/create";
static NSString *footprintList = @"/app/footprint/search/{type}";

+(void) footprintRelease:(NSDictionary *) params completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doPOST:footprintReleaseUrl parameters:params success:^(id responceBody){
        if(block){
            block(responceBody,nil);
        }
    }failure:^(NSError *error){
        if(block){
            block(nil,error);
        }
    }];
}

+(void) getFootprintList:(NSDictionary *)params completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doGET:[footprintList stringByReplacingOccurrencesOfString:@"{type}" withString:params[@"type"]] parameters:params success:^(id responseObject) {
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
