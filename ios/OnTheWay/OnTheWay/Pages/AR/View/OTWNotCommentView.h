//
//  OTWNotCommentView.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/6.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTWNotCommentView : UIView

-(id) initWithTitleName:(NSString *)titleName;

/**
 * 隐藏默认缺省信息
 */
- (void) hiddenDefaultView:(BOOL)hidden;

@end
