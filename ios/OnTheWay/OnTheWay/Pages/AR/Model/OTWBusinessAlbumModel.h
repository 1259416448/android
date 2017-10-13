//
//  OTWBusinessAlbumModel.h
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/10/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTWBusinessAlbumModel : NSObject

@property (nonatomic, copy) NSString * dateCreatedStr;

@property (nonatomic, strong) NSNumber * dateCreated;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSNumber *photoId;

@property (nonatomic, copy) NSString * userNickname;
//图片url
@property (nonatomic, copy) NSString * photoUrl;
@end
