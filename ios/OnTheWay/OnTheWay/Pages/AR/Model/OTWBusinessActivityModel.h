//
//  OTWBusinessActivityModel.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/5.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWBusinessActivityModel : NSObject

//优惠名称
@property (nonatomic,strong) NSString *name;

//优惠图标颜色代码
@property (nonatomic,strong) NSString *colorStr;

//优惠图标名称
@property (nonatomic,strong) NSString *typeName;

//优惠信息Url
@property (nonatomic,strong) NSString *url;

@end
