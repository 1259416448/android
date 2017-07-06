//
//  OTWBaseViewController.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTWCustomNavigationBar;
@interface OTWBaseViewController : UIViewController

@property (nonatomic,strong,readonly) OTWCustomNavigationBar *customNavigationBar;

@property (nonatomic,assign,readonly) CGFloat navigationHeight;

@property (nonatomic,copy) NSString *rightNavigationTitle;
@property (nonatomic,copy) NSString *leftNavigationTitle;


@property (nonatomic,strong) UIImage *rightNavigationImage;
@property (nonatomic,strong) UIImage *leftNavigationImage;

@property (nonatomic,strong) UIColor *navigationColor;
@property (nonatomic,strong) UIImage *navigationImage;

@property (nonatomic,assign) BOOL hiddenCustomNavigation;

- (void)leftNavigaionButtonClicked;
- (void)rightNavigaionButtonClicked;

- (void)setCustomNavigationLeftView:(UIView*)view;
- (void)setCustomNavigationRightView:(UIView*)view;
- (void)setCustomNavigationCenterView:(UIView*)view;

@end
