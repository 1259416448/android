//
//  OTWCustomTabBarItem.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/11.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTWCustomTabBarItemDelegate;

typedef enum : NSUInteger {
    OTWTabBarItemTypeDefault,  // 默认显示文字和图片
    OTWTabBarItemTypeImage,    // 图片显示
    OTWTabBarItemTypeText,     // 文字显示
    OTWTabBarItemTypeImageFlow, // 图片悬浮在tabBar顶端
    OTWTabBarItemTypeHidden, //隐藏的
} OTWTabBarItemType;

@interface OTWCustomTabBarItem : UIView

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) OTWTabBarItemType type;

@property (nonatomic, assign) id<OTWCustomTabBarItemDelegate> delegate;

@end

@protocol OTWCustomTabBarItemDelegate <NSObject>

- (void)tabBarItem:(OTWCustomTabBarItem*)item didSelectIndex:(NSInteger)index;

@end
