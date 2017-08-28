//
//  CreateShopModel.h
//  OnTheWay
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    //textfield
    CreateSHopCellType_TF = 0,
    //textView
    CreateSHopCellType_TV,
    CreateSHopCellType_TV_BACK,
    CreateSHopCellType_TV_TWO,
    //upload picture
    CreateSHopCellType_PIC,
} CreateShopCellType;

@interface CreateShopModel : NSObject

//项目名称
@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *placeholder;
//表单对应的字段
@property (nonatomic,copy) NSString *key;
//检验出错时的提示信息
@property (nonatomic,copy) NSString *errText;
//cell类型
@property (nonatomic,assign) CreateShopCellType cellType;
//最大长度限制
@property (nonatomic,assign) NSInteger maxInputLenth;
//是否必填
@property (nonatomic,assign) BOOL isRequire;
@end
