//
//  OTWPersonalFindTableViewCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/28.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalFindTableViewCell.h"

@interface OTWPersonalFindTableViewCell (){
    UILabel *findShopTime;
    UILabel *findShopTimeBorder;
    UILabel *findShopName;
    UIImageView *findShopAddressIcon;
    UILabel *findShopAddress;
    UIImageView *findShopPhoneIcon;
    UILabel *findShopPhone;
    UIView *findShopInfoView;
    UILabel *findShopCheck;//审核状态
    UIImageView *findShopChecked;//审核通过图片
    UILabel *findShopFailReason;//审核失败的原因
    UILabel *findShopDelete;//删除
    UIView *findShopFailReasonBox;
    
}
@end

@implementation OTWPersonalFindTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    
    //时间
    
    findShopTime=[[UILabel alloc]init];
    findShopTime.text=@"2017-02-01";
    findShopTime.frame=CGRectMake(15, 0.5, 80, 29);
    findShopTime.textColor=[UIColor color_979797];
    findShopTime.font=[UIFont systemFontOfSize:11];
    
    
    findShopTimeBorder=[[UILabel alloc]init];
    findShopTimeBorder.frame=CGRectMake(0, 0, SCREEN_WIDTH, 30);
    findShopTimeBorder.layer.borderColor=[UIColor color_d5d5d5].CGColor;
    findShopTimeBorder.layer.borderWidth=0.5;
    
    [self.contentView addSubview:findShopTimeBorder];
    [self.contentView addSubview:findShopTime];
    
    //审核状态文字显示
    findShopCheck=[[UILabel alloc]init];
    
    //内容框
    findShopInfoView=[[UIView alloc]init];
    [self.contentView addSubview:findShopInfoView];
    
    //名称
    findShopName=[[UILabel alloc]init];
    findShopName.frame=CGRectMake(15, 15, SCREEN_WIDTH-30, 15);
    findShopName.font=[UIFont systemFontOfSize:16];
    findShopName.text=@"胡大饭馆（东直门总店）";
    findShopName.textColor=[UIColor color_202020];
    [findShopInfoView addSubview:findShopName];
    
    //地址图标
    findShopAddressIcon=[[UIImageView alloc] initWithFrame:CGRectMake(15, findShopName.MaxY+10,8, 10)];
    findShopAddressIcon.image=[UIImage imageNamed:@"dinwgei_2"];
    [findShopInfoView addSubview:findShopAddressIcon];
    
    //商店地址
    findShopAddress=[[UILabel alloc] initWithFrame:CGRectMake(findShopAddressIcon.MaxX+5, findShopName.MaxY+10,SCREEN_WIDTH-30-5-findShopAddressIcon.width, 12)];
    findShopAddress.text=@"东城区东直门内大街233";
    findShopAddress.font=[UIFont systemFontOfSize:13];
    findShopAddress.textColor=[UIColor color_979797];
    [findShopInfoView addSubview:findShopAddress];
    
    NSString *phoneNum= [[NSString alloc]initWithCString:"872727727" encoding:NSUTF8StringEncoding];
    
    if([phoneNum isEqualToString:@""]){
        
         [findShopPhoneIcon removeFromSuperview];
         [findShopPhone removeFromSuperview];
        findShopInfoView.frame=CGRectMake(0, findShopTimeBorder.MaxY, SCREEN_WIDTH, findShopAddress.MaxY+15);
        
    }else{
        //商店电话图标
        findShopPhoneIcon=[[UIImageView alloc] initWithFrame:CGRectMake(15, findShopAddress.MaxY+6.5,8, 10)];
        findShopPhoneIcon.image=[UIImage imageNamed:@"dianhua"];
        [findShopInfoView  addSubview:findShopPhoneIcon];
        
        //商店电话号码
        findShopPhone=[[UILabel alloc] initWithFrame:CGRectMake(findShopPhoneIcon.MaxX+5, findShopAddress.MaxY+6.5,SCREEN_WIDTH-30-5-findShopPhoneIcon.width, 12)];
        findShopPhone.text=@"87474993";
        findShopPhone.font=[UIFont systemFontOfSize:11];
        findShopPhone.textColor=[UIColor color_979797];
        [findShopInfoView addSubview:findShopPhone];
        
        findShopInfoView.frame=CGRectMake(0, findShopTimeBorder.MaxY, SCREEN_WIDTH, findShopPhone.MaxY+15);
    }

    findShopFailReasonBox=[[UIView alloc]init];
    
    NSString *str= [[NSString alloc]initWithCString:"checked" encoding:NSUTF8StringEncoding];
    
    //审核中
    if([str isEqualToString:@"checking"]){
        DLog(@"111");
        findShopTime.backgroundColor=[UIColor whiteColor];
        findShopTimeBorder.backgroundColor=[UIColor whiteColor];
        
        //审核状态文字显示
        findShopCheck.text=@"审核中";
        findShopCheck.textColor=[UIColor color_ff9144];
        findShopCheck.font=[UIFont systemFontOfSize:11];
        [findShopCheck sizeToFit];
        findShopCheck.backgroundColor=[UIColor whiteColor];
        findShopCheck.frame=CGRectMake(SCREEN_WIDTH-15-findShopCheck.width, 7.5, findShopCheck.width, 15);
        [self.contentView addSubview:findShopCheck];
        
        findShopInfoView.backgroundColor=[UIColor whiteColor];
        [findShopChecked removeFromSuperview];
        
        findShopFailReasonBox.frame=CGRectMake(0, findShopInfoView.MaxY-0.5, SCREEN_WIDTH, 0.5);
        findShopFailReasonBox.backgroundColor=[UIColor color_d5d5d5];
        findShopFailReasonBox.layer.borderWidth=0;
        [self.contentView addSubview:findShopFailReasonBox];
        [findShopDelete removeFromSuperview];
        [findShopFailReason removeFromSuperview];
        
    }
     //审核成功
    else if([str isEqualToString:@"checked"]){
        findShopTime.backgroundColor=[UIColor whiteColor];
        findShopTimeBorder.backgroundColor=[UIColor whiteColor];
        [findShopCheck removeFromSuperview];
        
         findShopInfoView.backgroundColor=[UIColor whiteColor];
        
        //审核通过的图片展示
        findShopChecked=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-68.34-15,15 ,68.35,35.9)];
        findShopChecked.image=[UIImage imageNamed:@"shenhetongguo"];
        [findShopInfoView addSubview:findShopChecked];
        
        findShopFailReasonBox.frame=CGRectMake(0, findShopInfoView.MaxY-0.5, SCREEN_WIDTH, 0.5);
        findShopFailReasonBox.backgroundColor=[UIColor color_d5d5d5];
        findShopFailReasonBox.layer.borderWidth=0;
        [self.contentView addSubview:findShopFailReasonBox];
        
        [findShopDelete removeFromSuperview];
        [findShopFailReason removeFromSuperview];

    }
     //审核失败
    else if([str isEqualToString:@"fail"]){
        findShopTime.backgroundColor=[UIColor color_ededed];
        findShopTimeBorder.backgroundColor=[UIColor color_ededed];
        
         //审核状态文字显示
        findShopCheck.text=@"审核未通过";
        findShopCheck.textColor=[UIColor color_979797];
        findShopCheck.font=[UIFont systemFontOfSize:11];
        [findShopCheck sizeToFit];
        findShopCheck.frame=CGRectMake(SCREEN_WIDTH-15-findShopCheck.width, 7.5, findShopCheck.width, 15);
        [self.contentView addSubview:findShopCheck];
        
        findShopInfoView.backgroundColor=[UIColor color_ededed];
        //[findShopChecked removeFromSuperview];
        
        //审核失败原因背景
        findShopFailReasonBox.frame=CGRectMake(0, findShopInfoView.MaxY, SCREEN_WIDTH, 32);
        findShopFailReasonBox.backgroundColor=[UIColor color_ededed];
        findShopFailReasonBox.layer.borderWidth=0.5;
        findShopFailReasonBox.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        [self.contentView addSubview:findShopFailReasonBox];
        
        //原因
        findShopFailReason=[[UILabel alloc]initWithFrame:CGRectMake(15, findShopInfoView.MaxY+8.5, SCREEN_WIDTH-40-30, 15)];
        findShopFailReason.text=@"原因：地址与店名不符，请重新发布";
        findShopFailReason.font=[UIFont systemFontOfSize:11];
        findShopFailReason.textColor=[UIColor color_979797];
        [self.contentView addSubview:findShopFailReason];
        
        //删除
        findShopDelete=[[UILabel alloc]init];
        findShopDelete.text=@"删除";
        findShopDelete.textColor=[UIColor color_e50834];
        findShopDelete.font=[UIFont systemFontOfSize:11];
        findShopDelete.textAlignment=NSTextAlignmentRight;
        [findShopDelete sizeToFit];
        findShopDelete.frame=CGRectMake(SCREEN_WIDTH-15-40, findShopInfoView.MaxY, 40, 32);
        [self.contentView addSubview:findShopDelete];
        
        UITapGestureRecognizer  *tapGesturDelete=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DeleteClick)];
        [findShopDelete addGestureRecognizer:tapGesturDelete];
       
    }
     [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(findShopFailReasonBox.frame)+10)];
    
    
}

-(void)DeleteClick{
    DLog(@"点击了删除");
}

@end
