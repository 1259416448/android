//
//  OTWShopActiveViewCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWShopActiveViewCell.h"
@interface OTWShopActiveViewCell (){
    UILabel *activeTime;
    UILabel *activeName;
    UILabel *activeTimeBorder;
    UILabel *activeStatus;
    UIView *activeContentView;
    UIImageView *activeIcon;
    UILabel *activeConten;
    UILabel *activeUrl;
    UILabel *activeUrlBorder;
}
@end

@implementation OTWShopActiveViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    //时间
    
    activeTime=[[UILabel alloc]init];
    activeTime.text=@"2017.02.01-2019.12.31";
    activeTime.font=[UIFont systemFontOfSize:11];
    [activeTime sizeToFit];
    activeTime.textColor=[UIColor color_979797];
    
    //名称
    activeName=[[UILabel alloc]init];
    activeName.text=@"开展外卖活动";
    activeName.font=[UIFont systemFontOfSize:17];
    [activeName sizeToFit];
    if((activeName .frame.size.width+activeTime.Witdh+40)>SCREEN_WIDTH){
        CGRect activeNameRect=CGRectMake(15, 0.5,SCREEN_WIDTH-40-activeTime.Witdh-30,49);
        activeName.frame=activeNameRect;
    }else{
        CGRect activeNameRect=CGRectMake(15, 0.5,activeName.frame.size.width,49);
        activeName.frame=activeNameRect;
    }
    activeTime.frame=CGRectMake(activeName.MaxX+5, 0.5, activeTime.Witdh, 49);
    
    //边框
    activeTimeBorder=[[UILabel alloc]init];
    activeTimeBorder.frame=CGRectMake(0, 0, SCREEN_WIDTH, 50);
    activeTimeBorder.layer.borderColor=[UIColor color_d5d5d5].CGColor;
    activeTimeBorder.layer.borderWidth=0.5;
    
    //状态
    activeStatus=[[UILabel alloc]init];
    activeStatus.frame=CGRectMake(SCREEN_WIDTH-15-40, 0.5, 40, 49);
    activeStatus.textAlignment=NSTextAlignmentRight;
    activeStatus.font=[UIFont systemFontOfSize:11];
    
    
    [self.contentView addSubview:activeTimeBorder];
    [self.contentView addSubview:activeTime];
    [self.contentView addSubview:activeName];
    [self.contentView addSubview:activeStatus];
    
    //内容背景
    activeContentView=[[UIView alloc]init];
    
    //活动类型图标
    activeIcon=[[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 15, 15)];
    
    //活动内容
    activeConten=[[UILabel alloc]init];
//    activeConten.text= [NSString stringWithFormat:@"%@%@",@"  ",@"即日起，本店可以在百度外卖，美团外卖下单，30元起送，配送费6元，送达时长45分钟左右，可以在以下网址中直接点订餐，也可以联系客服。"];
//    activeConten.font=[UIFont systemFontOfSize:15];
//    activeConten.textColor=[UIColor color_757575];
    
    NSMutableAttributedString *content=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",@"    ",@"即日起，本店可以在百度外卖，美团外卖下单，30元起送，配送费6元，送达时长45分钟左右，可以在以下网址中直接点订餐，也可以联系客服。" ]];
    [content addAttribute: NSFontAttributeName
                    value:[UIFont systemFontOfSize:15]
                    range:NSMakeRange(0,2)];
    [content addAttribute:NSForegroundColorAttributeName
                    value:[[UIColor whiteColor] colorWithAlphaComponent:0]
                    range:NSMakeRange(0,2)
                ];

    
  
    activeConten.frame=CGRectMake(15, 15, SCREEN_WIDTH-30,23);
    activeConten.attributedText=content;
    activeConten.numberOfLines = 0;
    activeConten.textColor=[UIColor color_757575];
    [activeConten sizeToFit];
    
    activeContentView.frame=CGRectMake(0, activeTimeBorder.MaxY, SCREEN_WIDTH, activeConten.Height+30);
    [activeContentView addSubview:activeConten];
    [activeContentView addSubview:activeIcon];
    [self.contentView addSubview:activeContentView];
    
    activeUrl=[[UILabel alloc]init];
    activeUrl.text=@"http://www.baidu.commmmmmmmmmmmmommmmmmmmmmmmmm";
    activeUrl.font=[UIFont systemFontOfSize:14];
    [activeUrl sizeToFit];
    activeUrl.frame=CGRectMake(15, activeContentView.MaxY, SCREEN_WIDTH-30, 43);
    activeUrl.textColor=[UIColor color_979797];

    activeUrlBorder=[[UILabel alloc]init];
    activeUrlBorder.frame=CGRectMake(0, activeContentView.MaxY, SCREEN_WIDTH, 44);
    activeUrlBorder.layer.borderColor=[UIColor color_d5d5d5].CGColor;
    activeUrlBorder.layer.borderWidth=0.5;
   
    [self.contentView addSubview:activeUrlBorder];
 [self.contentView addSubview:activeUrl];
    
    NSString *str= [[NSString alloc]initWithCString:"going" encoding:NSUTF8StringEncoding];
    //未开始
    if([str isEqualToString:@"start"]){
        activeTimeBorder.backgroundColor=[UIColor whiteColor];
         activeTime.backgroundColor=[UIColor whiteColor];
        activeStatus.text=@"未开始";
        activeStatus.textColor=[UIColor color_e50834];
        activeIcon.image=[UIImage imageNamed:@"wd_qianbao"];
        activeContentView.backgroundColor=[UIColor whiteColor];
        activeUrlBorder.backgroundColor=[UIColor whiteColor];
    }
    //进行中
    else if([str isEqualToString:@"going"]){
        activeTimeBorder.backgroundColor=[UIColor whiteColor];
        activeTime.backgroundColor=[UIColor whiteColor];
        activeStatus.text=@"进行中";
        activeStatus.textColor=[UIColor color_ff9144];
        activeIcon.image=[UIImage imageNamed:@"wd_qianbao"];
        activeContentView.backgroundColor=[UIColor whiteColor];
        activeUrlBorder.backgroundColor=[UIColor whiteColor];
    }
    
    //已结束
    else if([str isEqualToString:@"end"]){
        activeTimeBorder.backgroundColor=[UIColor color_ededed];
        activeTime.backgroundColor=[UIColor color_ededed];
        activeStatus.text=@"已结束";
        activeStatus.textColor=[UIColor color_979797];
        activeIcon.image=[UIImage imageNamed:@"wd_qianbao"];
        activeContentView.backgroundColor=[UIColor color_ededed];
        activeUrlBorder.backgroundColor=[UIColor color_ededed];
    }
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(activeUrlBorder.frame)+10)];
}

@end
