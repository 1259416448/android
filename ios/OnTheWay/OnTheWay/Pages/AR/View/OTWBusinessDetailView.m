//
//  OTWBusinessDetailView.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/9/3.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBusinessDetailView.h"
#import "PYPhotosView.h"
#import "OTWBusinessActivityTableViewCell.h"

#define businessNameFont [UIFont fontWithName:@"PingFangSC-Medium" size:16]

#define businessAddressFont [UIFont fontWithName:@"PingFangSC-Regular" size:14]

#define businessPhotoMargin 5


@interface OTWBusinessDetailView () <UITableViewDelegate,UITableViewDataSource,PYPhotosViewDelegate>

@property (nonatomic,strong) UITableView *businessActivityTableView;

//商家详情 名称、地址、联系方式、图片信息
@property (nonatomic,strong) UIView *tableViewHeaderBG;

//顶部的线
@property (nonatomic,strong) UIView *topLine;

//表头底部线
@property (nonatomic,strong) UIView *tableHeaderCenterLine;

//名称
@property (nonatomic,strong) UILabel *nameLabel;

//地址图标
@property (nonatomic,strong) UIImageView *addressImageView;

//地址名称信息
@property (nonatomic,strong) UILabel *addressLabel;

//联系方式图标
@property (nonatomic,strong) UIImageView *contactInfoImageView;

//联系方式信息
@property (nonatomic,strong) UILabel *contactInfoLabel;

//图片信息View
@property (nonatomic,strong) UIView *photoBGView;

//图片浏览信息
@property (nonatomic,strong) PYPhotosView *photosView;

//更多图片View，点击跳转至图集页
@property (nonatomic,strong) UIView *photoMoreView;

//所有图片
@property (nonatomic,strong) UILabel *sumLabel;

//签到、去这里等信息
@property (nonatomic,strong) UIView *tableViewFooterBG;

//去这里 view
@property (nonatomic,strong) UIView *goMapView;

//去这里图标
@property (nonatomic,strong) UIImageView *goMapImageView;

//去这里文字
@property (nonatomic,strong) UILabel *goMapLabel;

//底部中间线
@property (nonatomic,strong) UIView *centerLine;

//签到 view
@property (nonatomic,strong) UIView *checkInView;

//签到图标
@property (nonatomic,strong) UIImageView *checkInImageView;

//签到label
@property (nonatomic,strong) UILabel *checkInLabel;

//照片高度，需要动态计算
@property (nonatomic,assign) CGFloat photoH;

//照片宽度，需要动态计算
@property (nonatomic,assign) CGFloat photoW;


@end

@implementation OTWBusinessDetailView

static NSString *photoParamsOne = @"?imageView2/1/w/222/h/160";
static NSString *photoParamsTwo = @"?imageMogr2/thumbnail/!20p";

- (id) initWithBusinessDetailModel:(OTWBusinessModel *) businessModel
{
    self = [super init];
    if(self){
        self.businessModel = businessModel;
        [self buildUI];
    }
    return self;
}

#pragma mark - buildUI
- (void) buildUI
{
    
    [self addSubview:self.businessActivityTableView];
    self.businessActivityTableView.scrollEnabled = NO;
    
    [self.tableViewHeaderBG addSubview:self.topLine];
    [self.tableViewHeaderBG addSubview:self.nameLabel];
    [self.tableViewHeaderBG addSubview:self.addressImageView];
    [self.tableViewHeaderBG addSubview:self.addressLabel];
    [self.tableViewHeaderBG addSubview:self.contactInfoImageView];
    [self.tableViewHeaderBG addSubview:self.contactInfoLabel];
    [self.tableViewHeaderBG addSubview:self.photoBGView];
    if(self.businessModel.photoUrls && self.businessModel.photoUrls.count>0){
        [self.photoBGView addSubview:self.photosView];
        int sumPhotoNum = self.businessModel.businessPhotoNum + self.businessModel.userPhotoNum;
        if(sumPhotoNum>3){
            [self.photoBGView addSubview:self.photoMoreView];
        }
    }
    //如果活动存在，添加表头底部线
    [self.tableViewHeaderBG addSubview:self.tableHeaderCenterLine];
    
    [self.tableViewFooterBG addSubview:self.goMapView];
    [self.goMapView addSubview:self.goMapImageView];
    [self.goMapView addSubview:self.goMapLabel];
    [self.tableViewFooterBG addSubview:self.centerLine];
    [self.tableViewFooterBG addSubview:self.checkInView];
    [self.checkInView addSubview:self.checkInImageView];
    [self.checkInView addSubview:self.checkInLabel];
    
    [self buildFrame];
    [self setData];
    
    self.businessActivityTableView.tableHeaderView = self.tableViewHeaderBG;
    self.businessActivityTableView.tableFooterView = self.tableViewFooterBG;
    
}

#pragma mark - 设置整理frame
- (void) buildFrame
{
    //设置frame是有先后顺序，不能打乱顺序
    
    self.topLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    
    CGFloat tableViewHeaderH = 0;
    
    //一般情况距离上一个内容的距离
    CGFloat topPadding = 10;
    //为了能完全显示名字，需要动态计算高度
    CGSize nameSize = [self nameSize];
    self.nameLabel.frame = CGRectMake(GLOBAL_PADDING, GLOBAL_PADDING, nameSize.width , nameSize.height);
    self.addressImageView.frame = CGRectMake(GLOBAL_PADDING, self.nameLabel.MaxY + 13.5, 13, 13);
    //为了能完全显示名字，需要动态计算高度
    CGSize addressSize = [self addressSize];
    self.addressLabel.frame = CGRectMake(self.addressImageView.MaxX + 5, self.nameLabel.MaxY + topPadding, addressSize.width, addressSize.height);
    tableViewHeaderH = self.addressLabel.MaxY;
    
    if(self.businessModel.contactInfo && self.businessModel.contactInfo.length > 0){
        self.contactInfoImageView.frame = CGRectMake(GLOBAL_PADDING, self.addressLabel.MaxY + 9.5, 13, 13);
        self.contactInfoLabel.frame = CGRectMake(self.contactInfoImageView.MaxX + 5, self.addressLabel.MaxY + 5, SCREEN_WIDTH - self.contactInfoImageView.MaxX - 5 , 20);
        tableViewHeaderH = self.contactInfoLabel.MaxY;
    }

    //设置照片，如果照片数据 == 0 设置为隐藏
    if(!self.businessModel.photoUrls || self.businessModel.photoUrls.count==0){
        self.photoBGView.hidden = YES;
    }else{
        self.photoBGView.frame = CGRectMake(GLOBAL_PADDING, tableViewHeaderH + topPadding, SCREEN_WIDTH - GLOBAL_PADDING * 2, self.photoH);
        //判断照片数量，如果照片总数大于3，会跳转到相册页，photoUrls后端返回的数据优先商家照片，如果商家照片不存在，仅存在用户图集，则返回用户图集
        //照片数量 > 3 点击照片最后一张图片 跳转 图集查看页
        int sumPhotoNum = self.businessModel.businessPhotoNum + self.businessModel.userPhotoNum;
        if(sumPhotoNum>3){
            self.photoMoreView.frame = CGRectMake(self.photoBGView.Witdh - self.photoW, 0 , self.photoW, self.photoH);
            self.sumLabel.frame = self.photoMoreView.bounds;
        }
        tableViewHeaderH = self.photoBGView.MaxY;
    }
    
    tableViewHeaderH += GLOBAL_PADDING;
    
    self.tableViewHeaderBG.frame = CGRectMake(0, 0, SCREEN_WIDTH, tableViewHeaderH);
    
    self.tableViewFooterBG.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    CGFloat goMapViewW = 10 + self.goMapLabel.Witdh + 20;
    CGFloat goMapViewX = (((SCREEN_WIDTH - 1 )/2) - goMapViewW)/2;
    self.goMapView.frame = CGRectMake(goMapViewX, 0, goMapViewW , 44);
    self.goMapImageView.frame = CGRectMake(0, 12, 20, 20);
    self.goMapLabel.frame = CGRectMake(self.goMapImageView.MaxX + 10, 14.5, self.goMapLabel.Witdh, 15);
    self.centerLine.frame = CGRectMake(SCREEN_WIDTH / 2, 0, 0.6, 44);
    
    CGFloat checkInViewW = 10 + self.checkInLabel.Witdh + 20  ;
    CGFloat checkInViewX = (SCREEN_WIDTH - 1) / 2 + (((SCREEN_WIDTH - 1 )/2) - checkInViewW )/2;
    self.checkInView.frame = CGRectMake(checkInViewX, 0, checkInViewW, 44);
    self.checkInImageView.frame = CGRectMake(0, 12, 20, 20);
    self.checkInLabel.frame = CGRectMake(self.checkInImageView.MaxX + 10, 14.5, self.checkInLabel.Witdh, 15);
    //设置tableView高度
    NSUInteger activityCount = self.businessModel.activitys ? self.businessModel.activitys.count : 0;
    if(activityCount >0 ){
        self.tableHeaderCenterLine.frame = CGRectMake(0, tableViewHeaderH - 0.5, SCREEN_WIDTH, 0.5);
    }
    
    CGFloat tableViewH = self.tableViewHeaderBG.Height + self.tableViewFooterBG.Height + activityCount * 40;
    self.businessActivityTableView.frame = CGRectMake(0, 10, SCREEN_WIDTH, tableViewH);
    // + 10 是因为 businessActivityTableView 距离顶部 10
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, tableViewH + 10);
}

#pragma mark - 设置整理数据
- (void) setData
{
    self.nameLabel.text = self.businessModel.name;
    self.addressLabel.text = self.businessModel.address;
    self.contactInfoLabel.text = self.businessModel.contactInfo;
    int sumPhotoNum = self.businessModel.businessPhotoNum + self.businessModel.userPhotoNum;
    if(sumPhotoNum >3){
        self.sumLabel.text = [@"+" stringByAppendingFormat:@"%d",sumPhotoNum];
    }
    [self changeCheckInStatus];
}

#pragma mark - UITableViewDelegate
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!self.businessModel.activitys) return 0;
    return self.businessModel.activitys.count;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self.delegate && [self.delegate respondsToSelector:@selector(businessTableView:didSelectRowAtIndexPath:)]){
        [self.delegate businessTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BusinessActivityCell";
    OTWBusinessActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [OTWBusinessActivityTableViewCell cellWithTableView:tableView identifier:identifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    OTWBusinessActivityModel *activityModel = self.businessModel.activitys[indexPath.row];
    [cell setDate:activityModel.name typeName:activityModel.typeName typeColor:[UIColor colorWithHexString:activityModel.colorStr] isLast:indexPath.row == self.businessModel.activitys.count - 1];
    return cell;
}

#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

/**
 * 名称Size
 */
- (CGSize) nameSize
{
    CGSize nameSize = [OTWUtils sizeWithString:self.businessModel.name font:businessNameFont maxSize:CGSizeMake(SCREEN_WIDTH - GLOBAL_PADDING *2, 80)];
    return nameSize;
}

/**
 * 地址Size
 */
- (CGSize) addressSize
{
    CGSize addressSize = [OTWUtils sizeWithString:self.businessModel.address font:businessAddressFont maxSize:CGSizeMake(SCREEN_WIDTH - self.addressImageView.MaxX - 5 - GLOBAL_PADDING, 80)];
    return addressSize;
}

/**
 * 改变签到状态
 */

- (void) changeCheckInStatus
{
    if(self.businessModel.ifCheckIn){
        self.checkInImageView.image = [UIImage imageNamed:@"ar_qiandao_click"];
        self.checkInLabel.textColor = [UIColor color_e50834];
    }else{
        self.checkInImageView.image = [UIImage imageNamed:@"ar_qiandao"];
        self.checkInLabel.textColor = [UIColor color_979797];
    }
}

/**
 * 动态计算照片高度
 */
-(CGFloat)photoH
{
    if(!_photoH || _photoH == 0){
        // 80/111 展示的相片宽高比
        _photoH = self.photoW  *80 /111;
    }
    return _photoH;
}

- (CGFloat) photoW
{
    if(!_photoW || _photoW == 0){
        // 6 每个照片之间的间距 3 最多3张照片
        _photoW = (SCREEN_WIDTH-GLOBAL_PADDING * 2 - businessPhotoMargin * 2 ) /3;
    }
    return _photoW;
}

#pragma mark - Setter Getter
- (UITableView *) businessActivityTableView
{
    if(!_businessActivityTableView){
        _businessActivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        _businessActivityTableView.delegate = self;
        _businessActivityTableView.dataSource = self;
        _businessActivityTableView.backgroundColor = [UIColor clearColor];
        _businessActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _businessActivityTableView;
}

- (UIView *) tableViewHeaderBG
{
    if(!_tableViewHeaderBG){
        _tableViewHeaderBG = [[UIView alloc] init];
//        _tableViewHeaderBG.layer.borderColor = [UIColor color_d5d5d5].CGColor;
//        _tableViewHeaderBG.layer.borderWidth = 0.5;
        _tableViewHeaderBG.backgroundColor = [UIColor whiteColor];
    }
    return _tableViewHeaderBG;
}

- (UIView *)topLine
{
    if(!_topLine){
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor color_d5d5d5];
    }
    return _topLine;
}

- (UIView *)tableHeaderCenterLine
{
    if(!_tableHeaderCenterLine){
        _tableHeaderCenterLine = [[UIView alloc] init];
        _tableHeaderCenterLine.backgroundColor = [UIColor color_d5d5d5];
    }
    return _tableHeaderCenterLine;
}

- (UILabel *) nameLabel
{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = businessNameFont;
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = [UIColor color_202020];
    }
    return _nameLabel;
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
        _addressLabel.font = businessAddressFont;
        _addressLabel.textColor = [UIColor color_7d7d7d];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (UIImageView *) contactInfoImageView
{
    if(!_contactInfoImageView){
        _contactInfoImageView = [[UIImageView alloc] init];
        _contactInfoImageView.image = [UIImage imageNamed:@"dianhua"];
    }
    return _contactInfoImageView;
}

- (UILabel *) contactInfoLabel
{
    if(!_contactInfoLabel){
        _contactInfoLabel = [[UILabel alloc] init];
        _contactInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _contactInfoLabel.textColor = [UIColor color_7d7d7d];
    }
    return _contactInfoLabel;
}

-(UIView *) photoBGView
{
    if(!_photoBGView){
        _photoBGView = [[UIView alloc] init];
    }
    return _photoBGView;
}

-(PYPhotosView *) photosView
{
    if(!_photosView){
        // 1. 创建缩略图图片链接数组
        NSMutableArray *thumbnailImageUrls = [NSMutableArray array];
        // 2 创建原图图片链接数组
        NSMutableArray *originalImageUrls = [NSMutableArray array];
        int i = 0;
        for (NSString *one in self.businessModel.photoUrls) {
            [thumbnailImageUrls addObject:[one stringByAppendingString:photoParamsTwo]];
            //增加了参数处理
            //[originalImageUrls addObject:[one stringByAppendingString:photoParamsTwo]];
            [originalImageUrls addObject:one];
            i ++;
            if(i == 3) break;
        }
        _photosView = [PYPhotosView photosViewWithThumbnailUrls:thumbnailImageUrls originalUrls:originalImageUrls];
        _photosView.py_x = 0;
        _photosView.py_y = 0;
        _photosView.photoWidth = self.photoW;
        _photosView.photoHeight = self.photoH;
        _photosView.photoMargin = businessPhotoMargin;
        _photosView.delegate = self;
    }
    return _photosView;
}

- (UIView *) photoMoreView
{
    if(!_photoMoreView){
        _photoMoreView = [[UIView alloc] init];
        _photoMoreView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_photoMoreView addSubview:self.sumLabel];
        //增加点击事件
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreViewClick)];
        [_photoMoreView addGestureRecognizer:recognizer];
    }
    return _photoMoreView;
}

- (UILabel *) sumLabel
{
    if(!_sumLabel){
        _sumLabel = [[UILabel alloc] init];
        _sumLabel.textAlignment = NSTextAlignmentCenter;
        _sumLabel.textColor = [UIColor whiteColor];
        _sumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _sumLabel;
}

- (UIView *) tableViewFooterBG
{
    if(!_tableViewFooterBG){
        _tableViewFooterBG = [[UIView alloc] init];
        _tableViewFooterBG.backgroundColor = [UIColor color_fbfbfb];
        //_tableViewFooterBG.layer.borderWidth = 0.6;
        //_tableViewFooterBG.layer.borderColor = [UIColor color_d5d5d5].CGColor;
        UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        lineOne.backgroundColor = [UIColor color_d5d5d5];
        UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        lineTwo.backgroundColor = [UIColor color_d5d5d5];
        [_tableViewFooterBG addSubview:lineOne];
        [_tableViewFooterBG addSubview:lineTwo];
        
    }
    return _tableViewFooterBG;
}

- (UIView *) goMapView
{
    if(!_goMapView){
        _goMapView = [[UIView alloc] init];
        UITapGestureRecognizer  *tapGesturRing=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goMapClick)];
        [_goMapView addGestureRecognizer:tapGesturRing];
    }
    return _goMapView;
}

- (UIImageView *) goMapImageView
{
    if(!_goMapImageView){
        _goMapImageView = [[UIImageView alloc] init];
        _goMapImageView.image = [UIImage imageNamed:@"daohang"];
    }
    return _goMapImageView;
}

- (UILabel *) goMapLabel
{
    if(!_goMapLabel){
        _goMapLabel = [[UILabel alloc] init];
        _goMapLabel.text = @"到这里";
        _goMapLabel.textColor = [UIColor color_979797];
        _goMapLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_goMapLabel sizeToFit];
    }
    return _goMapLabel;
}

- (UIView *) centerLine
{
    if(!_centerLine){
        _centerLine = [[UIView alloc] init];
        _centerLine.backgroundColor=[UIColor color_d5d5d5];
    }
    return _centerLine;
}

- (UIView *) checkInView
{
    if(!_checkInView){
        _checkInView = [[UIView alloc] init];
        UITapGestureRecognizer  *tapGesturRing=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkInClick)];
        [_checkInView addGestureRecognizer:tapGesturRing];

    }
    return _checkInView;
}

- (UIView *) checkInImageView
{
    if(!_checkInImageView){
        _checkInImageView = [[UIImageView alloc] init];
        _checkInImageView.image = [UIImage imageNamed:@"ar_qiandao"];
    }
    return _checkInImageView;
}

- (UILabel *) checkInLabel
{
    if(!_checkInLabel){
        _checkInLabel = [[UILabel alloc] init];
        _checkInLabel.text = @"签到";
        _checkInLabel.textColor = [UIColor color_979797];
        _checkInLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_checkInLabel sizeToFit];
    }
    return _checkInLabel;
}

#pragma mark - more click
- (void) moreViewClick
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(morePhotoClick:businessModel:) ]){
        [self.delegate morePhotoClick:self businessModel:self.businessModel];
    }
}

#pragma mark - goMapClick
- (void) goMapClick
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(goMapClick:businessModel:)]){
        [self.delegate goMapClick:self businessModel:self.businessModel];
    }
}

#pragma mark - checkInClick
- (void) checkInClick
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkInClick:businessModel:)]){
        [self.delegate checkInClick:self businessModel:self.businessModel];
    }
}
@end
