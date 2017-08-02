//
//  OTWPersonalFootprintTableViewCell.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/1.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OTWPersonalFootprintFrame.h"
#import "OTWPersonalFootprintTableViewCell.h"

@interface OTWPersonalFootprintTableViewCell()

@property (nonatomic,strong) UILabel *sectionHeaderCil;

@property (nonatomic,strong) UILabel *sectionHeaderLeft;

@property (nonatomic,strong) UILabel *leftContentLabel;

@property (nonatomic,strong) UIView *todayPhotoImageBGView;

@property (nonatomic,strong) UIImageView *todayPhotoImageView;

@property (nonatomic,strong) UIView *onePhotoImageBGView;

@property (nonatomic,strong) UIView *twoPhotoImageBGView;

@property (nonatomic,strong) UIView *threePhotoImageBGView;

@property (nonatomic,strong) UIView *fourPhotoBGView;

@property (nonatomic,strong) UIImageView *onePhotoImageView;

@property (nonatomic,strong) UIImageView *twoPhotoImageViewOne;

@property (nonatomic,strong) UIImageView *twoPhotoImageViewTwo;

@property (nonatomic,strong) UIImageView *threePhotoImageViewOne;

@property (nonatomic,strong) UIImageView *threePhotoImageViewTwo;

@property (nonatomic,strong) UIImageView *threePhotoImageViewThree;

@property (nonatomic,strong) UIImageView *fourPhotoImageViewOne;

@property (nonatomic,strong) UIImageView *fourPhotoImageViewTwo;

@property (nonatomic,strong) UIImageView *fourPhotoImageViewThree;

@property (nonatomic,strong) UIImageView *fourPhotoImageViewFour;

@property (nonatomic,strong) UIView *textBGView;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UIImageView *addressImageView;

@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UILabel *numOfPhoto;

@end


@implementation OTWPersonalFootprintTableViewCell

static NSString *oneImageParams = @"?imageView2/1/w/160/h/160";

static NSString *twoImageParams = @"?imageView2/1/w/78/h/160";

static NSString *threeImageParams = @"?imageView2/1/w/78/h/78";


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView
{
    [self.contentView addSubview:self.sectionHeaderLeft];
    [self.contentView addSubview:self.sectionHeaderCil];
    self.sectionHeaderCil.hidden = YES;
    [self.contentView addSubview:self.leftContentLabel];
    [self.contentView addSubview:self.todayPhotoImageBGView];
    [self.contentView addSubview:self.onePhotoImageBGView];
    [self.contentView addSubview:self.twoPhotoImageBGView];
    [self.contentView addSubview:self.threePhotoImageBGView];
    [self.contentView addSubview:self.fourPhotoBGView];
    [self.contentView addSubview:self.textBGView];
    [self.textBGView addSubview:self.contentLabel];
    [self.textBGView addSubview:self.addressImageView];
    [self.textBGView addSubview:self.addressLabel];
    [self.contentView addSubview:self.numOfPhoto];
}

//设置表格数据
- (void) setData:(OTWPersonalFootprintFrame*) data
{
    self.sectionHeaderLeft.frame = data.cellLineF;
    self.sectionHeaderCil.hidden = YES;
    self.numOfPhoto.hidden = YES;
    //是否展示发布
    if(data.hasRelease){
        [self setTodayImage];
        self.leftContentLabel.text = data.leftContent;
        self.addressLabel.text = data.footprintDetal.footprintAddress;
        self.contentLabel.text = data.footprintDetal.footprintContent;
        self.addressImageView.hidden = YES;
    }else{
        self.addressImageView.hidden = NO;
        self.textBGView.frame = data.textBGViewF;
        self.contentLabel.frame = data.contentLabelF;
        self.addressImageView.frame = data.addressImageViewF;
        self.addressLabel.frame = data.addressLabelF;
        self.contentLabel.text = data.footprintDetal.footprintContent;
        self.addressLabel.text = data.footprintDetal.footprintAddress;
        if(data.hasPhoto){ //拥有photo
            if(data.footprintDetal.footprintPhotoArray.count == 1){
                [self setOneImage];
                [self.onePhotoImageView setImageWithURL:[NSURL URLWithString:[data.footprintDetal.footprintPhotoArray[0] stringByAppendingString:oneImageParams]]];
            }else if(data.footprintDetal.footprintPhotoArray.count == 2){
                self.numOfPhoto.hidden = NO;
                self.numOfPhoto.text =  [NSString stringWithFormat:@"%lu",(unsigned long)data.footprintDetal.footprintPhotoArray.count];
                [self setTwoImage];
                [self.twoPhotoImageViewOne setImageWithURL:[NSURL URLWithString:[data.footprintDetal.footprintPhotoArray[0] stringByAppendingString:twoImageParams]]];
                [self.twoPhotoImageViewTwo setImageWithURL:[NSURL URLWithString:[data.footprintDetal.footprintPhotoArray[1] stringByAppendingString:twoImageParams]]];
            }else if(data.footprintDetal.footprintPhotoArray.count == 3){
                self.numOfPhoto.hidden = NO;
                self.numOfPhoto.text =  [NSString stringWithFormat:@"%lu",(unsigned long)data.footprintDetal.footprintPhotoArray.count];
                [self setThreeImage];
                [self.threePhotoImageViewOne setImageWithURL:[NSURL URLWithString:[data.footprintDetal.footprintPhotoArray[0] stringByAppendingString:twoImageParams]]];
                [self.threePhotoImageViewTwo setImageWithURL:[NSURL URLWithString:[data.footprintDetal.footprintPhotoArray[1] stringByAppendingString:threeImageParams]]];
                [self.threePhotoImageViewThree setImageWithURL:[NSURL URLWithString:[data.footprintDetal.footprintPhotoArray[2] stringByAppendingString:threeImageParams]]];
            }else{
                self.numOfPhoto.hidden = NO;
                self.numOfPhoto.text =  [NSString stringWithFormat:@"%lu",(unsigned long)data.footprintDetal.footprintPhotoArray.count];
                [self setFourImage];
                [self.fourPhotoImageViewOne setImageWithURL:[NSURL URLWithString:[data.footprintDetal.footprintPhotoArray[0] stringByAppendingString:threeImageParams]]];
                [self.fourPhotoImageViewTwo setImageWithURL:[NSURL URLWithString:[data.footprintDetal.footprintPhotoArray[1] stringByAppendingString:threeImageParams]]];
                [self.fourPhotoImageViewThree setImageWithURL:[NSURL URLWithString:[data.footprintDetal.footprintPhotoArray[2] stringByAppendingString:threeImageParams]]];
                [self.fourPhotoImageViewFour setImageWithURL:[NSURL URLWithString:[data.footprintDetal.footprintPhotoArray[3] stringByAppendingString:threeImageParams]]];
            }
        }else{//隐藏photo
            self.onePhotoImageBGView.hidden = YES;
            self.twoPhotoImageBGView.hidden = YES;
            self.threePhotoImageBGView.hidden = YES;
            self.fourPhotoBGView.hidden = YES;
            self.todayPhotoImageBGView.hidden = YES;
        }
        if(data.leftContent){
            self.leftContentLabel.text = data.leftContent;
        }
    }
    if([data.leftContent isEqualToString:@"今天"]){
        self.sectionHeaderCil.hidden = NO;
        self.leftContentLabel.textColor = [UIColor color_202020];
        self.leftContentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    }else{
        self.leftContentLabel.textColor = [UIColor color_757575];
        self.leftContentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
}

-(void) setTodayImage
{
    self.onePhotoImageBGView.hidden = YES;
    self.twoPhotoImageBGView.hidden = YES;
    self.threePhotoImageBGView.hidden = YES;
    self.fourPhotoBGView.hidden = YES;
    self.todayPhotoImageBGView.hidden = NO;
}

- (void) setOneImage
{
    self.onePhotoImageBGView.hidden = NO;
    self.twoPhotoImageBGView.hidden = YES;
    self.threePhotoImageBGView.hidden = YES;
    self.fourPhotoBGView.hidden = YES;
    self.todayPhotoImageBGView.hidden = YES;
}

- (void) setTwoImage
{
    self.onePhotoImageBGView.hidden = YES;
    self.twoPhotoImageBGView.hidden = NO;
    self.threePhotoImageBGView.hidden = YES;
    self.fourPhotoBGView.hidden = YES;
    self.todayPhotoImageBGView.hidden = YES;
}

- (void) setThreeImage
{
    self.onePhotoImageBGView.hidden = YES;
    self.twoPhotoImageBGView.hidden = YES;
    self.threePhotoImageBGView.hidden = NO;
    self.fourPhotoBGView.hidden = YES;
    self.todayPhotoImageBGView.hidden = YES;
}

- (void) setFourImage
{
    self.onePhotoImageBGView.hidden = YES;
    self.twoPhotoImageBGView.hidden = YES;
    self.threePhotoImageBGView.hidden = YES;
    self.fourPhotoBGView.hidden = NO;
    self.todayPhotoImageBGView.hidden = YES;
}

- (UILabel *) sectionHeaderCil
{
    if(!_sectionHeaderCil){
        _sectionHeaderCil = [[UILabel alloc] initWithFrame:CGRectMake(20, 4.5, 6,6)];
        _sectionHeaderCil.backgroundColor=[UIColor color_e50834];
        _sectionHeaderCil.layer.cornerRadius = 3;
        _sectionHeaderCil.layer.masksToBounds = YES;
    }
    return _sectionHeaderCil;
}

- (UILabel *) sectionHeaderLeft
{
    if(!_sectionHeaderLeft){
        _sectionHeaderLeft=[[UILabel alloc] init];
        _sectionHeaderLeft.backgroundColor=[UIColor color_d5d5d5];
    }
    return _sectionHeaderLeft;
}

- (UILabel *) leftContentLabel
{
    if(!_leftContentLabel){
        _leftContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 36, 15)];
        _leftContentLabel.textColor = [UIColor color_757575];
        _leftContentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _leftContentLabel;
}

-(UIView *) todayPhotoImageBGView
{
    if(!_todayPhotoImageBGView){
        _todayPhotoImageBGView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 80, 80)];
        _todayPhotoImageBGView.backgroundColor = [UIColor color_ededed];
        [_todayPhotoImageBGView addSubview:self.todayPhotoImageView];
    }
    return _todayPhotoImageBGView;
}

- (UIImageView *) todayPhotoImageView
{
    if(!_todayPhotoImageView){
        _todayPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(21, 21.5, 40, 36.6)];
        _todayPhotoImageView.image = [UIImage imageNamed:@"wd_xiangji"];
    }
    return _todayPhotoImageView;
}

- (UIView *) onePhotoImageBGView
{
    if(!_onePhotoImageBGView){
        _onePhotoImageBGView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 80, 80)];
        [self.onePhotoImageBGView addSubview:self.onePhotoImageView];
    }
    return _onePhotoImageBGView;
}

- (UIView *) twoPhotoImageBGView
{
    if(!_twoPhotoImageBGView){
        _twoPhotoImageBGView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 80, 80)];
        [_twoPhotoImageBGView addSubview:self.twoPhotoImageViewOne];
        [_twoPhotoImageBGView addSubview:self.twoPhotoImageViewTwo];
    }
    return _twoPhotoImageBGView;
}

- (UIView *) threePhotoImageBGView
{
    if(!_threePhotoImageBGView){
        _threePhotoImageBGView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 80, 80)];
        [_threePhotoImageBGView addSubview:self.threePhotoImageViewOne];
        [_threePhotoImageBGView addSubview:self.threePhotoImageViewTwo];
        [_threePhotoImageBGView addSubview:self.threePhotoImageViewThree];
    }
    return _threePhotoImageBGView;
}

- (UIView *) fourPhotoBGView
{
    if(!_fourPhotoBGView){
        _fourPhotoBGView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 80, 80)];
        [_fourPhotoBGView addSubview:self.fourPhotoImageViewOne];
        [_fourPhotoBGView addSubview:self.fourPhotoImageViewTwo];
        [_fourPhotoBGView addSubview:self.fourPhotoImageViewThree];
        [_fourPhotoBGView addSubview:self.fourPhotoImageViewFour];
    }
    return _fourPhotoBGView;
}

- (UIImageView *) onePhotoImageView
{
    if(!_onePhotoImageView){
        _onePhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    }
    return _onePhotoImageView;
}

- (UIImageView *) twoPhotoImageViewOne
{
    if(!_twoPhotoImageViewOne){
        _twoPhotoImageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 80)];
    }
    return _twoPhotoImageViewOne;
}

- (UIImageView *) twoPhotoImageViewTwo
{
    if(!_twoPhotoImageViewTwo){
        _twoPhotoImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(self.twoPhotoImageViewOne.MaxX + 2, 0, 39, 80)];
    }
    return _twoPhotoImageViewTwo;
}

- (UIImageView *) threePhotoImageViewOne
{
    if(!_threePhotoImageViewOne){
        _threePhotoImageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 80)];
    }
    return _threePhotoImageViewOne;
}

- (UIImageView *) threePhotoImageViewTwo
{
    if(!_threePhotoImageViewTwo){
        _threePhotoImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(self.threePhotoImageViewOne.MaxX + 2, 0, 39, 39)];
    }
    return _threePhotoImageViewTwo;
}

- (UIImageView *) threePhotoImageViewThree
{
    if(!_threePhotoImageViewThree){
        _threePhotoImageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(self.threePhotoImageViewTwo.MinX, self.threePhotoImageViewTwo.MaxY + 2, 39, 39)];
    }
    return _threePhotoImageViewThree;
}


- (UIImageView *) fourPhotoImageViewOne
{
    if(!_fourPhotoImageViewOne){
        _fourPhotoImageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 39)];
    }
    return _fourPhotoImageViewOne;
}


- (UIImageView *) fourPhotoImageViewTwo
{
    if(!_fourPhotoImageViewTwo){
        _fourPhotoImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(self.fourPhotoImageViewOne.MaxX + 2, 0, 39, 39)];
    }
    return _fourPhotoImageViewTwo;
}


- (UIImageView *) fourPhotoImageViewThree
{
    if(!_fourPhotoImageViewThree){
        _fourPhotoImageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.fourPhotoImageViewOne.MaxY + 2, 39, 39)];
    }
    return _fourPhotoImageViewThree;
}


- (UIImageView *) fourPhotoImageViewFour
{
    if(!_fourPhotoImageViewFour){
        _fourPhotoImageViewFour = [[UIImageView alloc] initWithFrame:CGRectMake(self.fourPhotoImageViewThree.MaxX + 2, self.fourPhotoImageViewTwo.MaxY + 2 , 39, 39)];
    }
    return _fourPhotoImageViewFour;
}

//frame 将会动态设置
- (UIView *) textBGView
{
    if(!_textBGView){
        _textBGView = [[UIView alloc] init];
        [_textBGView addSubview:self.contentLabel];
    }
    return _textBGView;
}

//frame 将会动态设置
- (UILabel *) contentLabel
{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor color_202020];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIImageView *) addressImageView
{
    if(!_addressImageView){
        _addressImageView = [[UIImageView alloc] init];
        _addressImageView.image = [UIImage imageNamed:@"dinwgei_2"];
    }
    return _addressImageView;
}

- (UILabel *) addressLabel
{
    if(!_addressLabel){
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor color_979797];
        _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    }
    return _addressLabel;
}

- (UILabel *) numOfPhoto
{
    if(!_numOfPhoto){
        _numOfPhoto=[[UILabel alloc] initWithFrame:CGRectMake(142, 1, 17, 17)];
        _numOfPhoto.font=[UIFont systemFontOfSize:12];
        _numOfPhoto.textColor=[UIColor whiteColor];
        _numOfPhoto.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.6f];
        _numOfPhoto.textAlignment=NSTextAlignmentCenter;
        _numOfPhoto.layer.cornerRadius=17/2;
        _numOfPhoto.layer.masksToBounds = YES;
    }
    return _numOfPhoto;
}

@end
