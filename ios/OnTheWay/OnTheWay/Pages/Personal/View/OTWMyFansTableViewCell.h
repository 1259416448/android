//
//  OTWMyFansTableViewCell.h
//  OnTheWay
//
//  Created by apple on 2017/10/26.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTWMyFansModel.h"


@interface OTWMyFansTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * headImageView;

@property (nonatomic, strong)UIImageView * personImg;

@property (nonatomic, strong)UIImageView * arrow;

@property (nonatomic, strong)UILabel * name;

@property (nonatomic, strong)UILabel * fansNum;

@property (nonatomic, strong)OTWMyFansModel * model;


@end
