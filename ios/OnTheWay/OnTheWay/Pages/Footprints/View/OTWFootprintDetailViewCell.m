//
//  OTWFootprintDetailViewCell.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintDetailViewCell.h"

@interface OTWFootprintDetailViewCell()

@property (nonatomic,strong) UIView *footprintDetailBGView;

@end

#define footprintContentFont [UIFont systemFontOfSize:17]

@implementation OTWFootprintDetailViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath data:(id *)data
{
    static NSString *identifier = @"OTWFootprintDetail";
    OTWFootprintDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell){
        cell = [[OTWFootprintDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

//重写cell生成方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //判断一下 indexPath ，如果 = 0 表示 展示详情信息
        
        
        
        //其他展示评论信息
    }
    return self;
}

- (void)buildFootprintDetail
{
    
}

- (void)bulidComment
{
    
}

#pragma mark - Getter Setter



/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
