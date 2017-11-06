//
//  OTWActionContiollerHelper.h
//  OnTheWay
//
//  Created by apple on 2017/10/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWActionContiollerHelper : NSObject

+ (instancetype)shared;

- (void)showInViewController:(UIViewController *)vc;

@end
