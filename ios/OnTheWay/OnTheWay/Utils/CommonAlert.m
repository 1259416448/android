//
//  CommonAlert.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "CommonAlert.h"

@implementation CommonAlert
{
    CallBack _confirmCb;
    CallBack _cancelCb;
}

static CommonAlert *_alert;

+(void)alertWithContent: (NSString *)content viewController: (UIViewController *)vc{
    [CommonAlert checkInstance];
    [_alert alertWithContent:content viewController:vc confirmString:@"确定" confirmBlock:nil cancelString:nil cancelBlock:nil];
}

+(void)alertWithContent:(NSString *)content viewController:(UIViewController *)vc confirmStr:(NSString *)confirmStr confirmCb:(CallBack)confirmCb cancelStr:(NSString *)cancelStr cancelCb:(CallBack)cancelCb{
    [CommonAlert checkInstance];
    [_alert alertWithContent:content viewController:vc confirmString:confirmStr confirmBlock:confirmCb cancelString:cancelStr cancelBlock:cancelCb];
}

+(void) alertWithContent: (NSString *)content viewController: (UIViewController *)vc confirmStr: (NSString *)confirmStr confirmCb: (CallBack)confirmCb{
    [CommonAlert checkInstance];
    [_alert alertWithContent:content viewController:vc confirmString:confirmStr confirmBlock:confirmCb cancelString:nil cancelBlock:nil];
}

+(void)alertWithCancel:(NSString *)msg viewController:(UIViewController *)vc {
    [CommonAlert checkInstance];
    [_alert alertWithContent:msg viewController:vc confirmString:@"确定" confirmBlock:nil cancelString:@"取消" cancelBlock:nil];
}

+(void)setTitle:(NSString *)title {
    [CommonAlert checkInstance];
    _alert.title = title;
}

+(void) checkInstance {
    if (_alert == nil) {
        _alert = [[CommonAlert alloc] init];
        _alert.title = @"温馨提示";
    }
}

-(void) alertWithContent: (NSString *) content viewController: (UIViewController *) vc confirmString: (NSString *) confirmString confirmBlock: (CallBack) confirmBlock cancelString: (NSString *) cancelString cancelBlock: (CallBack) cancelBlock {
    
    _confirmCb = confirmBlock;
    _cancelCb = cancelBlock;
    
    if (IOS8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.title message:content preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
            if (_confirmCb != nil) {
                _confirmCb();
            }
        }];
        [alertController addAction:confirmAction];
        
        if (cancelString != nil) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
                if (_cancelCb != nil) {
                    _cancelCb();
                }
            }];
            [alertController addAction:cancelAction];
        }
        
        [vc presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alertView;
        if (cancelString == nil) {
            alertView = [[UIAlertView alloc] initWithTitle:self.title message:content delegate:self cancelButtonTitle:confirmString otherButtonTitles:nil, nil];
        }
        else
        {
            alertView = [[UIAlertView alloc] initWithTitle:self.title message:content delegate:self cancelButtonTitle:cancelString otherButtonTitles: confirmString, nil];
        }
        
        _confirmCb = confirmBlock ? confirmBlock : nil;
        _cancelCb = cancelBlock ? cancelBlock : nil;
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && _cancelCb != nil) {
        _cancelCb();
    }else if (buttonIndex == 0 && _confirmCb != nil && _cancelCb == nil){
        _confirmCb();
    }
    else if (buttonIndex == 1 && _confirmCb != nil)
    {
        _confirmCb();
    }
}

@end
