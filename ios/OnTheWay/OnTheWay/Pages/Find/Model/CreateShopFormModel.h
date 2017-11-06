//
//  CreateShopFormModel.h
//  OnTheWay
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>


@class OTWDocument;
@class OTWBusinessExpand;

@interface CreateShopFormModel : NSObject

//商家姓名
@property (nonatomic, copy)NSString            *shopName;
//经度
@property (nonatomic, copy)NSString            *latitude;
//纬度
@property (nonatomic, copy)NSString            *longitude;
//联系方式
@property (nonatomic, copy)NSString            *contactInfo;
//联系地址
@property (nonatomic, copy)NSString            *address;
//商家类型
@property (nonatomic, copy)NSMutableArray            *typeIds;
//证件号码
@property (nonatomic, copy)NSString            *certificateNumber;
//证件类型
@property (nonatomic, copy)NSString            *certificateType;
//手机号码
@property (nonatomic, copy)NSString            *mobilePhoneNumber;
//提交人姓名
@property (nonatomic, copy)NSString            *name;
//组织机构代码
@property (nonatomic, copy)NSString            *organizationNumber;
//个人证件照
@property (nonatomic,strong) OTWDocument *certificatePhoto;
//商家营业执照
@property (nonatomic,strong) OTWDocument *businessLicensePhoto;
//认领资料确认
@property (nonatomic,strong) OTWBusinessExpand *businessExpand;
//个人证件照
@property (nonatomic,strong) UIImage *certificateImage;
//商家营业执照
@property (nonatomic,strong) UIImage *businessLicenseImage;



+ (instancetype) initWithDict:(NSDictionary *) dict;

@end
