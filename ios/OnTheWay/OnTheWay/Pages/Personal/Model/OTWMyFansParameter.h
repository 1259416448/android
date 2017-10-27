//
//  OTWMyFansParameter.h
//  OnTheWay
//
//  Created by apple on 2017/10/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWMyFansParameter : NSObject

//当前页数
@property (nonatomic,assign) int number;
//每页大小
@property (nonatomic,assign)  int size;

@property (nonatomic,copy) NSString *currentTime;
@property (nonatomic,copy) NSString *type;


@end
