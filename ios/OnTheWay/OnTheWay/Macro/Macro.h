//
//  Macro.h
//  ZuHuYun
//
//  Created by 郑红 on 24/05/2017.
//  Copyright © 2017 ChangHong. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#pragma mark 常用frame

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define GLOBAL_PADDING 15.0

#define kPictureW 750.0 //设计图纸的宽
#define kPictureH 1334.0 //设计图纸的高
#define kDistanceHeightRatio(r) r*SCREEN_WIDTH/kPictureH
#define kDistanceWidthRatio(r) r*SCREEN_WIDTH/kPictureW

#pragma mark color
#define RGB(r,g,b) RGBA(r,g,b,1)
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#pragma mark 日志
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#pragma mark GCD

#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

//GCD - 一次性执行
#define DISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//GCD - 在Main线程上运行
#define GCDMain(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//GCD - 开启异步线程
#define GCDGlobal(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);


#pragma mark path

//获取temp
#define kPathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#pragma mark showMessage

#define SVShowSuccess(msg) [SVProgressHUD showSuccessWithStatus:msg];
#define SVShowError(error) [SVProgressHUD showErrorWithStatus:error];
#define SVShowErrorSubError(error,suberror) [SVProgressHUD showErrorWithStatus:error substatus:suberror];
#define SVShowStatus(status) [SVProgressHUD showWithStatus:status];



#endif /* Macro_h */
