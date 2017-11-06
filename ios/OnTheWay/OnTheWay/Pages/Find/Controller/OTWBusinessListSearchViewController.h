//
//  OTWBusinessListSearchViewController.h
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/10/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTWBusinessListSearchViewControllerDelegate <NSObject>

- (void)searchWithStr:(NSString *)searchText;

@end

@interface OTWBusinessListSearchViewController : OTWBaseViewController

@property (nonatomic, weak) id <OTWBusinessListSearchViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isFromAR;

@property (nonatomic, assign) BOOL isFromFind;


@end
