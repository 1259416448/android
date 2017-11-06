//
//  QiniuUploadService.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "QiniuUploadService.h"
#import <MJExtension.h>

@implementation QiniuUploadService

static NSString* getTokenUrl = @"/api/v1/qiniu/upToken";

#pragma mark - 单张图片上传

+ (void)uploadImage:(UIImage*)image progress:(QNUpProgressHandler)progress success:(void(^)(OTWDocument *document))success failure:(void(^)())failure
{
    [QiniuUploadService getToken:^(id result,NSError *error){
        if(result){
            if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
                [QiniuUploadService uploadImage:image token:result[@"body"][@"uptoken"] progress:progress success:success failure:failure];
            }else{
                DLog("服务端请求token失败");
                if(failure){
                    failure();
                }
            }
        }else{
            DLog(@"获取上传token失败！！！");
            if(failure){
                failure();
            }
        }
    }];
}

#pragma mark - 多张图片上传

+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray<OTWDocument *> *documents))success failure:(void (^)())failure
{
    //获取上传token
    [QiniuUploadService getToken:^(id result,NSError *error){
        if(result){
            if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
                NSString *token = result[@"body"][@"uptoken"];
                NSMutableArray *array = [[NSMutableArray alloc] init];
                __block CGFloat totalProgress = 0.0f;
                __block CGFloat partProgress = 1.0f / [imageArray count];
                __block NSUInteger currentIndex = 0;
                
                QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
                __weak typeof(uploadHelper) weakHelper = uploadHelper;
                uploadHelper.singleFailureBlock = ^() {
                    if(failure){
                        failure();
                    }
                    return;
                };
                uploadHelper.singleSuccessBlock  = ^(OTWDocument *document) {
                    [array addObject:document];
                    totalProgress += partProgress;
                    progress(totalProgress);
                    currentIndex++;
                    if ([array count] == [imageArray count]) {
                        success([array copy]);
                        return;
                    }
                    else {
                        if (currentIndex<imageArray.count) {
                            [QiniuUploadService uploadImage:imageArray[currentIndex] token:token progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
                        }
                    }
                };
                [QiniuUploadService uploadImage:imageArray[0] token:token progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
            }else{
                DLog("服务端请求token失败");
                if(failure){
                    failure();
                }
            }
        }else{
            DLog(@"获取上传token失败！！！");
            if(failure){
                failure();
            }
        }
    }];
}

#pragma mark - 上传公共方法

+ (void) uploadImage:(UIImage*)image token:(NSString *)token progress:(QNUpProgressHandler)progress success:(void(^)(OTWDocument *document))success failure:(void(^)())failure
{
    //                NSData *data = UIImagePNGRepresentation(image);
    //                if(data == nil){
    //                    data = UIImageJPEGRepresentation(image, 1);
    //                }
    NSData *data = UIImageJPEGRepresentation(image, 0.6);
    if(data == nil){
        DLog(@"图片数据获取失败");
        if(failure){
            failure();
        }
    }else{
        QNUploadOption *option = [[QNUploadOption alloc] initWithProgressHandler:progress];
        QNUploadManager *upManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        [upManager putData:data key:[QiniuUploadService getDocumentKey] token:token complete:^(QNResponseInfo *info,NSString *key,NSDictionary *resp){
            if(info.statusCode == 200 && resp){
                DLog(@"图片上传成功信息 %@",resp);
                OTWDocument *document = [[OTWDocument alloc] init];
                document.fileSize = [resp[@"size"] floatValue];
                document.fileType = resp[@"type"];
                document.fileUrl = resp[@"key"];
                document.name = resp[@"key"];
                document.w = [resp[@"w"] intValue];
                document.h = [resp[@"h"] intValue];
                if(success){
                    success(document);
                }
            }else{
                DLog(@"图片上传失败");
                if(failure){
                    failure();
                }
            }
        } option:option];
    }
}

#pragma mark - 获取token
+ (void) getToken:(requestCompletionBlock)block
{
    [OTWNetworkManager doGET:getTokenUrl parameters:nil success:^(id responseObject){
        if(block){
            block(responseObject,nil);
        }
    }failure:^(NSError *error){
        if(block){
            block(nil,error);
        }
    }];
}

+ (NSString *) getDocumentKey
{
    return [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
