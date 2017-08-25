//
//  OTWFootprintsChangeAddressCellTableViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintsChangeAddressCellTableViewCell.h"
#import "OTWFootprintsChangeAddressModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface OTWFootprintsChangeAddressCellTableViewCell()

@property (nonatomic,strong) UILabel  *footprintChangeAddressName;
@property (nonatomic,strong) UILabel  *footprintChangeAddress;
@property (nonatomic,strong) UIView *topCell;
@property (nonatomic,strong) UIImageView *checkImgView;

@end

@implementation OTWFootprintsChangeAddressCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
#pragma mark 初始化视图
-(void)initSubView{
    //名称
    [self.contentView addSubview:self.footprintChangeAddressName];
    //地址
    
    [self.contentView addSubview:self.footprintChangeAddress];
    //头部线条
    
    [self.contentView addSubview:self.topCell];
    
    //check框的图标
    [self.contentView addSubview:self.checkImgView];
}
-(void) setData:(OTWFootprintChangeAddressArrayModel *) data{
    
    CGFloat w = SCREEN_WIDTH - 15 - 15;
    
    if(data.isClick){
        w -= 30;
    }
    
    self.footprintChangeAddressName.frame=CGRectMake(15, 15, w, 20);
    self.footprintChangeAddressName.text=data.name;
    self.footprintChangeAddressName.font=[UIFont systemFontOfSize:16];
    
    self.footprintChangeAddress.frame=CGRectMake(15, 40, w, 20);
    self.footprintChangeAddress.text=data.address;
    self.footprintChangeAddress.textColor=[UIColor color_999999];
    self.footprintChangeAddress.font=[UIFont systemFontOfSize:14];
    
    self.topCell.frame=CGRectMake(15, 0, SCREEN_WIDTH-15, 0.5);
    self.topCell.backgroundColor=[UIColor color_dedede];
    
    if(data.isClick){
        self.footprintChangeAddressName.textColor=[UIColor color_e50834];
        self.checkImgView.hidden = NO;
    }else{
        self.footprintChangeAddressName.textColor=[UIColor color_242424];
        self.checkImgView.hidden = YES;
    }
    
}

#pragma mark - Setter Getter

- (UILabel *) footprintChangeAddressName
{
    if(!_footprintChangeAddressName){
        _footprintChangeAddressName=[[UILabel alloc]init];
    }
    return _footprintChangeAddressName;
}

- (UILabel *) footprintChangeAddress
{
    if(!_footprintChangeAddress){
        _footprintChangeAddress=[[UILabel alloc]init];
    }
    return _footprintChangeAddress;
}

- (UIView *) topCell
{
    if(!_topCell){
        _topCell=[[UIView alloc]init];
    }
    return _topCell;
}

- (UIImageView*) checkImgView
{
    if(!_checkImgView){
        _checkImgView=[[UIImageView alloc]init];
        _checkImgView.image=[UIImage imageNamed:@"xuanze"];
        _checkImgView.frame=CGRectMake(SCREEN_WIDTH-15-13.35, 28, 13.35, 14.15);
        _checkImgView.hidden = YES;
    }
    return _checkImgView;
}

@end
