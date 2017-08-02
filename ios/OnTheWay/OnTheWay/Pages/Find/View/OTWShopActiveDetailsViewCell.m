//
//  OTWShopActiveDetailsViewCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/1.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWShopActiveDetailsViewCell.h"
@interface OTWShopActiveDetailsViewCell(){
    UILabel *cellName;
    UILabel *activeContent;
    UILabel *activeContentBox;
}
@end

@implementation OTWShopActiveDetailsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    cellName = [[UILabel alloc]initWithFrame:CGRectMake(15,0, SCREEN_WIDTH-30, 50)];
    cellName.text=@"活动简介";
    cellName.textColor=[UIColor color_202020];
    cellName.font=[UIFont systemFontOfSize:16];
    [self.contentView addSubview:cellName];
    
    activeContentBox=[[UILabel alloc]initWithFrame:CGRectMake(15,cellName.MaxY, SCREEN_WIDTH-30, 120)];
    activeContentBox.layer.borderColor=[UIColor color_d5d5d5].CGColor;
    activeContentBox.layer.borderWidth=0.5;
    [self.contentView addSubview:activeContentBox];

    
    NSString *textStr = @"即日起，本店可以在百度外卖，美团外卖下单，30元起送，配送费6元，送达时长45分钟左右，可以在以下网址中直接点订餐，也可以联系客服";
    activeContent=[[UILabel alloc]init];
    activeContent.text=textStr;
    activeContent.font=[UIFont systemFontOfSize:15];
    activeContent.textColor=[UIColor color_757575];
    activeContent.numberOfLines = 4;
    
    activeContent.frame=CGRectMake(15,15,activeContentBox.Witdh-30 ,90);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
    activeContent.attributedText = attributedString;

   [activeContentBox addSubview:activeContent];
   [activeContent sizeToFit];
}

@end
