//
//  OTWActiveTypeTableViewCell.h
//  OnTheWay
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTWBusinessActivityModel.h"

@interface OTWActiveTypeTableViewCell : UITableViewCell

@property (nonatomic, strong) OTWBusinessActivityModel * model;


@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * activeImage;


@end
