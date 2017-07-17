//
//  OTWCommentFrame.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/16.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWCommentModel.h"


@interface OTWCommentFrame : NSObject

@property (nonatomic,strong) OTWCommentModel *commentModel;

/**
 * 行高
 */
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic,assign) CGFloat contentH;

-(void) setCommentModel:(OTWCommentModel *)commentModel;

@end
