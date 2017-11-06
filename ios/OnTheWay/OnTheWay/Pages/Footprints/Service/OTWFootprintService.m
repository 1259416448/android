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
static NSString *likeFootprint = @"/app/footprint/like/{id}";
static NSString *deleteFootprintUrl = @"/app/footprint/delete/{id}";

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

#pragma mark 获取足迹列表
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

+(void)likeFootprint:(NSString *)footprintId completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doPOST:[likeFootprint stringByReplacingOccurrencesOfString:@"{id}" withString:footprintId] parameters:nil success:^(id responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

#pragma mark - 删除足迹
+(void) deleteFootprintById:(NSString *) footprintId viewController:(OTWFootprintDetailController *)viewController completion:(requestCompletionBlock)block{
    if(!footprintId) return;
    MBProgressHUD *hud = [OTWUtils alertLoading:@"" userInteractionEnabled:NO target:viewController];
    [OTWNetworkManager doPOST:[deleteFootprintUrl stringByReplacingOccurrencesOfString:@"{id}" withString:footprintId] parameters:nil success:^(id responseObject) {
        [hud hideAnimated:YES];
        if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
            [OTWUtils  alertSuccess:@"删除成功" userInteractionEnabled:YES target:viewController];
            //发送删除成功通知
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:footprintId,@"footprintId", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"foorprintAlreadyDeleted" object:nil userInfo:dict];
            if(block){
                block(responseObject,nil);
            }
        }else{
            [viewController errorTips:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO];
        }
    } failure:^(NSError *error) {
        [viewController netWorkErrorTips:error];
    }];
    
}

@end
