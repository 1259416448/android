//
//  OTWBusinessARAnnotation.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "ArvixARAnnotation.h"
#import "OTWBusinessModel.h"

@interface OTWBusinessARAnnotation : ArvixARAnnotation

@property (nonatomic,strong) OTWBusinessModel *arShop;

- (instancetype)initWithIdentifier:(NSString*)identifier arShop:(OTWBusinessModel*)arShop location:(CLLocation*)location;

@end
