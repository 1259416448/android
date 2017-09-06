//
//  OTWBusinessActivityIconView.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/4.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTWBusinessActivityIconView : UIView

//活动名称
@property (nonatomic,strong) NSString * _Nonnull name;

//活动背景色
@property (nonatomic,strong) UIColor * _Nonnull color;

+(instancetype _Nonnull ) initWithName:(NSString * _Nonnull)name color:( UIColor * _Nonnull ) color;

- (void) setName:(NSString *_Nonnull)name color:(UIColor *_Nonnull) color;

@end
