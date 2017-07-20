//
//  OTWNewsCommentTableCell.h
//  OnTheWay
//
//  Created by UI002 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTWNewsCommentModel.h"

@interface OTWNewsCommentTableCell : UITableViewCell

#pragma mark 评论对象
@property (nonatomic,strong) OTWNewsCommentModel *commentModel;

#pragma mark 单元格高度
@property (assign,nonatomic) CGFloat height;

@end
