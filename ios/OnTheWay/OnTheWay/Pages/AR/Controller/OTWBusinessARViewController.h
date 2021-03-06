//
//  OTWARShopViewController.h
//  OnTheWay
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWBaseViewController.h"
#import "ArvixARViewController.h"

typedef void(^requestBackBlock) (id result);

@interface OTWBusinessARViewController : ArvixARViewController

-(void) fetchARShops:(NSDictionary *) params completion:(requestBackBlock) block;

@property (nonatomic, copy)NSString * searchText;

@property (nonatomic, assign) BOOL isFromFind;

@property (nonatomic, assign) BOOL isFromSearch;

//商家分类ID
@property (nonatomic,strong) NSString * typeId;

@property (nonatomic,strong) NSString * sortId;

@property (nonatomic,strong) NSString * firstID;



@end
