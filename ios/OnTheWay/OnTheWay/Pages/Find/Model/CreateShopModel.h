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
    CreateSHopCellType_Address,
    //upload picture
    CreateSHopCellType_PIC,
    CreateSHopCellType_Card_PIC
} CreateShopCellType;

@interface CreateShopModel : NSObject

//项目名称
@property (nonatomic,copy) NSString *title;
//项目名称字体长度
@property (nonatomic,assign) CGFloat titileW;
//项目名称子标题字体长度
@property (nonatomic,assign) CGFloat childTitleW;

@property (nonatomic,copy) NSString *placeholder;
//表单对应的字段
@property (nonatomic,copy) NSString *key;
//检验出错时的提示信息
@property (nonatomic,copy) NSString *errText;
//cell类型
@property (nonatomic,assign) CreateShopCellType cellType;
//最大长度限制
@property (nonatomic,assign) NSInteger maxInputLenth;
//cell高度
@property (nonatomic,assign) NSInteger cellHigh;

//是否必填
@property (nonatomic,assign) BOOL isRequire;
@end
