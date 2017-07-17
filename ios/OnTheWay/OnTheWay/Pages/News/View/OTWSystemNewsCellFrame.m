//
//  OTWSystemNewsCellFrame.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import "OTWSystemNewsCellFrame.h"
#import "OTWSystemNewsModel.h"

@implementation OTWSystemNewsCellFrame

-(void)setNewsmodel:(OTWSystemNewsModel *) newsmodel
{
    _newsmodel = newsmodel;
    
    CGFloat padding = 15;
    
    //系统消息标题
    CGFloat newsTitleX = 15;
    CGFloat newsTitleY = 15;
    CGFloat newsTitleW = SCREEN_WIDTH - 2*padding - 12;
    CGFloat newsTitleH = 20;
    _newsTitleF = CGRectMake(newsTitleX, newsTitleY, newsTitleW, newsTitleH);
    
    //系统时间
    CGFloat newsTimeX = SCREEN_WIDTH - 2*padding - 12;
    CGFloat newsTimeY = 15;
    CGFloat newsTimeW = 32;
    CGFloat newsTimeH = 12;
    _newsTimeF = CGRectMake(newsTimeX, newsTimeY, newsTimeW, newsTimeH);
    
    //系统消息内容
    CGFloat newsContentX = 15;
    CGFloat newsContentY = newsTitleH + newsTitleY + 5;
    CGFloat newsContentW = SCREEN_WIDTH - 2*padding;
    CGFloat newsContentH = 38;
    _newsContentF = CGRectMake(newsContentX, newsContentY, newsContentW, newsContentH);
    
    _cellHeight = 93;
    
    _newsBGF = CGRectMake(0, 0, SCREEN_WIDTH, _cellHeight);
    
}
@end
