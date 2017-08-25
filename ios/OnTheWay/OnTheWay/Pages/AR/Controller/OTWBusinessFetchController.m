//
//  OTWBusinessFetchController.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/24.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//


//只用于抓取数据
#import "OTWBusinessFetchController.h"
#import "OTWBusinessFetchModel.h"

#import <MJExtension.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface OTWBusinessFetchController() <BMKLocationServiceDelegate,BMKPoiSearchDelegate>

@property (nonatomic,strong) BMKLocationService *locService;

@property (nonatomic,strong) BMKPoiSearch *poiSearch;

@property (nonatomic,strong) UILabel *typeIdLabel;

@property (nonatomic,strong) UILabel *keyLabel;

@property (nonatomic,strong) UITextField *typeIdTextField;

@property (nonatomic,strong) UITextField *keyTextField;

@property (nonatomic,strong) UILabel *latitudeLabel;

@property (nonatomic,strong) UILabel *longitudeLabel;

@property (nonatomic,strong) UITextField *latitudeTextField;

@property (nonatomic,strong) UITextField *longitudeTextField;

@property (nonatomic,strong) UILabel *tipsLabel;

@property (nonatomic,strong) UIButton *subButton;

@property (nonatomic,assign) int currentPage;

@property (nonatomic,assign) CLLocationCoordinate2D location;

@property (nonatomic,assign) int searchTotalElement;

@property (nonatomic,assign) int totalPoiElement;

@property (nonatomic,assign) int successElement;

@property (nonatomic,assign) int failedElement;

@property (nonatomic,strong) NSString *tipsStr;

@property (nonatomic,strong) NSArray *typeIds;

@property (nonatomic,strong) NSMutableArray<BMKPoiInfo *> *poiInfoArray;

@property (nonatomic,assign) int fetchNum;

@end


@implementation OTWBusinessFetchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.locService startUserLocationService];
    
    [self buildUI];
    self.tipsStr = @"一共查询到{totalElement}条POI数据,已抓取{fetchNum},成功抓取{successNum}条数据,失败{failNum}条数据";
}

- (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.locService.delegate = nil;
    self.poiSearch.delegate = nil;
}


- (void) buildUI
{
    self.title = @"数据抓取";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    [self.view addSubview:self.typeIdLabel];
    [self.view addSubview:self.typeIdTextField];
    [self.view addSubview:self.keyLabel];
    [self.view addSubview:self.keyTextField];
    [self.view addSubview:self.latitudeLabel];
    [self.view addSubview:self.latitudeTextField];
    [self.view addSubview:self.longitudeLabel];
    [self.view addSubview:self.longitudeTextField];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.subButton];
}

#pragma mark - 执行自动抓取方法
- (void) startFetch
{
    if(!self.latitudeTextField.text
       || self.latitudeTextField.text.length == 0
       || !self.longitudeTextField.text
       || self.longitudeTextField.text.length == 0
       || !self.typeIdTextField.text
       || self.typeIdTextField.text.length == 0
       || !self.keyTextField.text
       || self.keyTextField.text.length == 0){
        [OTWUtils alertFailed:@"填写的信息不完善" userInteractionEnabled:YES target:self];
        return ;
    }
    self.subButton.userInteractionEnabled = NO;
    [self.subButton setTitle:@"抓取中..." forState:UIControlStateNormal];
    [self.subButton setBackgroundColor:[UIColor color_d5d5d5]];
    self.currentPage = 0;
    self.totalPoiElement = 0;
    self.failedElement = 0;
    self.successElement = 0;
    self.fetchNum = 0;
    self.poiInfoArray = [[NSMutableArray alloc] init];
    self.typeIds = [self.typeIdTextField.text componentsSeparatedByString:@";"];
    self.location = (CLLocationCoordinate2D){self.latitudeTextField.text.floatValue,self.longitudeTextField.text.floatValue};
    [self startPoiSearch];
}


- (void) startPoiSearch
{
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = self.currentPage;
    option.pageCapacity = 50;
    option.location =self.location;
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    option.keyword = self.keyTextField.text;
    BOOL flag = [self.poiSearch poiSearchNearBy:option];
    if(flag){
        self.tipsLabel.text = @"周边检索发送成功";
        DLog(@"周边检索发送成功");
    }
    else{
        self.tipsLabel.text = @"周边检索发送失败";
        DLog(@"周边检索发送失败");
        self.subButton.userInteractionEnabled = YES;
        [self.subButton setTitle:@"开始抓取" forState:UIControlStateNormal];
        [self.subButton setBackgroundColor:[UIColor color_e50834]];
    }
}

#pragma mark - BMKPoiSearchDelegate

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        self.searchTotalElement = poiResultList.totalPoiNum;
        
        self.tipsLabel.text =  [[[[self.tipsStr stringByReplacingOccurrencesOfString:@"{totalElement}" withString:[NSString stringWithFormat:@"%d",self.searchTotalElement]] stringByReplacingOccurrencesOfString:@"{successNum}" withString:[NSString stringWithFormat:@"%d",self.successElement]]  stringByReplacingOccurrencesOfString:@"{failNum}" withString:[NSString stringWithFormat:@"%d",self.failedElement]] stringByReplacingOccurrencesOfString:@"{fetchNum}" withString:[NSString stringWithFormat:@"%d",self.totalPoiElement]];
        //在此处理正常结果,这里处理数据详情抓取，每1s中执行一次
        for (BMKPoiInfo *one in poiResultList.poiInfoList) {
            //把获取到的数据放入数组中
            [self.poiInfoArray addObject:one];
            self.totalPoiElement ++ ;
        }
        if(self.totalPoiElement == poiResultList.totalPoiNum){
            [self.subButton setTitle:@"开始获取详情..." forState:UIControlStateNormal];
            //[self.subButton setBackgroundColor:[UIColor color_e50834]];
            [self fetchPoiDetail];
        }else{
            self.currentPage ++ ;
            //继续抓取，抓取休眠2秒
            [NSThread sleepForTimeInterval:2.0f];
            [self startPoiSearch];
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
        //self.tipsLabel.text = @"起始点有歧义";
        self.subButton.userInteractionEnabled = YES;
        [self.subButton setTitle:@"开始抓取" forState:UIControlStateNormal];
        [self.subButton setBackgroundColor:[UIColor color_e50834]];
    } else {
        NSLog(@"抱歉，未找到结果");
        //self.tipsLabel.text = @"抱歉，未找到结果";
        self.subButton.userInteractionEnabled = YES;
        [self.subButton setTitle:@"开始抓取" forState:UIControlStateNormal];
        [self.subButton setBackgroundColor:[UIColor color_e50834]];
    }
}

- (void)fetchPoiDetail
{
    BMKPoiInfo *one = self.poiInfoArray[self.fetchNum];
    BMKPoiDetailSearchOption* option = [[BMKPoiDetailSearchOption alloc] init];
    option.poiUid = one.uid;
    BOOL flag = [self.poiSearch poiDetailSearch:option];
    if(flag){
        DLog(@"检索成功 uid %@",one.uid);
    }else{
        DLog(@"检索失败");
        self.failedElement ++ ;
        self.fetchNum ++;
        if(self.fetchNum < self.poiInfoArray.count){
            [self fetchPoiDetail];
        }else{
            self.subButton.userInteractionEnabled = YES;
            [self.subButton setTitle:@"开始抓取" forState:UIControlStateNormal];
            [self.subButton setBackgroundColor:[UIColor color_e50834]];
        }
    }
}

//获取poi数据详情 delegate
-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    if(errorCode == BMK_SEARCH_NO_ERROR){
        //在此处理正常结果
        OTWBusinessFetchModel *model = [[OTWBusinessFetchModel alloc] init];
        model.name = poiDetailResult.name;
        model.address = poiDetailResult.address;
        model.contactInfo = poiDetailResult.phone;
        model.latitude = poiDetailResult.pt.latitude;
        model.longitude = poiDetailResult.pt.longitude;
        model.typeIds = self.typeIds ;
        model.poiDetailUrl = poiDetailResult.detailUrl;
        //执行数据保存
        static NSString *saveFetchUrl = @"/app/business/fetch/create";
        self.fetchNum ++ ;
        [OTWNetworkManager doPOST:saveFetchUrl parameters:model.mj_keyValues success:^(id responseObject) {
            if( [[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
                self.successElement ++ ;
            }else{
                self.failedElement ++ ;
            }
            self.tipsLabel.text =  [[[[self.tipsStr stringByReplacingOccurrencesOfString:@"{totalElement}" withString:[NSString stringWithFormat:@"%d",self.searchTotalElement]] stringByReplacingOccurrencesOfString:@"{successNum}" withString:[NSString stringWithFormat:@"%d",self.successElement]]  stringByReplacingOccurrencesOfString:@"{failNum}" withString:[NSString stringWithFormat:@"%d",self.failedElement]] stringByReplacingOccurrencesOfString:@"{fetchNum}" withString:[NSString stringWithFormat:@"%d",self.totalPoiElement]];
            if(self.fetchNum < self.poiInfoArray.count){
                [NSThread sleepForTimeInterval:1.0f];
                [self fetchPoiDetail];
            }else{
                self.subButton.userInteractionEnabled = YES;
                [self.subButton setTitle:@"开始抓取" forState:UIControlStateNormal];
                [self.subButton setBackgroundColor:[UIColor color_e50834]];
            }
            
        } failure:^(NSError *error) {
            DLog(@"save fetch error %@",error);
            self.failedElement ++ ;
            self.tipsLabel.text =  [[[[self.tipsStr stringByReplacingOccurrencesOfString:@"{totalElement}" withString:[NSString stringWithFormat:@"%d",self.searchTotalElement]] stringByReplacingOccurrencesOfString:@"{successNum}" withString:[NSString stringWithFormat:@"%d",self.successElement]]  stringByReplacingOccurrencesOfString:@"{failNum}" withString:[NSString stringWithFormat:@"%d",self.failedElement]] stringByReplacingOccurrencesOfString:@"{fetchNum}" withString:[NSString stringWithFormat:@"%d",self.totalPoiElement]];
            if(self.fetchNum < self.poiInfoArray.count){
                [NSThread sleepForTimeInterval:1.0f];
                [self fetchPoiDetail];
            }else{
                self.subButton.userInteractionEnabled = YES;
                [self.subButton setTitle:@"开始抓取" forState:UIControlStateNormal];
                [self.subButton setBackgroundColor:[UIColor color_e50834]];
            }
        }];
    }else{
        self.failedElement ++ ;
        DLog(@"详情获取失败");
        if(self.fetchNum < self.poiInfoArray.count){
            [NSThread sleepForTimeInterval:1.0f];
            [self fetchPoiDetail];
        }else{
            self.subButton.userInteractionEnabled = YES;
            [self.subButton setTitle:@"开始抓取" forState:UIControlStateNormal];
            [self.subButton setBackgroundColor:[UIColor color_e50834]];
        }
        
        
    }
}

#pragma mark - BMKLocationServiceDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    self.latitudeTextField.text = [NSString stringWithFormat:@"%f",coordinate.latitude];
    self.longitudeTextField.text = [NSString stringWithFormat:@"%f",coordinate.longitude];
    [self.locService stopUserLocationService];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [OTWUtils alertFailed:@"定位失败" userInteractionEnabled:YES target:self];
    [self.locService stopUserLocationService];
}

#pragma mark - Setter Getter

- (UILabel *) typeIdLabel
{
    if(!_typeIdLabel){
        _typeIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.navigationHeight + 30,100, 50)];
        _typeIdLabel.text = @"类型ID";
        _typeIdLabel.textColor = [UIColor color_242424];
        _typeIdLabel.font = [UIFont systemFontOfSize:16];
    }
    return _typeIdLabel;
}

- (UILabel *) keyLabel
{
    if(!_keyLabel){
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.typeIdLabel.MaxY, 100, 50)];
        _keyLabel.text = @"poi关键字";
        _keyLabel.textColor = [UIColor color_242424];
        _keyLabel.font = [UIFont systemFontOfSize:16];
    }
    return _keyLabel;
}

- (UITextField *) typeIdTextField
{
    if(!_typeIdTextField){
        _typeIdTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.typeIdLabel.MaxX, self.typeIdLabel.MinY, 200, 50)];
        _typeIdTextField.placeholder = @"输入类型ID(使用;分割)";
        _typeIdTextField.textColor = [UIColor color_979797];
        _typeIdTextField.font = [UIFont systemFontOfSize:14];
        _typeIdTextField.textAlignment = NSTextAlignmentLeft;
    }
    return _typeIdTextField;
}

- (UITextField *) keyTextField
{
    if(!_keyTextField){
        _keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.keyLabel.MaxX, self.keyLabel.MinY, 200, 50)];
        _keyTextField.placeholder = @"输入抓取关键字";
        _keyTextField.textColor = [UIColor color_979797];
        _keyTextField.font = [UIFont systemFontOfSize:14];
        _keyTextField.textAlignment = NSTextAlignmentLeft;
    }
    return _keyTextField;
}

- (UIButton *) subButton
{
    if(!_subButton){
        _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _subButton.frame = CGRectMake( (SCREEN_WIDTH - 200 ) / 2, self.longitudeLabel.MaxY + 60, 200, 44);
        _subButton.layer.cornerRadius = 3;
        [_subButton setTitle:@"开始抓取" forState:UIControlStateNormal];
        [_subButton setBackgroundColor:[UIColor color_e50834]];
        _subButton.titleLabel.textColor = [UIColor whiteColor];
        [_subButton addTarget:self action:@selector(startFetch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subButton;
}

- (UILabel *) latitudeLabel
{
    if(!_latitudeLabel){
        _latitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.keyLabel.MaxY, 100, 50)];
        _latitudeLabel.text = @"纬度";
        _latitudeLabel.textColor = [UIColor color_242424];
        _latitudeLabel.font = [UIFont systemFontOfSize:16];
    }
    return _latitudeLabel;
}

- (UILabel *) longitudeLabel
{
    if(!_longitudeLabel){
        _longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.latitudeLabel.MaxY , 100, 50)];
        _longitudeLabel.text = @"经度";
        _longitudeLabel.textColor = [UIColor color_242424];
        _longitudeLabel.font = [UIFont systemFontOfSize:16];
    }
    return _longitudeLabel;
}

- (UITextField *) latitudeTextField
{
    if(!_latitudeTextField){
        _latitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.latitudeLabel.MaxX, self.latitudeLabel.MinY, 200, 50)];
        _latitudeTextField.placeholder = @"请输入纬度";
        _latitudeTextField.textColor = [UIColor color_979797];
        _latitudeTextField.font = [UIFont systemFontOfSize:14];
        _latitudeTextField.textAlignment = NSTextAlignmentLeft;
    }
    return _latitudeTextField;
}

- (UITextField *) longitudeTextField
{
    if(!_longitudeTextField){
        _longitudeTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.longitudeLabel.MaxX, self.longitudeLabel.MinY, 200, 50)];
        _longitudeTextField.placeholder = @"请输入经度";
        _longitudeTextField.textColor = [UIColor color_979797];
        _longitudeTextField.font = [UIFont systemFontOfSize:14];
        _longitudeTextField.textAlignment = NSTextAlignmentLeft;
    }
    return _longitudeTextField;
}

- (UILabel *) tipsLabel
{
    if(!_tipsLabel){
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.longitudeLabel.MaxY, SCREEN_WIDTH - 30, 50)];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textColor = [UIColor color_e50834];
        _tipsLabel.font = [UIFont systemFontOfSize:14];
    }
    return _tipsLabel;
}

- (BMKLocationService *) locService
{
    if(!_locService){
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    }
    return _locService;
}

- (BMKPoiSearch *) poiSearch
{
    if(!_poiSearch){
        _poiSearch = [[BMKPoiSearch alloc] init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}

- (NSMutableArray *) poiInfoArray
{
    if(!_poiInfoArray){
        _poiInfoArray = [[NSMutableArray alloc] init];
    }
    return _poiInfoArray;
}

@end
