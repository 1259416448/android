//
//  OTWNetworkManager.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/8.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNetworkManager.h"

#ifdef DEBUG
#define kServerURL @"http://192.168.5.118:9100/"
#else 
#define kServerURL @""
#endif
@implementation OTWNetworkManager

+ (instancetype)sharedManager
{
    static OTWNetworkManager *networkManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[OTWNetworkManager alloc] init];
    });
    
    return networkManager;
}

#pragma mark - Private methods

+ (NSString *)configeURL:(NSString*)url
{
    if ([url containsString:@"http"]) { // iOS8+特有API
        return url;
    }
    
    NSString *hostUrl = [[NSString stringWithFormat:@"%@", kServerURL] stringByAppendingString:url];
    return hostUrl;
}


#pragma mark -

+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                           success:(PPHttpRequestSuccess)success
                           failure:(PPHttpRequestFailed)failure
{
    return [super GET:[self configeURL:URL] parameters:parameters success:success failure:failure];
}

+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                     responseCache:(PPHttpRequestCache)responseCache
                           success:(PPHttpRequestSuccess)success
                           failure:(PPHttpRequestFailed)failure
{
    return [super GET:URL parameters:parameters responseCache:responseCache success:success failure:failure];
}

+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                            success:(PPHttpRequestSuccess)success
                            failure:(PPHttpRequestFailed)failure
{
    return [super POST:URL parameters:parameters success:success failure:failure];
}

+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                      responseCache:(PPHttpRequestCache)responseCache
                            success:(PPHttpRequestSuccess)success
                            failure:(PPHttpRequestFailed)failure
{
    return [super POST:URL parameters:parameters responseCache:responseCache success:success failure:failure];
}

+ (__kindof NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                                      parameters:(id)parameters
                                            name:(NSString *)name
                                        filePath:(NSString *)filePath
                                        progress:(PPHttpProgress)progress
                                         success:(PPHttpRequestSuccess)success
                                         failure:(PPHttpRequestFailed)failure
{
    return [super uploadFileWithURL:URL parameters:parameters name:name filePath:filePath progress:progress success:success failure:failure];
}

+ (__kindof NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                                        parameters:(id)parameters
                                              name:(NSString *)name
                                            images:(NSArray<UIImage *> *)images
                                         fileNames:(NSArray<NSString *> *)fileNames
                                        imageScale:(CGFloat)imageScale
                                         imageType:(NSString *)imageType
                                          progress:(PPHttpProgress)progress
                                           success:(PPHttpRequestSuccess)success
                                           failure:(PPHttpRequestFailed)failure
{
    return [super uploadImagesWithURL:URL parameters:parameters name:name images:images fileNames:fileNames imageScale:imageScale imageType:imageType progress:progress success:success failure:failure];
}

+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(PPHttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(PPHttpRequestFailed)failure
{
    return [super downloadWithURL:URL fileDir:fileDir progress:progress success:success failure:failure];
}

@end
