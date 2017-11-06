//
//  QiniuUploadService.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>
#import "QiniuUploadHelper.h"
#import "OTWDocument.h"

typedef void(^requestCompletionBlock)(id result, NSError *error);

@interface QiniuUploadService : NSObject

/**
 * 上传图片
 * @param image 需要上传的image
 * @param progress 上传进度block
 * @param success 成功block
 * @param failure 失败block
 */
+ (void)uploadImage:(UIImage*)image progress:(QNUpProgressHandler)progress success:(void(^)(OTWDocument *document))success failure:(void(^)())failure;


//上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray*)imageArray progress:(void(^)(CGFloat))progress success:(void(^)(NSArray<OTWDocument *> *documents))success failure:(void(^)())failure;

//获取上传token
+ (void) getToken:(requestCompletionBlock)block;

@end
