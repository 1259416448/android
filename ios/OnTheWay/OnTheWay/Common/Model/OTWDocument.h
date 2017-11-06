//
//  OTWDocument.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWDocument : NSObject

@property (nonatomic,assign) float fileSize;
@property (nonatomic,strong) NSString *fileType;
@property (nonatomic,assign) int w;
@property (nonatomic,assign) int h;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *fileUrl;

@end
