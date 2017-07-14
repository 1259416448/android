//
//  OTWTabBarController.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWTabBarController.h"
#import "OTWCustomTabBar.h"
#import "OTWCustomTabBarItem.h"
#import "OTWUserModel.h"
#import "OTWLoginViewController.h"

static CGFloat otwCustomTabBarHeight = 49.0;

@interface OTWTabBarController () <OTWCustomTabBarDelegate,UITabBarControllerDelegate>

@property (nonatomic, strong) OTWCustomTabBar *customTabBar;
@property (nonatomic, strong) OTWTabBarConfig *config;

@end

@implementation OTWTabBarController

#pragma mark - Public Methods

+ (instancetype)createTabBarController:(tabBarBlock)block
{
    static OTWTabBarController *tabBar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBar = [[OTWTabBarController alloc] initWithBlock:block];
    });
    return tabBar;
}

+ (instancetype)defaultTabBarController
{
    return [OTWTabBarController createTabBarController:nil];
}

- (void)hiddenTabBarWithAnimation:(BOOL)isAnimation
{
    if (isAnimation) {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.customTabBar.alpha = 0;
        }];
    } else {
        
        self.customTabBar.alpha = 0;
    }
}

- (void)showTabBarWithAnimation:(BOOL)isAnimation
{
    if (isAnimation) {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.customTabBar.alpha = 1.0;
        }];
    } else {
        
        self.customTabBar.alpha = 1.0;
    }
}

#pragma mark - Private Methods

- (instancetype)initWithBlock:(tabBarBlock)block
{
    self = [super init];
    if (self) {
        OTWTabBarConfig *config = [[OTWTabBarConfig alloc] init];
        NSAssert(block, @"Param in the function, can not be nil");
        
        if (block) {
            _config = block(config);
        }
        
        NSAssert(_config.viewControllers, @"Param ‘viewController’ in the 'config', can not be nil");
        
        [self setupViewControllers];
        [self setupTabBar];
    }
    
    return self;
}

- (void)setupViewControllers
{
    if (_config.isNavigation) {
        NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:_config.viewControllers.count];
        for (UIViewController *vc in _config.viewControllers) {
            if (![vc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = [[UINavigationController alloc] init];
                [vcs addObject:nav];
            } else {
                [vcs addObject:vc];
            }
        }
        self.viewControllers = [vcs copy];
    } else {
        self.viewControllers = [_config.viewControllers copy];
    }
}

- (void)setupTabBar
{
    NSMutableArray *items = [NSMutableArray array];
    
    OTWTabBarItemType type;
    
    if ((_config.selectedImages.count > 0 || _config.normalImages.count > 0) && _config.titles.count > 0) {
        type = OTWTabBarItemTypeDefault;
    } else if ((_config.selectedImages.count > 0 || _config.normalImages.count > 0) && _config.titles.count <= 0) {
        
        type = OTWTabBarItemTypeImage;
    } else if ((_config.selectedImages.count <= 0 && _config.normalImages.count <= 0) && _config.titles.count > 0) {
        
        type = OTWTabBarItemTypeText;
    } else {
        
        type = OTWTabBarItemTypeDefault;
    }
    
    for (int i = 0; i < _config.viewControllers.count; i++) {
        OTWCustomTabBarItem *item = [[OTWCustomTabBarItem alloc] init];
        
        // 对中间按钮特殊处理
        if (i == 2) {
            item.type = OTWTabBarItemTypeImageFlow;
        } else {
            item.type = type;
        }
        
        if (i == 0) {
            
            item.icon = _config.selectedImages[i];
            if (_config.titles.count > 0) {
                item.titleColor = _config.selectedColor;
            }
        } else {
            
            item.icon = _config.normalImages[i];
            if (_config.titles.count > 0) {
                
                item.titleColor = _config.normalColor;
            }
        }
        
        if (i < _config.titles.count) {
            
            item.title = _config.titles[i];
        }
        
        [items addObject:item];
        item.tag = i;
    }
    
    // 隐藏掉系统的tabBar
    self.tabBar.hidden = YES;
    self.customTabBar.items = [items copy];
    self.customTabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - otwCustomTabBarHeight, CGRectGetWidth(self.view.frame), otwCustomTabBarHeight);
    [self.view addSubview:self.customTabBar];
}

#pragma mark - Getter & Setter

- (OTWCustomTabBar*)customTabBar
{
    if (!_customTabBar) {
        _customTabBar = [[OTWCustomTabBar alloc] init];
        _customTabBar.delegate = self;
    }
    
    return _customTabBar;
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedIndex = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - didSelectedItemByIndex

-(void)didSelectedItemByIndex:(NSUInteger)selectedIndex
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    for (UIView *view in self.customTabBar.subviews) {
        if ([view isKindOfClass:[OTWCustomTabBarItem class]]) {
            [items addObject:view];
        }
    }
    OTWCustomTabBarItem *item = (OTWCustomTabBarItem*)items[selectedIndex];
    if(item){
        [self tabBar:[self customTabBar] didSelectItem:item atIndex:selectedIndex];
    }
}


#pragma mark - OTWCustomTabBarDelegate

- (void)tabBar:(OTWCustomTabBar *)tab didSelectItem:(OTWCustomTabBarItem *)item atIndex:(NSInteger)index
{
    DLog(@"view:%@",tab);
    if(index == 4){
        if([[OTWLaunchManager sharedManager] showLoginViewWithController:self completion:^{
             [[NSNotificationCenter defaultCenter] postNotificationName:@"personalViewController" object:self];
        }]){
            return ;
        };
    }
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    for (UIView *view in tab.subviews) {
        if ([view isKindOfClass:[OTWCustomTabBarItem class]]) {
            [items addObject:view];
        }
    }
    
    for (int i = 0; i < items.count; i++) {
        UIView *view = items[i];
        if ([view isKindOfClass:[OTWCustomTabBarItem class]]) {
            OTWCustomTabBarItem *item = (OTWCustomTabBarItem*)view;
            item.icon = self.config.normalImages[i];
            if (self.config.titles.count > 0) {
                
                item.titleColor = _config.normalColor;
            }
        }
    }
    
    item.icon = self.config.selectedImages[index];
    
    if (self.config.titles.count > 0) {
        
        item.titleColor = self.config.selectedColor;
    }
    
    self.selectedIndex = index;
}

// 屏幕旋转时调整tabbar
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.customTabBar.frame = CGRectMake(0, size.height - otwCustomTabBarHeight, size.width, otwCustomTabBarHeight);
}

- (BOOL)shouldAutorotate
{
    return self.isAutoRotation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.isAutoRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end

@implementation OTWTabBarConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isNavigation = YES;
        _normalColor = [UIColor grayColor];
        _selectedColor = [UIColor redColor];
    }
    
    return self;
}

@end
