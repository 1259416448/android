//
//  OTWFootprintsChangeAddressController.h
//  OnTheWay
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTWFootprintsChangeAddressModel.h"


#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <IQKeyboardManager.h>
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>
#import <BaiduMapAPI_Search/BMKGeoCodeSearch.h>

@interface OTWFootprintsChangeAddressController : OTWBaseViewController

@property (nonatomic ,strong ) void (^tapOne)(OTWFootprintChangeAddressArrayModel *chooseModel);

-(void) location:(CLLocationCoordinate2D) location;

-(void) defaultChooseModel:(OTWFootprintChangeAddressArrayModel *)defaultChooseModel;


@end
