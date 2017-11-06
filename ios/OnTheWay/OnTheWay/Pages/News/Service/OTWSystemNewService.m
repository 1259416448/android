//
//  OTWSystemNewService.m
//  OnTheWay
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWSystemNewService.h"

@implementation OTWSystemNewService

static NSString *systemNewsUrl = @"/app/message/new";
static NSString *newCommentUrl = @"/app/message/comment/search";

+(void)loadAllSystemNews:(NSDictionary *)params completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doGET:systemNewsUrl parameters:params success:^(id responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

+(void)loadAllNewComments:(NSDictionary *)params completion:(requestCompletionBlock)block responseCacheFun:(PPHttpRequestCache)responseCacheFun
{
    [OTWNetworkManager doGET:newCommentUrl parameters:params responseCache:^(id responseCache) {
        if(responseCache){
            responseCacheFun(responseCache);
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
