//
//  QiniuUploadHelper.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWDocument.h"

@interface QiniuUploadHelper : NSObject

@property (copy, nonatomic) void (^singleSuccessBlock)(OTWDocument *document);
@property (copy, nonatomic)  void (^singleFailureBlock)();

+ (instancetype)sharedUploadHelper;

@end
