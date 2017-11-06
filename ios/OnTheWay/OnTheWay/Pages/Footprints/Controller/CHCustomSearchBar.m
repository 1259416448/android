//
//  CHCustomSearchBar.m
//  OnTheWay
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//自定义搜索框里textfieid的高度
//

#import "CHCustomSearchBar.h"

@implementation CHCustomSearchBar

- (void)layoutSubviews {
    [super layoutSubviews];
    for(UIView *view in self.subviews)
    {
        for(UITextField *textfield in view.subviews)
        {
            if ([textfield isKindOfClass:[UITextField class]]) {
                textfield.frame = CGRectMake(_textFieldInset.left,_textFieldInset.top,self.bounds.size.width-_textFieldInset.left-_textFieldInset.right,self.bounds.size.height-_textFieldInset.top-_textFieldInset.bottom);
            }
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
