//
//  GCTokenModel.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/9.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCTokenModel : NSObject <NSCoding>

@property(nonatomic,copy)NSString *xAuthToken;
@property(nonatomic,copy)NSString *rememberMe;
@property(nonatomic,copy)NSNumber *rememberMeTime;

@end
