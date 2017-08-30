//
//  CreateShopAddressCell.m
//  OnTheWay
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "CreateShopAddressCell.h"
#import "OTWFootprintsChangeAddressController.h"
#import "OTWFootprintChangeAddressArrayModel.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>

#define TFCellPadding_15 15
#define TFCellPadding_5 5
@interface CreateShopAddressCell()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UILabel *titleV;
@property (nonatomic,strong) UILabel *requireV;
@property (nonatomic,strong) UILabel *rightContentV;
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UINavigationController *mainControl;
@property (nonatomic,strong) OTWFootprintChangeAddressArrayModel *addressModel;

//定位信息相关
@property (nonatomic,strong) BMKLocationService *locService;  //定位
@property (nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic,copy) BMKUserLocation *userLocation;
@property (nonatomic,assign) BOOL ifFirstLocation;
@property (nonatomic,assign) BOOL refleshLocation;

@end

@implementation CreateShopAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    //设置cell背景色
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.titleV];
    [self addSubview:self.requireV];
    [self addSubview:self.rightContentV];
    
    //检查定位服务
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.ifFirstLocation = YES;
    self.refleshLocation = NO;
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self initCLLocationManager];
        //显示请打开定位服务
        self.rightContentV.text = @"点击打开定位服务";
        return;
    }
    
    [self initLocService];
    [self initGeoCodeSearch];
    [_locService startUserLocationService];
}

- (UILabel*)titleV
{
    if (!_titleV) {
        _titleV = [[UILabel alloc] init];
        [_titleV setFont:[UIFont systemFontOfSize:16]];
        [_titleV setBackgroundColor:[UIColor whiteColor]];
    }
    return _titleV;
}

- (UILabel*)requireV
{
    if (!_requireV) {
        _requireV = [[UILabel alloc] init];
        _requireV.text = @"*";
        [_requireV setFont:[UIFont systemFontOfSize:16]];
        _requireV.textColor = [UIColor redColor];
    }
    return _requireV;
}

- (UILabel*)rightContentV
{
    if (!_rightContentV) {
        _rightContentV = [[UILabel alloc] init];
        [_rightContentV setFont:[UIFont systemFontOfSize:14]];
        _rightContentV.textColor = [UIColor color_979797];
        _rightContentV.textAlignment = NSTextAlignmentRight;
        _rightContentV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapTecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapAction)];
        [_rightContentV addGestureRecognizer:tapTecognizer];
    }
    return _rightContentV;
}

- (UIImageView*)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 7, 12)];
        [_backImageView setImage:[UIImage imageNamed:@"arrow_right"]];
    }
    return _backImageView;
}

- (OTWFootprintChangeAddressArrayModel*)addressModel
{
    if (!_addressModel) {
        _addressModel = [[OTWFootprintChangeAddressArrayModel alloc] init];
    }
    return _addressModel;
}

+(CGFloat)cellHeight:(CreateShopModel *)createModel
{
    if (!createModel) {
        return 50.f;
    }
    return 50.f;
}

- (NSString*)decimalNumberWithDouble:(double)conversionValue
{
    DLog(@"转换值：%f",conversionValue);
    NSString *doubleStr = [NSString stringWithFormat:@"%lf\n",conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleStr];
    return [decNumber stringValue];
}

#pragma mark 清除cell值
- (void)clearCellData
{
    self.titleV.text = @"";
    self.rightContentV.text = @"";
}

#pragma mark 重置cell值
- (void)refreshContent:(CreateShopModel *)createModel formModel:(CreateShopFormModel *)formModel control:(UINavigationController *)control
{
    [self clearCellData];
    if (!createModel) {
        return;
    }
    _createShopModel = createModel;
    _formModel = formModel;
    self.mainControl = control;
    if (createModel.isRequire) {
        self.requireV.hidden = NO;
    } else {
        self.requireV.hidden = YES;
    }
    
    self.titleV.frame = CGRectMake(TFCellPadding_15, TFCellPadding_15, createModel.titileW, 20);
    self.titleV.text = createModel.title;
    
    CGFloat requireVX = CGRectGetMaxX(self.titleV.frame) + TFCellPadding_5;
    self.requireV.frame = CGRectMake(requireVX, 23.5, 8.5, 10);
    
    if (createModel.cellType == CreateSHopCellType_TV_BACK) {
        CGFloat rightContentVX = CGRectGetMaxX(self.requireV.frame) + TFCellPadding_15;
        CGFloat rightContentVW = SCREEN_WIDTH -  CGRectGetMaxX(self.requireV.frame) - TFCellPadding_15 * 2 - 13 - 12;
        _rightContentV.frame = CGRectMake(rightContentVX, TFCellPadding_15, rightContentVW, 20);
        [self setAccessoryView:self.backImageView];
    } else {
        CGFloat rightContentVX = CGRectGetMaxX(self.requireV.frame) + TFCellPadding_15;
        CGFloat rightContentVW = SCREEN_WIDTH -  CGRectGetMaxX(self.requireV.frame) - TFCellPadding_15 * 2;
        _rightContentV.frame = CGRectMake(rightContentVX, TFCellPadding_15, rightContentVW, 20);
    }
    
    if ([formModel valueForKey:createModel.key] && ![[formModel valueForKey:createModel.key] isEqualToString:@""]) {
        self.rightContentV.text = [formModel valueForKey:createModel.key];
    } else {
        self.rightContentV.text = createModel.placeholder;
    }
    
}

#pragma mark - 跳转定位地址选择界面
- (void) addressTapAction
{
    DLog(@"heh%@",@"sd");
    if(!self.ifFirstLocation){
        //跳转到定位界面
        OTWFootprintsChangeAddressController *changeAdAC = [[OTWFootprintsChangeAddressController alloc] init];
        [changeAdAC location:_userLocation.location.coordinate];
        [changeAdAC defaultChooseModel:_addressModel];
        changeAdAC.tapOne = ^(OTWFootprintChangeAddressArrayModel *chooseModel){
            _addressModel = chooseModel;
            self.rightContentV.text = _addressModel.address;
            [_formModel setValue:_addressModel.address forKey:_createShopModel.key];
            [_formModel setValue:[self decimalNumberWithDouble:_addressModel.longitude] forKey:@"longitude"];
            [_formModel setValue:[self decimalNumberWithDouble:_addressModel.latitude] forKey:@"latitude"];
        };
        [self.mainControl presentViewController:changeAdAC animated:YES completion:nil];
    }else{
        //判断是否开启定位服务
        if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            [self initCLLocationManager];
            //显示请打开定位服务
            self.rightContentV.text = @"点击打开定位服务";
            return;
        }else{
            //判断是否加载了locService
            if(!_locService){
                [self initLocService];
                [self initGeoCodeSearch];
                self.rightContentV.text = @"定位信息加载中~";
                [_locService startUserLocationService];
            }else if(_refleshLocation){ //重新执行定位，加载定位信息
                //                _geoCodeSearch.delegate = self;
                //                _geoCodeSearch = nil;
                //                [self initGeoCodeSearch];
                [_locService startUserLocationService];
                self.rightContentV.text = @"定位信息加载中~";
                _refleshLocation = NO;
            }else{
                
            }
        }
        DLog(@"定位信息加载失败");
    }
}

- (void)initCLLocationManager
{
    BOOL enable=[CLLocationManager locationServicesEnabled];
    NSInteger status=[CLLocationManager authorizationStatus];
    if(!enable || status<3)
    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
        {
            CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打开定位开关"
                                                            message:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"立即开启",@"好", nil];
        [alertView show];
        
    }
}

- (void) initLocService{
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void) initGeoCodeSearch{
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
}

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
            self.rightContentV.text = _addressModel.address;
            [_formModel setValue:_addressModel.address forKey:_createShopModel.key];
            [_formModel setValue:[self decimalNumberWithDouble:_addressModel.longitude] forKey:@"longitude"];
            [_formModel setValue:[self decimalNumberWithDouble:_addressModel.latitude] forKey:@"latitude"];
            self.ifFirstLocation = NO;
        }
    }else{
        self.rightContentV.text = @"定位信息加载失败，点击重试";
        self.refleshLocation = YES;
    }
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }
    [_locService stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    //定位信息加载错误，需要点击重试
    self.rightContentV.text = @"定位信息加载失败，点击重试";
    _refleshLocation = YES;
    
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


@end
