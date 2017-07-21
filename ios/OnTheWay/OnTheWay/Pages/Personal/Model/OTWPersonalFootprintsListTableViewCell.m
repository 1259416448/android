//
//  OTWPersonalFootprintsListTableViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//
#import "OTWPersonalFootprintsListModel.h"
#import "OTWPersonalFootprintsListTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface OTWPersonalFootprintsListTableViewCell(){
    UILabel  *_footprintsDay;
    UIView  *_footPrintsCon;
    UILabel *_leftCell;
    UIView *_today;
}
@end

@implementation OTWPersonalFootprintsListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

#pragma mark 初始化视图
-(void)initSubView{
    
    //日期
    _footprintsDay=[[UILabel alloc]init];
    [self.contentView addSubview:_footprintsDay];
    //发表内容
    _footPrintsCon=[[UIView alloc]init];
    [self.contentView addSubview:_footPrintsCon];
    
    //侧边线
    _leftCell=[[UILabel alloc]init];
    _leftCell.backgroundColor=[UIColor color_d5d5d5];
    [self.contentView addSubview:_leftCell];
    
    //今天
    _today=[[UIView alloc]init];
    [self.contentView addSubview:_today];
}
#pragma mark 设置模块
-(void) setData:(OTWPersonalFootprintMonthDataModel *) data{
    for (UIImageView *imageView in _today.subviews) {//移除加载的cell
        [imageView removeFromSuperview];
    }
    //判断是否是今天，当data.day的值为0的时候，显示今天
    if([data.day isEqualToString:@"0"]){
        _footprintsDay.text=@"今天";
        _footprintsDay.textColor=[UIColor color_202020];
        _footprintsDay.font=[UIFont systemFontOfSize:17];
        _footprintsDay.frame=CGRectMake(36,0,34, 24);
        
        _today.frame=CGRectMake(0, 0, SCREEN_WIDTH, 80);
        
        UIView *photoIconView = [[UIView alloc] initWithFrame:CGRectMake(_footprintsDay.MaxX + 10, 0, 80, 80)];
        photoIconView.backgroundColor = [UIColor color_ededed];
        //相机图标
        UIImageView *photoIcon=[[UIImageView alloc] initWithFrame:CGRectMake(20, 21.5, 40, 37)];
        photoIcon.image=[UIImage imageNamed:@"wd_xiangji"];
        photoIcon.backgroundColor = [UIColor color_ededed];
        [photoIconView addSubview:photoIcon];
        [_today addSubview:photoIconView];
        
        //左边线条
        UILabel *sectionHeaderLeft=[[UILabel alloc] initWithFrame:CGRectMake(22.5, 9.5, 1,80+15-9.5)];
        sectionHeaderLeft.backgroundColor=[UIColor color_d5d5d5];
        [_today addSubview:sectionHeaderLeft];
        
        //左边红色圆点
        UILabel *sectionHeaderCil=[[UILabel alloc] initWithFrame:CGRectMake(20, 9.5, 6,6)];
        sectionHeaderCil.backgroundColor=[UIColor color_e50834];
        sectionHeaderCil.layer.cornerRadius = 3;
        sectionHeaderCil.layer.masksToBounds = YES;
        [_today addSubview:sectionHeaderCil];
        
        
        //将整个评论内容向下移动
        _footPrintsCon.frame=CGRectMake(80, 95, SCREEN_WIDTH-80, data.dayData.count*80+(data.dayData.count)*15);
        _leftCell.frame=CGRectMake(22.5, 95, 1,data.dayData.count*80+(data.dayData.count)*15);
        
    }else{
        
        //当不是今天时，显示日期
        _today.frame=CGRectMake(0, 0, 0, 0);
        _footprintsDay.text=[data.day stringByAppendingString:@"日"];
        _footprintsDay.textColor=[UIColor color_757575];
        _footprintsDay.font=[UIFont systemFontOfSize:14];
        _footprintsDay.frame=CGRectMake(36,0, 30, 15);
        _footPrintsCon.frame=CGRectMake(80, 0, SCREEN_WIDTH-80, data.dayData.count*80+(data.dayData.count)*15);
        _leftCell.frame=CGRectMake(22.5, 0, 1,data.dayData.count*80+(data.dayData.count)*15);
    }
    
    
    for (UIImageView *imageView in _footPrintsCon.subviews) {//移除加载的cell
        [imageView removeFromSuperview];
    }
    
    for(int i=0;i<data.dayData.count;i++){
        UIView *imgBox=[[UIView alloc] initWithFrame:CGRectMake(0, 80*i+i*15, 80, 80)];
        
        //判断足迹图片张数而现实不同的样式
        if(data.dayData[i].footprintPhotoArray.count==1){
            
            UIImageView *imgFirst=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
            [imgFirst setImageWithURL:[NSURL URLWithString:[data.dayData[i].footprintPhotoArray[0] stringByAppendingString:@"?imageView2/1/w/160/h/160"]]];
            
            [imgBox addSubview:imgFirst];
            
        }else{
            
            if(data.dayData[i].footprintPhotoArray.count==2){
                
                UIImageView *imgFirst=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 80)];
                [imgFirst setImageWithURL:[NSURL URLWithString:[data.dayData[i].footprintPhotoArray[0] stringByAppendingString:@"?imageView2/1/w/78/h/160"]]];
                
                UIImageView *imgSec=[[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 39, 80)];
                [imgSec setImageWithURL:[NSURL URLWithString:[data.dayData[i].footprintPhotoArray[1] stringByAppendingString:@"?imageView2/1/w/78/h/160"]]];
                
                [imgBox addSubview:imgFirst];
                [imgBox addSubview:imgSec];
                
                
            }else if(data.dayData[i].footprintPhotoArray.count==3){
                
                UIImageView *imgFirst=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 80)];
                [imgFirst setImageWithURL:[NSURL URLWithString:[data.dayData[i].footprintPhotoArray[0] stringByAppendingString:@"?imageView2/1/w/78/h/160"]]];
                
                UIImageView *imgSec=[[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 39, 39)];
                [imgSec setImageWithURL:[NSURL URLWithString:[data.dayData[i].footprintPhotoArray[1] stringByAppendingString:@"?imageView2/1/w/78/h/78"]]];
                
                UIImageView *imgThr=[[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 39, 39)];
                [imgThr setImageWithURL:[NSURL URLWithString:[data.dayData[i].footprintPhotoArray[2] stringByAppendingString:@"?imageView2/1/w/78/h/78"]]];
                
                [imgBox addSubview:imgFirst];
                [imgBox addSubview:imgSec];
                [imgBox addSubview:imgThr];
                
                
            }else if(data.dayData[i].footprintPhotoArray.count>=4){
                UIImageView *imgFirst=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 39)];
                [imgFirst setImageWithURL:[NSURL URLWithString:[data.dayData[i].footprintPhotoArray[0] stringByAppendingString:@"?imageView2/1/w/78/h/78"]]];
                
                UIImageView *imgSec=[[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 39, 39)];
                [imgSec setImageWithURL:[NSURL URLWithString:[data.dayData[i].footprintPhotoArray[1] stringByAppendingString:@"?imageView2/1/w/78/h/78"]]];
                
                UIImageView *imgThr=[[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 39, 39)];
                [imgThr setImageWithURL:[NSURL URLWithString:[data.dayData[i].footprintPhotoArray[2] stringByAppendingString:@"?imageView2/1/w/78/h/78"]]];
                
                UIImageView *imgFour=[[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 39, 39)];
                [imgFour setImageWithURL:[NSURL URLWithString:[data.dayData[i].footprintPhotoArray[3] stringByAppendingString:@"?imageView2/1/w/78/h/78"]]];
                
                [imgBox addSubview:imgFirst];
                [imgBox addSubview:imgSec];
                [imgBox addSubview:imgThr];
                [imgBox addSubview:imgFour];
                
            }
            //当现实非1张图时显示图片张数
            UILabel *numOfPhoto=[[UILabel alloc] initWithFrame:CGRectMake(80-20, 3, 17, 17)];
            numOfPhoto.text=[NSString stringWithFormat:@"%lu",data.dayData[i].footprintPhotoArray.count];
            numOfPhoto.font=[UIFont systemFontOfSize:12];
            numOfPhoto.textColor=[UIColor whiteColor];
            numOfPhoto.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.6f];
            numOfPhoto.textAlignment=NSTextAlignmentCenter;
            numOfPhoto.layer.cornerRadius=17/2;
            numOfPhoto.layer.masksToBounds = YES;
            
            [imgBox addSubview:numOfPhoto];
        }
        
        //评论内容
        UILabel *footprintsContent=[[UILabel alloc] init];
        footprintsContent.text=data.dayData[i].footprintContent;
        footprintsContent.font=[UIFont systemFontOfSize:15];
        footprintsContent.textColor=[UIColor color_202020];
        footprintsContent.frame=CGRectMake(90, 0, SCREEN_WIDTH-170-15, 20);
        footprintsContent.numberOfLines=3;
        [footprintsContent sizeToFit];
        
        //地址图标
        UIImageView *footprintsAddressIcon=[[UIImageView alloc] initWithFrame:CGRectMake(90, 80-10, 8, 10)];
        footprintsAddressIcon.image=[UIImage imageNamed:@"dinwgei_2"];
        
        
        //地址
        UILabel *footprintsAddress=[[UILabel alloc] init];
        footprintsAddress.text=data.dayData[i].footprintAddress;
        footprintsAddress.font=[UIFont systemFontOfSize:11];
        footprintsAddress.textColor=[UIColor color_979797];
        footprintsAddress.frame=CGRectMake(90+10, 80-12, SCREEN_WIDTH-181-15, 12);
        
        [_footPrintsCon addSubview:imgBox];
        [imgBox addSubview:footprintsContent];
        [imgBox addSubview:footprintsAddressIcon];
        [imgBox addSubview:footprintsAddress];
    }
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_footPrintsCon.frame))];
}

@end
