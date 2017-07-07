//
//  OTWLoginViewController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWLoginViewController.h"

@interface OTWLoginViewController ()

@end

@implementation OTWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)buildUI
{
    self.hiddenCustomNavigation = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 300, 40)];
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
}

@end
