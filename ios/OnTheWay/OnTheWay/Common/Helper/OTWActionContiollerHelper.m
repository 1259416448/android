//
//  OTWActionContiollerHelper.m
//  OnTheWay
//
//  Created by apple on 2017/10/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWActionContiollerHelper.h"

@interface OTWActionContiollerHelper ()

@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, strong) UIAlertController *actionSheet;

@end

@implementation OTWActionContiollerHelper

+ (instancetype)shared
{
    static OTWActionContiollerHelper *acHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        acHelper = [[OTWActionContiollerHelper alloc] init];
    });
    
    return acHelper;
}

- (void)showInViewController:(UIViewController *)vc
{
    if (nil == vc) return;
    self.vc = vc;
    [self.vc presentViewController:self.actionSheet animated:YES completion:nil];
}

- (UIAlertController*)actionSheet
{
    if (!_actionSheet) {
        
        _actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"稍后完善" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[OTWLaunchManager sharedManager] showSelectedControllerByIndex:OTWTabBarSelectedIndexPersonal];

            [self.vc dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"立即完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[OTWLaunchManager sharedManager] showCompleteViewController:self.vc];
            
        }];
        
        [_actionSheet addAction:action1];
        [_actionSheet addAction:action2];

    }
    
    return _actionSheet;
}

@end
