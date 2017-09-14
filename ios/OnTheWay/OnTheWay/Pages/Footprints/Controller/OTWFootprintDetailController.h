//
//  OTWFootprintDetailController.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OTWCommentModel.h"
#import "OTWFootprintDetailFrame.h"
#import "OTWCommentFrame.h"

#import <MJRefresh.h>

@interface  OTWFootprintDetailController : OTWBaseViewController

@property (nonatomic,strong) UITableView *tableView;
//详情
@property (nonatomic,strong) OTWFootprintDetailFrame *detailFrame;

//评论数据
@property (nonatomic,strong) NSMutableArray<OTWCommentFrame *> *commentFrameArray;

@property (nonatomic,strong) UIView *commentBGView;

//第一次进入页面时，加载提示View
@property (nonatomic,strong) UIView *firstLoadingView;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) UILabel *errorTipsLabel;

@property (nonatomic,strong) UILabel *commentSunLabel;

/**
 * 传递数据，或者id等 想获取足迹详情，传入对应的id或者Model即可
 */
@property (nonatomic, strong) NSString *fid;

- (void) refreshTableViewHeader;

- (UIView *) notFundCommentBGView;
@end
