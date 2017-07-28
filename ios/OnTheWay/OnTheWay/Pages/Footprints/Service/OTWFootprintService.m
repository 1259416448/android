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

@end
