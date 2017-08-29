//
//  OTWBusinessService.m
//  OnTheWay
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessService.h"

@implementation OTWBusinessService

static NSString *createBusinessUrl = @"/app/business/create";

+(void)createBusiness:(NSDictionary *)params completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doPOST:createBusinessUrl parameters:params success:^(id responceBody){
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
