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

@interface OTWFootprintsChangeAddressCellTableViewCell(){
    UILabel  *footprintChangeAddressName;
    UILabel  *footprintChangeAddress;
    UIView *topCell;
    UIImageView *checkImgView;
}
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
    footprintChangeAddressName=[[UILabel alloc]init];
    [self.contentView addSubview:footprintChangeAddressName];
    //地址
    footprintChangeAddress=[[UILabel alloc]init];
    [self.contentView addSubview:footprintChangeAddress];
    //头部线条
    topCell=[[UIView alloc]init];
    [self.contentView addSubview:topCell];
    
    //check框的图标
    checkImgView=[[UIImageView alloc]init];
    [self.contentView addSubview:checkImgView];
}
-(void) setData:(OTWFootprintChangeAddressArrayModel *) data{
    footprintChangeAddressName.frame=CGRectMake(15, 15, SCREEN_WIDTH-30-15-15, 20);
    footprintChangeAddressName.text=data.name;
    footprintChangeAddressName.font=[UIFont systemFontOfSize:16];
    
    footprintChangeAddress.frame=CGRectMake(15, 40, SCREEN_WIDTH-30-15-15, 20);
    footprintChangeAddress.text=data.address;
    footprintChangeAddress.textColor=[UIColor color_999999];
    footprintChangeAddress.font=[UIFont systemFontOfSize:14];
    
    topCell.frame=CGRectMake(15, 0, SCREEN_WIDTH-15, 0.5);
    topCell.backgroundColor=[UIColor color_dedede];

    if(data.isClick){
          [self.contentView addSubview:checkImgView];
           footprintChangeAddressName.textColor=[UIColor color_e50834];
           checkImgView.image=[UIImage imageNamed:@"xuanze"];
          checkImgView.frame=CGRectMake(SCREEN_WIDTH-15-13.35, 28, 13.35, 14.15);
    }else{
           footprintChangeAddressName.textColor=[UIColor color_242424];
        //checkImgView.frame=CGRectMake(0,0,0,0);
        [checkImgView removeFromSuperview];
    }
    
}
@end
