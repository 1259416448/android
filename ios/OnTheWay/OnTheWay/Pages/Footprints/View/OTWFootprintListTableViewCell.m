//
//  OTWFootprintListTableViewCell.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintListTableViewCell.h"
#import "OTWFootprintListFrame.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OTWFootprintListModel.h"


#define OTWFootprintNameFont [UIFont systemFontOfSize:15]
#define OTWFootprintTextFont [UIFont systemFontOfSize:16]
#define OTWFootprintFooterFont [UIFont systemFontOfSize:11]

@interface OTWFootprintListTableViewCell()

@property (nonatomic,strong) UIView *footprintBGView;

//用户头像
@property (nonatomic,strong) UIImageView *userheadImgView;

//主题图片
@property (nonatomic,strong) UIImageView *footprintPhotoImgView;

//用户昵称
@property (nonatomic,strong) UILabel *userNicknameLabel;

//足迹内容
@property (nonatomic,strong) UILabel *footprintContentLabel;

//足迹地址
@property (nonatomic,strong) UILabel *footprintAddressLabel;

//足迹发布时间
@property (nonatomic,strong) UILabel *dateCreatedLabel;

//足迹地址图标
@property (nonatomic,strong) UIImageView *footprintAddressImageView;

//足迹时间图标
@property (nonatomic,strong) UIImageView *dateCreatedImageView;

@property (nonatomic,strong) UIView *userheadImgBGView;

@end

@implementation OTWFootprintListTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView footprintListFrame:(OTWFootprintListFrame *) frame
{
    static NSString *identifier = @"OTWFootprintListTableViewCellStatus";
    OTWFootprintListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[OTWFootprintListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFootprintListFrame:frame];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.footprintBGView];
        [self.footprintBGView addSubview:self.userheadImgBGView];
        [self.footprintBGView addSubview:self.userNicknameLabel];
        [self.footprintBGView addSubview:self.footprintContentLabel];
        [self.footprintBGView addSubview:self.footprintPhotoImgView];
        [self.footprintBGView addSubview:self.footprintAddressImageView];
        [self.footprintBGView addSubview:self.footprintAddressLabel];
        [self.footprintBGView addSubview:self.dateCreatedImageView];
        [self.footprintBGView addSubview:self.dateCreatedLabel];
    }
    return self;
}

- (void)setFootprintListFrame:(OTWFootprintListFrame *) frame
{
    _footprintListFrame = frame;
    [self settingData];
    [self setttingFrame];
}

/**
 * 设置数据
 */
- (void)settingData
{
    OTWFootprintListModel *model = self.footprintListFrame.footprint;
    [self.userheadImgView setImageWithURL:[NSURL URLWithString:model.userHeadImg]];
    [self.userNicknameLabel setText:model.userNickname];
    [self.footprintContentLabel setText:model.footprintContent];
    [self.footprintAddressLabel setText:model.footprintAddress];
    [self.dateCreatedLabel setText:model.dateCreatedStr];
    if(model.footprintPhoto && ![model.footprintPhoto isEqualToString:@""]){
        DLog(@"_footprint.footprintPhoto:%@",model.footprintPhoto);
        [self.footprintPhotoImgView setImageWithURL:[NSURL URLWithString:[model.footprintPhoto stringByAppendingString:@"?imageView2/1/w/160/h/160"]]];
    }else{
        self.footprintPhotoImgView.hidden = YES;
    }
}

/**
 * 设置frame
 */
- (void)setttingFrame
{
    self.footprintBGView.frame = self.footprintListFrame.footprintBGF;
    self.footprintBGView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_footprintBGView.bounds].CGPath;
    self.userheadImgBGView.frame = self.footprintListFrame.userHeadImgF;
    self.userheadImgBGView.layer.cornerRadius = self.userheadImgBGView.Witdh/2.0;
    struct CGPath *path = CGPathCreateMutable();
    CGPathAddArc(path, nil, 17 , 17, 17, 0, M_PI*2, true);
    self.userheadImgBGView.layer.shadowPath = path;
    self.userNicknameLabel.frame = self.footprintListFrame.userNicknameF;
    self.footprintContentLabel.frame = self.footprintListFrame.footprintContentF;
    self.footprintPhotoImgView.frame = self.footprintListFrame.footprintPhotoImgF;
    self.footprintAddressImageView.frame = self.footprintListFrame.footprintAddressImageF;
    self.footprintAddressLabel.frame = self.footprintListFrame.footprintAddressF;
    self.dateCreatedImageView.frame = self.footprintListFrame.dataCreatedImageF;
    self.dateCreatedLabel.frame = self.footprintListFrame.dataCreatedF;
}

#pragma mark - Setter Getter

-(UIImageView *)userheadImgView{
    if(!_userheadImgView){
        _userheadImgView = [[UIImageView alloc] init];
        _userheadImgView.frame = CGRectMake(2, 2, 30, 30);
//        _userheadImgView.layer.borderColor = [UIColor whiteColor].CGColor;
//        _userheadImgView.layer.borderWidth = 2;
        _userheadImgView.layer.cornerRadius = self.userheadImgView.Witdh/2.0;
        _userheadImgView.layer.masksToBounds = YES;
    }
    return _userheadImgView;
}

-(UIImageView *)footprintPhotoImgView{
    if(!_footprintPhotoImgView){
        _footprintPhotoImgView = [[UIImageView alloc] init];
    }
    return _footprintPhotoImgView;
}
-(UILabel *)userNicknameLabel{
    if(!_userNicknameLabel){
        _userNicknameLabel = [[UILabel alloc] init];
        _userNicknameLabel.font = OTWFootprintNameFont;
        _userNicknameLabel.textColor = [UIColor color_757575];
    }
    return _userNicknameLabel;
}
-(UILabel *)footprintContentLabel{
    if(!_footprintContentLabel){
        _footprintContentLabel = [[UILabel alloc] init];
        _footprintContentLabel.font = OTWFootprintTextFont;
        _footprintContentLabel.textColor = [UIColor color_202020];
        _footprintContentLabel.numberOfLines = 0;
    }
    return _footprintContentLabel;
}
-(UILabel *)footprintAddressLabel{
    if(!_footprintAddressLabel){
        _footprintAddressLabel = [[UILabel alloc] init];
        _footprintAddressLabel.font = OTWFootprintFooterFont;
        _footprintAddressLabel.textColor = [UIColor color_979797];
    }
    return _footprintAddressLabel;
}
-(UILabel *)dateCreatedLabel{
    if(!_dateCreatedLabel){
        _dateCreatedLabel = [[UILabel alloc] init];
        _dateCreatedLabel.font = OTWFootprintFooterFont;
        _dateCreatedLabel.textColor = [UIColor color_979797];
    }
    return _dateCreatedLabel;
}

-(UIImageView *)footprintAddressImageView{
    if(!_footprintAddressImageView){
        _footprintAddressImageView = [[UIImageView alloc] init];
        UIImage *footprintAddressImage = [UIImage imageNamed:@"dinwgei_2"];
        [_footprintAddressImageView setImage:footprintAddressImage];
    }
    return _footprintAddressImageView;
}

-(UIImageView *)dateCreatedImageView{
    if(!_dateCreatedImageView){
        _dateCreatedImageView = [[UIImageView alloc] init];
        UIImage *dateCreatedImage = [UIImage imageNamed:@"shijian"];
        [_dateCreatedImageView setImage:dateCreatedImage];
    }
    return _dateCreatedImageView;
}

-(UIView *)footprintBGView{
    if(!_footprintBGView){
        _footprintBGView = [[UIView alloc] init];
        _footprintBGView.backgroundColor = [UIColor whiteColor];
        _footprintBGView.layer.shadowColor = [UIColor blackColor].CGColor;
        _footprintBGView.layer.shadowOffset = CGSizeMake(0, 0.5);
        _footprintBGView.layer.shadowOpacity = 0.1;
    }
    return _footprintBGView;
}

-(UIView*)userheadImgBGView{
    if(!_userheadImgBGView){
        _userheadImgBGView = [[UIView alloc] init];
        _userheadImgBGView.backgroundColor = [UIColor whiteColor];
        _userheadImgBGView.layer.shadowColor = [UIColor color_545454].CGColor;
        _userheadImgBGView.layer.shadowOffset = CGSizeMake(0, 1);
        _userheadImgBGView.layer.shadowOpacity = 0.3;
        [_userheadImgBGView addSubview:self.userheadImgView];
    }
    return _userheadImgBGView;
}

@end
