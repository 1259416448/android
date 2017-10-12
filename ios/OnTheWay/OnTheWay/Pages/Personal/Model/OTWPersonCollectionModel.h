//
//  OTWPersonCollectionModel.h
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/10/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWPersonCollectionModel : NSObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *dateCreatedStr;
@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSNumber * businessId;
@property (nonatomic,strong) NSNumber * collectionId;
@property (nonatomic,strong) NSNumber * dateCreated;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;



@end
