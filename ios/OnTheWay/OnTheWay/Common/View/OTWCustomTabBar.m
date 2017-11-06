//
//  OTWCustomTabBar.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/11.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWCustomTabBar.h"
#import "OTWCustomTabBarItem.h"

@interface OTWCustomTabBar () <OTWCustomTabBarItemDelegate>

@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *topLine;

@end

@implementation OTWCustomTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Getter & Setter

- (UIView*)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:_topLine];
    }
    
    return _topLine;
}

- (UIVisualEffectView*)effectView
{
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.alpha = 1.0;
        [self addSubview:_effectView];
    }
    
    return _effectView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.effectView.frame = self.bounds;
    
    self.topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
    
    CGFloat w = 60;
    UIView *iconImageBorderView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - w)/2, -11, w, w)];
    iconImageBorderView.backgroundColor = [UIColor whiteColor];
    iconImageBorderView.layer.cornerRadius = 30;
    iconImageBorderView.layer.shadowColor = [UIColor blackColor].CGColor;
    iconImageBorderView.layer.shadowOpacity = 0.06;
    iconImageBorderView.layer.shadowOffset = CGSizeMake(0, -1);
    [self addSubview:iconImageBorderView];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.06;
    self.layer.shadowOffset = CGSizeMake(0, -1);
    UIView *tabCoverView = [[UIView alloc] initWithFrame:self.bounds];
    tabCoverView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tabCoverView];
    [self setupItems];
}

- (void)setupItems {
    
    CGFloat width = CGRectGetWidth(self.frame)/self.items.count;
    CGFloat height = CGRectGetHeight(self.frame);
    
    for (int i = 0; i < self.items.count; i++) {
        
        OTWCustomTabBarItem *item = [self.items objectAtIndex:i];
        item.frame = CGRectMake(i*width, 0, width, height);
        [self addSubview:item];
        item.delegate = self;
    }
}

#pragma mark - OTWCustomTabBarItemDelegate

- (void)tabBarItem:(OTWCustomTabBarItem *)item didSelectIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItem:atIndex:)]) {
        [self.delegate tabBar:self didSelectItem:item atIndex:index];
    }
}

@end
