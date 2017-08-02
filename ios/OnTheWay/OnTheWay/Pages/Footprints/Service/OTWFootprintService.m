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
static NSString *footprintDetail = @"/app/footprint/view/{id}";
static NSString *releaseComment = @"/app/footprint/comment/create";

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

+(void) getFootprintList:(NSDictionary *)params completion:(requestCompletionBlock)block responseCache:(PPHttpRequestCache) responseCache
{
    [OTWNetworkManager doGET:[footprintList stringByReplacingOccurrencesOfString:@"{type}" withString:params[@"type"]] parameters:params responseCache:^(id reponseCache){
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

#pragma mark 根据id获取足迹详情
+(void) getFootprintDetailById:(NSString *)footprintId completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doGET:[footprintDetail stringByReplacingOccurrencesOfString:@"{id}" withString:footprintId] parameters:footprintId success:^(id responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

+(void) releaseComment:(NSDictionary *)params completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doPOST:releaseComment parameters:params success:^(id responseObject) {
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
