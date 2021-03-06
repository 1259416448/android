//
//  OTWFindViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import "OTWFindViewCell.h"

#import "OTWFindModel.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#define FindTableViewCellControlSpacing 10 //控件间距

#define FindTableViewBackImageHeight 130  //每个模块背景图片的高

#define FindTableViewFindTypeListWeight 35  //每个模块中商业类型图片的高

@interface OTWFindViewCell(){
    UIImageView *_FindTpyeBackgroundImageUrl;//背景
    UILabel *_FindTpyeName;//名称
    UIView *_FindTpyeContentList;//图标列表
}
@end

@implementation OTWFindViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
#pragma mark 初始化视图
-(void)initSubView{
    //背景控件
    _FindTpyeBackgroundImageUrl=[[UIImageView alloc]init];
    [self.contentView addSubview:_FindTpyeBackgroundImageUrl];
    //名称
    _FindTpyeName=[[UILabel alloc]init];
    _FindTpyeName.textColor=[UIColor whiteColor];
    _FindTpyeName.font=[UIFont systemFontOfSize:25];
    _FindTpyeName.layer.shadowColor = [UIColor blackColor].CGColor;
    _FindTpyeName.layer.shadowOpacity = 0.3;
    _FindTpyeName.layer.shadowOffset = CGSizeMake(0, 1);
    [self.contentView addSubview:_FindTpyeName];
    //图标列表
    _FindTpyeContentList=[[UIView alloc]init];
    
    //_text.lineBreakMode=NSLineBreakByWordWrapping;
//    [self.contentView addSubview:_FindTpyeContentList];
}

#pragma mark 设置模块
-(void)setStatus:(OTWFindStatus *)status{
    //设置背景大小和位置
    CGRect avatarRect=CGRectMake(15, FindTableViewCellControlSpacing,  SCREEN_WIDTH-30, FindTableViewBackImageHeight);
    _FindTpyeBackgroundImageUrl.image = [UIImage imageNamed:status.FindTpyeBackgroundImageUrl];
    _FindTpyeBackgroundImageUrl.frame=avatarRect;
    //根据名称计算占用空间大小
    CGSize userNameSize=[status.FindTpyeName sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:25]}];
    CGRect userNameRect=CGRectMake( SCREEN_WIDTH-20-userNameSize.width-15, 32,userNameSize.width,userNameSize.height);
    _FindTpyeName.text=status.FindTpyeName;
    _FindTpyeName.frame=userNameRect;
    
    //根据list个数来计算图标模块的大小

   CGRect FindTpyeContentListRec=CGRectMake(SCREEN_WIDTH-35-(status.FindTpyeContentList.count-1)*(FindTableViewFindTypeListWeight+15), 67,(status.FindTpyeContentList.count-1)*(FindTableViewFindTypeListWeight+15),FindTableViewFindTypeListWeight);
     _FindTpyeContentList.frame=FindTpyeContentListRec;
    
        //循环显示图标
    for (int i = 0; i < status.FindTpyeContentList.count; i ++) {
        
        //显示图标的名称
        UILabel  *iconName=[[UILabel alloc] init];
        iconName.frame=CGRectMake( 0, 38, 40,15);
        iconName.text=[status.FindTpyeContentList[i] objectForKey:@"name"];
        iconName.textAlignment = NSTextAlignmentCenter;//剧中显示
        iconName.textColor=[UIColor whiteColor];
        iconName.font=[UIFont systemFontOfSize:12];
        
        //显示图标
        UIButton *btn = [[UIButton alloc]init];
//        iconImageView.image=[UIImage imageNamed:[status.FindTpyeContentList[i] objectForKey:@"iconStr"]];
        [btn setImage:[UIImage imageNamed:[status.FindTpyeContentList[i] objectForKey:@"iconStr"]] forState:UIControlStateNormal];
        btn.tag = [[status.FindTpyeContentList[i] objectForKey:@"id"] integerValue];
        [btn addTarget:self action:@selector(buttonActin:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(2.5, 0, FindTableViewFindTypeListWeight, FindTableViewFindTypeListWeight);
        UIView *iconBox=[[UIView alloc] init];
        //设置图标模块的view
        iconBox.frame=CGRectMake(SCREEN_WIDTH - 30 - (status.FindTpyeContentList.count - i) * (FindTableViewFindTypeListWeight + 15) + 10, 67, 40, 55);
    
        [self addSubview:iconBox];
        [iconBox addSubview:iconName];
        [iconBox addSubview:btn];

    }
    
}
- (void)buttonActin:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWithTypeId:andIndexpath:)]) {
        [_delegate selectedWithTypeId: [NSNumber numberWithInteger:btn.tag] andIndexpath:_indexPath];
    }
}
@end






