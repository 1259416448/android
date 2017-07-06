//
//  OTWRootViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWRootViewController.h"
#import "OTWFindViewController.h"
#import "OTWFootprintsViewController.h"
#import "OTWARViewController.h"
#import "OTWNewsViewController.h"
#import "OTWPersonalViewController.h"

@interface OTWRootViewController ()

@end

@implementation OTWRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary * titleAttri = @{
                                  NSFontAttributeName: [UIFont systemFontOfSize:18],
                                  NSForegroundColorAttributeName:[UIColor whiteColor]
                                  };
    UIImage * bgImage = [UIImage imageWithColor:RGB(34, 178, 231)];
    
    OTWFindViewController *findVC = [[OTWFindViewController alloc] init];
    
    UINavigationController * findNav = [[UINavigationController alloc] initWithRootViewController:findVC];
    findNav.tabBarItem.image = [UIImage imageNamed:@"shouye"];
    findNav.tabBarItem.selectedImage = [UIImage imageNamed:@"shouye_xuan"];
    findNav.tabBarItem.title = @"发现";
    findNav.tabBarItem.imageInsets = UIEdgeInsetsZero;
    [findNav.navigationBar setTitleTextAttributes:titleAttri];
    [findNav.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    OTWFootprintsViewController *footprintsVC = [[OTWFootprintsViewController alloc] init];
    
    UINavigationController * footprintsNav = [[UINavigationController alloc] initWithRootViewController:footprintsVC];
    footprintsNav.tabBarItem.image = [UIImage imageNamed:@"tab_yingyong"];
    footprintsNav.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_yingyong_xuan"];
    footprintsNav.tabBarItem.title = @"足迹";
    [footprintsNav.navigationBar setTitleTextAttributes:titleAttri];
    footprintsNav.navigationBar.translucent = YES;
    [footprintsNav.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    OTWARViewController * arVC = [[OTWARViewController alloc] init];
    
    UINavigationController * arNav = [[UINavigationController alloc] initWithRootViewController:arVC];
    arNav.tabBarItem.image = [UIImage imageNamed:@"tab_yingyong"];
    arNav.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_yingyong_xuan"];
    arNav.tabBarItem.title = @"AR";
    [arNav.navigationBar setTitleTextAttributes:titleAttri];
    arNav.navigationBar.translucent = YES;
    [arNav.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    OTWFootprintsViewController *newsVC = [[OTWFootprintsViewController alloc] init];
    
    UINavigationController * newsNav = [[UINavigationController alloc] initWithRootViewController:newsVC];
    newsNav.tabBarItem.image = [UIImage imageNamed:@"tab_yingyong"];
    newsNav.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_yingyong_xuan"];
    newsNav.tabBarItem.title = @"消息";
    [newsNav.navigationBar setTitleTextAttributes:titleAttri];
    newsNav.navigationBar.translucent = YES;
    [newsNav.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    OTWPersonalViewController *personalVC = [[OTWPersonalViewController alloc] init];
    
    UINavigationController * personalNav = [[UINavigationController alloc] initWithRootViewController:personalVC];
    personalNav.tabBarItem.image = [UIImage imageNamed:@"tab_yingyong"];
    personalNav.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_yingyong_xuan"];
    personalNav.tabBarItem.title = @"我的";
    [personalNav.navigationBar setTitleTextAttributes:titleAttri];
    personalNav.navigationBar.translucent = YES;
    [personalNav.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    self.viewControllers = @[findNav, footprintsNav, arNav, newsNav, personalVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
