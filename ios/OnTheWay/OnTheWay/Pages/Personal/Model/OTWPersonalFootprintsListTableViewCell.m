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
#import "OTWUITapGestureRecognizer.h"

@interface OTWPersonalFootprintsListTableViewCell(){
    UILabel  *_footprintsDay;
    UIView  *_footPrintsCon;
    UILabel *_leftCell;
    UIView *_today;
}



@end

#define contentLabelFont [UIFont systemFontOfSize:15]

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
-(void) setData:(OTWPersonalFootprintMonthDataModel *) data
{
    //判断是否是今天，当data.day的值为0的时候，显示今天
    if([data.day isEqualToString:@"0"]){
        _footprintsDay.text=@"今天";
        _footprintsDay.textColor=[UIColor color_202020];
        _footprintsDay.frame=CGRectMake(36,0,35, 24);
        _footprintsDay.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        _today.frame=CGRectMake(0, 0, SCREEN_WIDTH, 80);
        
        CGFloat initY = 0;
        
        if(_ifMyFootprint){
            UIView *photoIconView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 80, 80)];
            photoIconView.backgroundColor = [UIColor color_ededed];
            //相机图标
            UIImageView *photoIcon=[[UIImageView alloc] initWithFrame:CGRectMake(20, 21.5, 40, 37)];
            photoIcon.image=[UIImage imageNamed:@"wd_xiangji"];
            photoIcon.backgroundColor = [UIColor color_ededed];
            [photoIconView addSubview:photoIcon];
            [_today addSubview:photoIconView];
            initY = 95;
            UITapGestureRecognizer *tapTecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActicnRelease)];
            [photoIconView addGestureRecognizer:tapTecognizer];
        }
        
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
        _footPrintsCon.frame=CGRectMake(80, initY, SCREEN_WIDTH-80, data.cellHeight);
        _leftCell.frame=CGRectMake(22.5, initY, 1,data.cellHeight);
        
    }else{
        //当不是今天时，显示日期
        _today.frame=CGRectMake(0, 0, 0, 0);
        _footprintsDay.text=[data.day stringByAppendingString:@"日"];
        _footprintsDay.textColor=[UIColor color_757575];
        _footprintsDay.font=[UIFont systemFontOfSize:14];
        _footprintsDay.frame=CGRectMake(36,1, 30, 15);
        _footPrintsCon.frame=CGRectMake(80, 0, SCREEN_WIDTH-80, data.dayData.count*80+(data.dayData.count)*15);
        _leftCell.frame=CGRectMake(22.5, 0, 1,data.dayData.count*80+(data.dayData.count)*15);
    }
    
    NSMutableArray<UIView *> *imgBoxHArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<data.dayData.count;i++){
        
        CGFloat imgBoxH = 80;
        
        CGFloat imgBoxY = 0;
        
        CGFloat contentLabelX = 90;
        
        CGFloat contentLabelH = 60;
        
        CGFloat contentLabelW = SCREEN_WIDTH - 170 - 15;
        //没有图片
        
        OTWFootprintListModel *one = data.dayData[i];
        
        if(!one.footprintPhotoArray || one.footprintPhotoArray==0){
            contentLabelW = SCREEN_WIDTH - 15 - 80;
            CGSize textSize = [self sizeWithString:one.footprintContent font:contentLabelFont maxSize:CGSizeMake(contentLabelW, 60)];
            if(textSize.height < contentLabelH){
                contentLabelH = textSize.height;
            }
            imgBoxH = contentLabelH + 20;
            contentLabelX = 0;
        }
        
        if(imgBoxHArray.count > 0){
            imgBoxY = imgBoxHArray[i-1].MaxY;
        }
        
        UIView *imgBox=[[UIView alloc] initWithFrame:CGRectMake(0, imgBoxY, SCREEN_WIDTH - 15 - 80, imgBoxH + 15 )];
        
        [imgBoxHArray addObject:imgBox];
        //判断足迹图片张数而现实不同的样式
        
        if(data.dayData[i].footprintPhotoArray && data.dayData[i].footprintPhotoArray>0){
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

        }
        //评论内容
        
        UILabel *footprintsContent=[[UILabel alloc] init];
        footprintsContent.text=data.dayData[i].footprintContent;
        footprintsContent.font=[UIFont systemFontOfSize:15];
        footprintsContent.textColor=[UIColor color_202020];
        footprintsContent.frame=CGRectMake(contentLabelX, 0, contentLabelW, contentLabelH);
        footprintsContent.numberOfLines=0;
        
        //地址图标
        UIImageView *footprintsAddressIcon=[[UIImageView alloc] initWithFrame:CGRectMake(contentLabelX,footprintsContent.MaxY + 9 , 10, 10)];
        footprintsAddressIcon.image=[UIImage imageNamed:@"dinwgei_2"];
        
        //地址
        UILabel *footprintsAddress=[[UILabel alloc] init];
        footprintsAddress.text=data.dayData[i].footprintAddress;
        footprintsAddress.font=[UIFont systemFontOfSize:11];
        footprintsAddress.textColor=[UIColor color_979797];
        footprintsAddress.frame=CGRectMake(footprintsAddressIcon.MaxX + 3 , footprintsContent.MaxY + 8, footprintsContent.Witdh - footprintsAddressIcon.Witdh - 3 , 12);
        
        [_footPrintsCon addSubview:imgBox];
        [imgBox addSubview:footprintsContent];
        [imgBox addSubview:footprintsAddressIcon];
        [imgBox addSubview:footprintsAddress];
        
        //imgBox 增加点击事件
        OTWUITapGestureRecognizer *tapGesturRecognizer=[[OTWUITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tapGesturRecognizer.opId = one.footprintId.description;
        [imgBox addGestureRecognizer:tapGesturRecognizer];
        
    }
}

-(void) tapAction:(UITapGestureRecognizer *)tapRecognizer
{
    OTWUITapGestureRecognizer *tap = (OTWUITapGestureRecognizer*) tapRecognizer;
    if(_tapOne){
        _tapOne(tap.opId);
    }
}

-(void) tapActicnRelease
{
    if(_tapRelease){
        _tapRelease();
    }
}

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
