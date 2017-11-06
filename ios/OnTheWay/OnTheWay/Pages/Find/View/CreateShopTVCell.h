//
//  CreateShopTVCell.h
//  OnTheWay
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateShopModel.h"
#import "CreateShopFormModel.h"

@protocol CreateShopTVCellDelegate <NSObject>

- (void)didChangeType:(NSString *)typeStr;

@end

@interface CreateShopTVCell : UITableViewCell

@property (nonatomic,strong) CreateShopModel *createShopModel;

@property (nonatomic,strong) CreateShopFormModel *formModel;

@property (assign,nonatomic) CGFloat cellHeight;

@property (nonatomic, weak) id <CreateShopTVCellDelegate> delegate;

-(void)refreshContent:(CreateShopModel *)createModel formModel:(CreateShopFormModel *)formModel control:(UINavigationController*)control;

+(CGFloat)cellHeight:(CreateShopModel *)createModel;

@end
