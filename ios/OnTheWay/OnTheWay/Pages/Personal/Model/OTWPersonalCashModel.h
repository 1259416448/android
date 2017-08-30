//
//  OTWPersonalCashModel.h
//  OnTheWay
//
//  Created by UI002 on 2017/8/29.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    //textfield
    PersonalCashCellType_TF = 0,
    PersonalCashCellType_TF_PERSONAL,
    //textView
    PersonalCashCellType_TV_BACK,

} PersonalCashCellType;

@interface OTWPersonalCashModel : NSObject
//项目名称
@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *placeholder;
//表单对应的字段
@property (nonatomic,copy) NSString *key;
//检验出错时的提示信息
@property (nonatomic,copy) NSString *errText;
//cell类型
@property (nonatomic,assign) PersonalCashCellType cellType;
//最大长度限制
@property (nonatomic,assign) NSInteger maxInputLenth;
@end
