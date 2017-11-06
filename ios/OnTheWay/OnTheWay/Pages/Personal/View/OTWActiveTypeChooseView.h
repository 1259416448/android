//
//  OTWActiveTypeChooseView.h
//  OnTheWay
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTWBusinessActivityModel.h"
#import "OTWActiveTypeChooseView.h"

@protocol OTWActiveTypeChooseViewDelegate <NSObject>

- (void)selectedModel:(OTWBusinessActivityModel *)model;

@end

@interface OTWActiveTypeChooseView : UIView

@property (nonatomic, strong) NSArray * titleArr;

@property (nonatomic, strong) NSArray * imageArr;

@property (nonatomic, weak) id <OTWActiveTypeChooseViewDelegate> delegate;


@end
