//
//  OTWPersonalCollectTableViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/26.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalCollectTableViewCell.h"

@interface OTWPersonalCollectTableViewCell (){
    UILabel *shopName;
    UIView *shopQuanView;
    UIImageView *shopAddressView;
    UILabel *shopAddress;
    UILabel *collectTime;

}
@property (nonatomic,strong) NSMutableArray *tableViewLabelArray;//模拟一个券的数组
@end

@implementation OTWPersonalCollectTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    _tableViewLabelArray= [[NSMutableArray alloc]init];
    [_tableViewLabelArray addObject:@"wd_qianbao"];
    [_tableViewLabelArray addObject:@"wd_qianbao"];
    [_tableViewLabelArray addObject:@"wd_qianbao"];
    [_tableViewLabelArray addObject:@"wd_qianbao"];

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    //设置边框
    self.contentView.layer.borderWidth=0.25;
    self.contentView.layer.borderColor=[UIColor color_d5d5d5].CGColor;
    
    //收藏时间
    collectTime=[[UILabel alloc]init];
    collectTime.textAlignment = NSTextAlignmentRight;
//    collectTime.text=@"2017.02.09";
    collectTime.font=[UIFont systemFontOfSize:11];
    collectTime.textColor=[UIColor color_979797];
    collectTime.frame= CGRectMake(SCREEN_WIDTH-15-60, 15, 60, 12);
    [self.contentView addSubview:collectTime];
    
    //商家名称
    shopName=[[UILabel alloc]init];
    shopName.textColor=[UIColor color_202020];
    shopName.font=[UIFont systemFontOfSize:17];
//    shopName.text=@"眉州东坡酒楼";
    shopName.font=[UIFont systemFontOfSize:17];
//    [shopName sizeToFit];
//    if((shopName .frame.size.width+_tableViewLabelArray.count*20+30+60)>SCREEN_WIDTH){
//        CGRect shopNameRect=CGRectMake(15, 15,SCREEN_WIDTH-_tableViewLabelArray.count*20-30-60,18);
//        shopName.frame=shopNameRect;
//    }else{
//        CGRect shopNameRect=CGRectMake(15, 15,shopName .frame.size.width,18);
//        shopName.frame=shopNameRect;
//    }
//    
    [self.contentView addSubview:shopName];
    
    //优惠券
    shopQuanView=[[UIView alloc]init];
    CGRect shopQuanViewRec=CGRectMake(shopName .frame.size.width+15,15,_tableViewLabelArray.count*20,15);
    shopQuanView.frame=shopQuanViewRec;
    
    for (UIImageView *imageView in  shopQuanView.subviews) {//移除加载的图片
        [imageView removeFromSuperview];
    }
    //循环显示图标
    for (int i = 0; i < _tableViewLabelArray.count; i ++) {
        //显示图标
        UIImageView *iconImageView = [[UIImageView alloc]init];
//        iconImageView.image=[UIImage imageNamed:_tableViewLabelArray[i]];
        iconImageView.frame=CGRectMake(2.5, 0, 15, 15);
        UIView *iconBox=[[UIView alloc] init];
        
        //设置图标模块的view
        iconBox.frame=CGRectMake((i*20), 0, 15, 15);
        [shopQuanView addSubview:iconBox];
        [iconBox addSubview:iconImageView];
        
    }
    [self.contentView addSubview:shopQuanView];
    
    
    
    //地址图标
    shopAddressView=[[UIImageView alloc]init];
    shopAddressView.image=[UIImage imageNamed:@"dinwgei_2"];
    shopAddressView.frame=CGRectMake(15, 44, 8, 10);
    [self.contentView addSubview:shopAddressView];
    
    //地址
    shopAddress=[[UILabel alloc]initWithFrame:CGRectMake(30, 43, SCREEN_WIDTH - 60, 11)];
    shopAddress.textColor=[UIColor color_979797];
    shopAddress.font=[UIFont systemFontOfSize:11];
//    shopAddress.text=@"东城区东直门内大街东城区东直门内大街区东直门内大街233";
    [self.contentView addSubview:shopAddress];
    
}
- (void)setModel:(OTWPersonCollectionModel *)model
{
    _model = model;
    collectTime.text = model.dateCreatedStr;
    shopName.text = model.name;    [shopName sizeToFit];
    [shopName sizeToFit];
//    if((shopName .frame.size.width+_tableViewLabelArray.count*20+30+60)>SCREEN_WIDTH){
//        CGRect shopNameRect=CGRectMake(15, 15,SCREEN_WIDTH-_tableViewLabelArray.count*20-30-60,18);
//        shopName.frame=shopNameRect;
//    }else{
//        CGRect shopNameRect=CGRectMake(15, 15,shopName.frame.size.width,18);
//        shopName.frame=shopNameRect;
//    }
    shopName.frame = CGRectMake(15, 15,SCREEN_WIDTH - 110,18);
    CGRect shopQuanViewRec=CGRectMake(shopName.frame.size.width+15,15,_tableViewLabelArray.count*20,15);
    shopQuanView.frame=shopQuanViewRec;
    shopAddress.text = model.address;


}
@end
