//
//  OTWCustomTabBar.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/11.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTWCustomTabBarItem;
@protocol OTWCustomTabBarDelegate;

@interface OTWCustomTabBar : UIView

@property (nonatomic, strong) NSArray<OTWCustomTabBarItem *> *items;
@property (nonatomic, assign) id<OTWCustomTabBarDelegate> delegate;

@end

@protocol OTWCustomTabBarDelegate <NSObject>

- (void)tabBar:(OTWCustomTabBar*)tab didSelectItem:(OTWCustomTabBarItem*)item atIndex:(NSInteger)index;

@end
