//
//  OTWPersonalFootprintFrame.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/1.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWFootprintListModel.h"

@interface OTWPersonalFootprintFrame : NSObject

@property (nonatomic,assign) CGRect contentLabelF;

@property (nonatomic,assign) CGRect textBGViewF;

@property (nonatomic,assign) CGRect addressImageViewF;

@property (nonatomic,assign) CGRect addressLabelF;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,assign) CGRect cellLineF;

@property (nonatomic,assign) BOOL hasPhoto;

@property (nonatomic,assign) BOOL hasRelease;

@property (nonatomic,strong) OTWFootprintListModel *footprintDetal;

//保存12日这类型数据，如果当前拥有多条数据 只有第一个有值
@property (nonatomic,strong) NSString *leftContent;

+ (instancetype) initWithFootprintDetail:(OTWFootprintListModel *)footprintDetail;

- (void) initData;

@end
