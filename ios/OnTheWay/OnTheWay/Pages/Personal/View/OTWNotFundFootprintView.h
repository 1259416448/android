//
//  OTWNotFundFootprintView.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickBlock)();
@interface OTWNotFundFootprintView : UIView

@property (nonatomic,assign) BOOL ifMy;

@property (nonatomic,copy) ClickBlock block;

+ (instancetype) initWithIfMy:(Boolean) ifMy;

@end
