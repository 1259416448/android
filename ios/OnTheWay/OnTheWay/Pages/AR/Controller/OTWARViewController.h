//
//  OTWARViewController.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCYARViewController.h"

/**
 * AR视图特殊，所以需要一个AR视图管理类， 所有子view中应该添加到MCYARViewController的view中。 MCYARViewController中通过设置属性，来显示对应的AnnotationView和雷达。
 * 其余需要自定义的View， 通过[MCYARViewController.view insert]添加。 
 *
 * 点击事件处理： 在管理视图中通过present跳转到ARController，所有自定义的点击事件，必须先执行ARController.dismiss 然后在push到相应Controller
 * add by 马春燕 如有不清楚，请及时联系。
 */
@interface OTWARViewController : OTWBaseViewController

@property (nonatomic, strong) MCYARViewController *arViewController;

- (void)showARViewController;

@end
