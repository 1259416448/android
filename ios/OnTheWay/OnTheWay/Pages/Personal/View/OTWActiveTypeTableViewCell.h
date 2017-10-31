//
//  OTWActiveTypeTableViewCell.h
//  OnTheWay
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTWActiveTypeTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * image;


@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * activeImage;


@end
