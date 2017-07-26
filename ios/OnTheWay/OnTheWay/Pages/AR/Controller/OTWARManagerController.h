//
//  OTWARManagerController.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/26.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"

/**
 * AR视图特殊，所以需要一个AR视图管理类， 所有子view中应该添加到MCYARViewController的view中。 通过设置MCYARViewController属性，来显示对应的AnnotationView和雷达。
 * 其余需要自定义的View， 通过[MCYARViewController.view insert]添加。
 *
 * 点击事件处理： 在ManagerC中通过presentViewController跳转到MCYARController。因此所有自定义的点击事件，必须先执行ARController.dismiss，然后在push到相应Controller
 * add by 马春燕 如有不清楚，请及时联系。
 */
@interface OTWARManagerController : OTWBaseViewController

@end
