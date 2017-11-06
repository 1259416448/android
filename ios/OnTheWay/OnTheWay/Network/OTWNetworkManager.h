//
//  OTWNetworkManager.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/8.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <PPNetworkHelper/PPNetworkHelper.h>

/** 请求成功的Block */
typedef void(^OTWHttpRequestSuccess)(id responseObject);

@interface OTWNetworkManager : PPNetworkHelper


+ (__kindof NSURLSessionTask *)doGET:(NSString *)URL
                          parameters:(id)parameters
                             success:(OTWHttpRequestSuccess)success
                             failure:(PPHttpRequestFailed)failure;

+ (__kindof NSURLSessionTask *)doGET:(NSString *)URL
                          parameters:(id)parameters
                       responseCache:(PPHttpRequestCache)responseCache
                             success:(OTWHttpRequestSuccess)success
                             failure:(PPHttpRequestFailed)failure;

+ (__kindof NSURLSessionTask *)doPOST:(NSString *)URL
                           parameters:(id)parameters
                              success:(OTWHttpRequestSuccess)success
                              failure:(PPHttpRequestFailed)failure;

+ (__kindof NSURLSessionTask *)doPOST:(NSString *)URL
                           parameters:(id)parameters
                        responseCache:(PPHttpRequestCache)responseCache
                              success:(OTWHttpRequestSuccess)success
                              failure:(PPHttpRequestFailed)failure;

@end
