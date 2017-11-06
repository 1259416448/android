//
//  OTWMyFansModel.h
//  OnTheWay
//
//  Created by apple on 2017/10/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWMyFansModel : NSObject

@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSNumber *fansNum;

@property (nonatomic,copy) NSString *userNickname;
@property (nonatomic,copy) NSString *userHeadImg;

@end
