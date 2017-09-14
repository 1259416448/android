//
//  OTWPersonalFootprintService.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/2.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalFootprintService.h"
#import "OTWPersonalFootprintsListController.h"

@interface OTWPersonalFootprintService()

//每页第一次加载时间
@property (nonatomic,strong) NSNumber *currentTime;
//当前页
@property (nonatomic,assign) int number;
//每页大小
@property (nonatomic,assign) int size;

@end

@implementation OTWPersonalFootprintService

static NSString *userFootprintUrl = @"/app/footprint/user/{userId}";

//我的足迹数据请求
- (void) userFootprintList:(NSDictionary *) params userId:(NSString *)userId viewController:(OTWPersonalFootprintsListController *)viewController completion:(requestCompletionBlock)block
{
    if(!_number) _number = 0;
    if(!_size) _size = 15;
    if(!viewController.ifInsertCreateCell){
        [viewController insertCreateCell];
    }
    if(_currentTime){
        params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:_number],@"number",[NSNumber numberWithInt:_size],@"size",_currentTime,@"currentTime",nil];
    }else{
        params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:_number],@"number",[NSNumber numberWithInt:_size],@"size",nil];
    }
    [OTWNetworkManager doGET:[userFootprintUrl stringByReplacingOccurrencesOfString:@"{userId}" withString:userId] parameters:params success:^(id responseobject){
        //请求成功
        if([[NSString stringWithFormat:@"%@",responseobject[@"code"]] isEqualToString:@"0"]){
            //构建数据
            NSDictionary *body = responseobject[@"body"];
            _currentTime = body[@"currentTime"];
            //处理数据
            NSArray *array = body[@"content"];
            int count = 0;
            if(array && array.count >0){
                int i = 0;
                for (NSDictionary *dict in array) {
                    //判断当前model 的month是否和stauts中最后一个一样，一致 直接拼接数据至末尾
                    NSMutableArray<OTWPersonalFootprintFrame *> *monthData;
                    if(i==0){
                        if([[viewController.status lastObject].month isEqualToString:dict[@"month"]]){
                            monthData = [viewController.status lastObject].monthData;
                        }
                    }
                    if(!monthData){
                        OTWPersonalFootprintsListModel *model = [[OTWPersonalFootprintsListModel alloc] init];
                        model.month = dict[@"month"];
                        monthData = [[NSMutableArray alloc] init];
                        model.monthData = monthData;
                        [viewController.status addObject:model];
                    }
                    for (NSDictionary *dict1 in dict[@"monthData"]) {
                        OTWFootprintListModel *footprintDetail =   [OTWFootprintListModel initWithDict:dict1];
                        OTWPersonalFootprintFrame *footprintFrame = [OTWPersonalFootprintFrame initWithFootprintDetail:footprintDetail];
                        //判断当前的footprintDetail 的 day 是否和 monthData 的最后一个相同  相同 不设置leftContent 不相同 设置leftContent
                        footprintFrame.leftContent = footprintDetail.day;
                        if(monthData.count > 0 && [[monthData lastObject].footprintDetal.day isEqualToString:footprintDetail.day]){
                            footprintFrame.leftContent = @"";
                        }
                        [footprintFrame initData];
                        [monthData addObject:footprintFrame];
                        count ++;
                    }
                    i++;
                }
                [viewController.tableView reloadData];
                if(count < _size){ //查询的数据小于分页数据 表示已完成 这里可能会存在多请求一次数据库
                    [viewController.tableView.mj_footer endRefreshingWithNoMoreData];
                    viewController.tableView.mj_footer.hidden = YES;
                }else{
                    _number ++;
                    [viewController.tableView.mj_footer endRefreshing];
                }
            }else{
                //如果status == 0 或者 只有 相机发布数据
                if(viewController.status.count == 0 || [self checkIfNotFund:viewController]){
                    viewController.notFundFootprintView.hidden = NO;
                    viewController.button.hidden = YES;
                }
                [viewController.tableView.mj_footer endRefreshingWithNoMoreData];
                viewController.tableView.mj_footer.hidden = YES;
            }
        }else{ //请求失败，服务端错误
            [viewController errorTips:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO];
        }
    } failure:^(NSError *error){
        [viewController.tableView.mj_footer endRefreshing];
        [viewController netWorkErrorTips:error];
    }];
}

- (BOOL) checkIfNotFund:(OTWPersonalFootprintsListController *)viewController
{
    if(viewController.status.count == 1){
        OTWPersonalFootprintsListModel *model = viewController.status[0];
        if([model.month isEqualToString:@"0"] && model.monthData.count == 1){
            OTWPersonalFootprintFrame *footprint = model.monthData[0];
            if(footprint.hasRelease){
                return YES;
            }
        }
    }
    return NO;
}

@end
