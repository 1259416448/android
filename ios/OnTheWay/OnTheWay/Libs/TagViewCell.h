//
//  TagViewCell.h
//  SQButtonTagView
//
//  Created by yangsq on 2017/9/26.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagViewCellDelegate <NSObject>

- (void)selectedAtIndex:(NSInteger)index;

@end

@interface TagViewCell : UITableViewCell

@property (nonatomic, weak) id <TagViewCellDelegate> delegate;

- (void)setTextArray:(NSArray *)textArray row:(NSInteger)row;

+ (CGFloat)cellHeightTextArray:(NSArray *)textArray Row:(NSInteger)row;
@end
