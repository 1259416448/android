//
//  OTWFootprintReleaseViewController.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintReleaseViewController.h"
#import "OTWCustomNavigationBar.h"
#import <IQKeyboardManager.h>
#import "PYPhotosView.h"
#import "OTWAlbumSelectHelper.h"
#import <TZImagePickerController.h>
#import <TZImageManager.h>
#import "OTWUITapGestureRecognizer.h"
#import "OTWFootprintsChangeAddressController.h"
#import "QiniuUploadService.h"
#import "OTWFootprintService.h"

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>
#import <MJExtension.h>


@interface OTWFootprintReleaseViewController () <UITextViewDelegate,PYPhotosViewDelegate,TZImagePickerControllerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,strong) UIView *customRightNavigationBarView;

@property (nonatomic,strong) UIView *footprintContentView;

@property (nonatomic,strong) UILabel *footprintContentTips;

@property (nonatomic,strong) UITextView *footprintTextView;

@property (nonatomic,strong) UIView *centerLine;

@property (nonatomic,strong) UIView *photoChooseView;

@property (nonatomic,weak) PYPhotosView *publishPhotosView;

@property (nonatomic,assign) CGFloat photoW;

@property (nonatomic,strong) UIView *addressChooseView;

@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) UILabel *addressLabel;

//定位信息相关
@property (nonatomic,strong) BMKLocationService *locService;  //定位
@property (nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic,copy) BMKUserLocation *userLocation;

@property (nonatomic,assign) BOOL ifFirstLocation;


//需要提交的相关数据
@property (nonatomic,copy) OTWFootprintChangeAddressArrayModel *addressModel;


@end

@implementation OTWFootprintReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    [_locService startUserLocationService];
    
    _ifFirstLocation = YES;
    
    [self bulidUI];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _geoCodeSearch.delegate = nil;
    _locService.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) bulidUI
{
    self.title = @"发布足迹";
    self.view.backgroundColor=[UIColor color_f4f4f4];
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    [self setCustomNavigationRightView:self.customRightNavigationBarView];
    //文本框
    [self.footprintContentView addSubview:self.footprintTextView];
    [self.footprintContentView addSubview:self.footprintContentTips];
    [self.footprintContentView addSubview:self.centerLine];
    [self.view addSubview:self.photoChooseView];
    //
    PYPhotosView *publishPhotosView = [PYPhotosView photosView];
    NSMutableArray *imagesM = [NSMutableArray array];
    publishPhotosView.images = imagesM;
    publishPhotosView.py_x = 15;
    publishPhotosView.py_y = 15;
    publishPhotosView.photoWidth = self.photoW;
    publishPhotosView.photoHeight = self.photoW;
    publishPhotosView.photosMaxCol = 4;
    publishPhotosView.photoMargin = 10;
    publishPhotosView.delegate = self;
    publishPhotosView.hideDeleteView = YES;
    [self.photoChooseView addSubview:publishPhotosView];
    self.publishPhotosView = publishPhotosView;
    
    [self.view addSubview:self.addressChooseView];
    [self.addressChooseView addSubview:self.addressLabel];
    
    [self.view bringSubviewToFront:self.customNavigationBar];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:recognizer];
    
}

- (UIView *) footprintContentView
{
    if(!_footprintContentView){
        _footprintContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, 150)];
        _footprintContentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_footprintContentView];
    }
    return _footprintContentView;
}

- (UIView *) footprintContentTips
{
    if(!_footprintContentTips){
        _footprintContentTips = [[UILabel alloc] initWithFrame:CGRectMake(22.5, 15, 210, 25)];
        _footprintContentTips.text=@"把你此刻的心情分享给大家吧~";
        _footprintContentTips.textColor = [UIColor color_757575];
        _footprintContentTips.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _footprintContentTips;
}

- (UIView *) customRightNavigationBarView
{
    if(!_customRightNavigationBarView){
        _customRightNavigationBarView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-32, 30, 34, 22.5)];
        _customRightNavigationBarView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 34, 22.5)];
        titleLabel.text = @"发布";
        titleLabel.textColor = [UIColor color_202020];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [_customRightNavigationBarView addSubview:titleLabel];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footprintReleaseTap)];
        [_customRightNavigationBarView addGestureRecognizer:tapGesturRecognizer];
    }
    return _customRightNavigationBarView;
}

- (UITextView *) footprintTextView
{
    if(!_footprintTextView){
        _footprintTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.footprintContentTips.MinX, self.footprintContentTips.MinY, SCREEN_WIDTH - self.footprintContentTips.MinX * 2,150 - 30)];
        _footprintTextView.textColor = [UIColor color_202020];
        _footprintTextView.font = [UIFont systemFontOfSize:15];
        _footprintTextView.delegate = self;
        _footprintTextView.textContainerInset = UIEdgeInsetsMake(0,0, 0, 0);
        _footprintTextView.layoutManager.allowsNonContiguousLayout = NO;
        _footprintTextView.textAlignment = NSTextAlignmentLeft;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _footprintTextView;
}

- (UIView *) centerLine
{
    if(!_centerLine){
        _centerLine = [[UIView alloc] initWithFrame:CGRectMake(15, self.footprintContentView.Height-1, CGRectGetWidth(self.view.frame), 1)];
        _centerLine.backgroundColor = [UIColor color_f4f4f4];
    }
    return _centerLine;
}

- (UIView *) bottomLine
{
    if(!_bottomLine){
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) , 1)];
        _bottomLine.backgroundColor = [UIColor color_f4f4f4];
    }
    return _bottomLine;
}

- (UIView *) photoChooseView
{
    if(!_photoChooseView){
        _photoChooseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.footprintContentView.MaxY, CGRectGetWidth(self.view.frame), self.photoW + 15 * 2)];
        _photoChooseView.backgroundColor = [UIColor whiteColor];
    }
    return _photoChooseView;
}

- (CGFloat) photoW
{
    if(!_photoW || _photoW == 0){
        _photoW = (SCREEN_WIDTH - 15 * 2 - 10 *3 )/4;
    }
    return _photoW;
}

- (UIView *) addressChooseView
{
    if(!_addressChooseView){
        _addressChooseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.photoChooseView.MaxY, CGRectGetWidth(self.view.frame), 42)];
        _addressChooseView.backgroundColor = [UIColor whiteColor];
        [_addressChooseView addSubview:self.bottomLine];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 9.8, 9.8)];
        imageView.image = [UIImage imageNamed:@"dinwgei_2"];
        [_addressChooseView addSubview:imageView];
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 15 - 12, 15, 7, 12)];
        imageView2.image = [UIImage imageNamed:@"arrow_right"];
        [_addressChooseView addSubview:imageView2];
        UITapGestureRecognizer *tapTecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapAction)];
        [_addressChooseView addGestureRecognizer:tapTecognizer];
    }
    return _addressChooseView;
}

- (UILabel *) addressLabel
{
    if(!_addressLabel){
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + 9.8 + 5, 15, CGRectGetWidth(self.view.frame) - (15 + 9.8 + 5 + 7 + 15 + 15 ) , 12)];
        _addressLabel.textColor = [UIColor color_979797];
        _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        //定位地址在用户进入app时就会获取
        _addressLabel.text = @"定位信息加载中~";
    }
    return _addressLabel;
}


#pragma mark - 跳转定位地址选择界面
- (void) addressTapAction
{
    if(!_ifFirstLocation){
        //跳转到定位界面
        OTWFootprintsChangeAddressController *changeAdAC = [[OTWFootprintsChangeAddressController alloc] init];
        [changeAdAC location:_userLocation.location.coordinate];
        [changeAdAC defaultChooseModel:_addressModel];
        changeAdAC.tapOne = ^(OTWFootprintChangeAddressArrayModel *chooseModel){
            _addressModel = chooseModel;
            self.addressLabel.text = _addressModel.address;
        };
        [self presentViewController:changeAdAC animated:YES completion:nil];
    }else{
        DLog(@"定位信息加载失败");
    }
}

#pragma mark - 右侧按钮点击

- (void) footprintReleaseTap
{
    DLog(@"点击发布");
    //0 验证内容是否填写与定位信息是否加载成功
    NSString *content = self.footprintTextView.text;
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if(content.length == 0){
        DLog(@"输入内容为空！");
        [self errorTips:@"请输入文字信息" userInteractionEnabled:NO];
        return ;
    }
    
    if(self.addressModel == nil){
        DLog(@"定位信息获取失败");
        [self errorTips:@"定位信息获取失败，请重试" userInteractionEnabled:NO];
        return ;
    }
    NSDictionary *footprint = [NSDictionary dictionaryWithObjectsAndKeys:self.addressModel.address,@"address",[self.footprintTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"content",[NSNumber numberWithDouble:self.addressModel.latitude],@"latitude",[NSNumber numberWithDouble:self.addressModel.longitude],@"longitude",nil];
    //1、首先上传图片
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.activityIndicatorColor = [UIColor whiteColor];
    if(self.publishPhotosView.images.count > 0){
        //显示正在上传提示
        hud.label.text = @"正在上传图片";
        [QiniuUploadService uploadImages:self.publishPhotosView.images progress:^(CGFloat progress){
            DLog(@"已成功上传了 progress %f",progress);
        }success:^(NSArray<OTWDocument *> *documents){
            hud.label.text = @"正在发布";
            //2、图片上传成功后，发布足迹到API服务器
            NSArray *documentsDict = [OTWDocument mj_keyValuesArrayWithObjectArray:documents];
            NSDictionary *requestBody = [NSDictionary dictionaryWithObjectsAndKeys:footprint,@"footprint",documentsDict,@"documents", nil];
            DLog(@"requestBody %@",requestBody);
            [self subReleaseData:requestBody hud:hud];
        }failure:^(){
            DLog(@"图片上传失败");
            [hud hideAnimated:YES];
            [self errorTips:@"发布失败，请检查您的网络是否连接" userInteractionEnabled:YES];
        }];
    }else{ //2、直接发布
        hud.label.text = @"正在发布";
        NSDictionary *requestBody = [NSDictionary dictionaryWithObjectsAndKeys:footprint,@"footprint", nil];
        DLog(@"requestBody %@",requestBody);
        [self subReleaseData:requestBody hud:hud];
    }
}

- (void) subReleaseData:(NSDictionary *)requestBody hud:(MBProgressHUD *)hud
{
    [OTWFootprintService footprintRelease:requestBody completion:^(id result,NSError *error){
        if(result){
            [hud hideAnimated:YES];
            if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
                [self errorTips:@"发布成功" userInteractionEnabled:NO];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),2.0*NSEC_PER_SEC, 0); //2秒后执行
                dispatch_source_set_event_handler(_timer, ^{
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                });
                dispatch_resume(_timer);
            }else{
                DLog(@"message - %@  messageCode - %@",result[@"message"],result[@"messageCode"]);
                [self errorTips:@"发布失败，请检查您的网络是否连接" userInteractionEnabled:YES];
            }
        }else{
            [self netWorkErrorTips:error];
        }
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.footprintContentTips.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length == 0){
        self.footprintContentTips.hidden = NO;
    }
}

#pragma mark - PYPhotosViewDelegate
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-images.count delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto) {
        if(isSelectOriginalPhoto){
            for (NSObject *asset in assets) {
                [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *image,NSDictionary *info){
                    [images addObject:image];
                    [photosView reloadDataWithImages:images];
                }];
            }
        }else{
            for (UIImage *one in photos) {
                [images  addObject:one];
            }
        }
        [photosView reloadDataWithImages:images];
        //计算高度
        CGFloat photoChooseH = self.photoW + 15 * 2;
        if(images.count >= 4){
            photoChooseH = ( images.count / 4 + 1 ) * (self.photoW + 10) + 15 * 2 - 10;
        }
        _photoChooseView.frame = CGRectMake(0, self.footprintContentView.MaxY, CGRectGetWidth(self.view.frame), photoChooseH);
        _addressChooseView.frame = CGRectMake(0, self.photoChooseView.MaxY, self.photoChooseView.Witdh, 42);
        [self layoutView];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 * 构建删除按钮,根据当前图片构建
 */
- (void) layoutView
{
    for (UIView *one in _photoChooseView.subviews) {
        if(![one isKindOfClass:[PYPhotosView class]]){
            [one removeFromSuperview];
        }
    }
    NSMutableArray *images = _publishPhotosView.images;
    if(images.count > 0){
        for (int i = 1; i<images.count+1; i++) {
            int xCount = i%4;
            CGFloat x = 0;
            if(xCount == 0){
                xCount = 4;
            }
            x = (xCount - 1) * _publishPhotosView.photoMargin + xCount *_publishPhotosView.photoWidth + _publishPhotosView.py_x - 7.5;
            CGFloat y = 0;
            int yCount = i/4 + 1;
            if(i%4==0){
                yCount = yCount - 1;
            }
            y = (yCount - 1) * _publishPhotosView.photoMargin + (yCount - 1) *_publishPhotosView.photoHeight + _publishPhotosView.py_y - 7.5;
            //生成图片
            [_photoChooseView addSubview:[self buildDeleteView:x y:y index:(i - 1)]];
        }
    }
}

- (UIView *) buildDeleteView:(CGFloat) x y:(CGFloat)y index:(int)index
{
    UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 16 , 16)];
    deleteImageView.image = [UIImage imageNamed:@"fb_delete"];
    OTWUITapGestureRecognizer *tapRecognizer = [[OTWUITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
    deleteImageView.userInteractionEnabled = YES;
    tapRecognizer.opId = [NSString stringWithFormat:@"%d",index];
    [deleteImageView addGestureRecognizer:tapRecognizer];
    deleteImageView.tag = index;
    return deleteImageView;
}

- (void) deleteImage:(UITapGestureRecognizer *) tapRecognizer
{
    OTWUITapGestureRecognizer *tap =(OTWUITapGestureRecognizer *)tapRecognizer;
    int index = [tap.opId intValue];
    [_publishPhotosView.images removeObjectAtIndex:index];
    [_publishPhotosView reloadDataWithImages:_publishPhotosView.images];
    [self layoutView];
    [self photosView:_publishPhotosView didDeleteImageIndex:index];
}

// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr
{
    NSLog(@"进入预览图片");
}

/**
 * 删除图片按钮触发时调用此方法
 * imageIndex : 删除的图片在之前图片数组的位置
 */
- (void)photosView:(PYPhotosView *)photosView didDeleteImageIndex:(NSInteger)imageIndex
{
    CGFloat photoChooseH = self.photoW + 15 * 2;
    if(photosView.images.count >= 4){
        photoChooseH = ( photosView.images.count / 4 + 1 ) * (self.photoW + 10) + 15 * 2 - 10;
    }
    _photoChooseView.frame = CGRectMake(0, self.footprintContentView.MaxY, CGRectGetWidth(self.view.frame), photoChooseH);
    _addressChooseView.frame = CGRectMake(0, self.photoChooseView.MaxY, self.photoChooseView.Witdh, 42);
    [self layoutView];
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    DLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
        _userLocation = userLocation;
        [_locService stopUserLocationService];
    }else{
        NSLog(@"反geo检索发送失败");
    }
}


- (void)didFailToLocateUserWithError:(NSError *)error
{
    DLog(@"error :%@",error);
}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error ==BMK_SEARCH_NO_ERROR){
        if(result.poiList.count>0){
            OTWFootprintChangeAddressArrayModel *model = [[OTWFootprintChangeAddressArrayModel alloc] init];
            BMKPoiInfo *poiInfo = ((BMKPoiInfo *)result.poiList[0]);
            model.latitude = poiInfo.pt.latitude;
            model.longitude = poiInfo.pt.longitude;
            model.name = poiInfo.name;
            model.address = poiInfo.address;
            model.uuid = poiInfo.uid;
            _addressModel = model;
            self.addressLabel.text = _addressModel.address;
            _ifFirstLocation = NO;
        }
    }
}

#pragma mark - 下滑动关闭键盘
- (void) handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown){
        [self.footprintTextView resignFirstResponder];
    }
}

@end
