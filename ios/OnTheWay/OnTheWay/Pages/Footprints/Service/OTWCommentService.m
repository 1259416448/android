//
//  OTWCommentService.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/8/3.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWCommentService.h"
#import "OTWFootprintDetailController.h"
#import <MJExtension.h>
#import <MBProgressHUD.h>

@interface OTWCommentService()

//每页第一次加载时间
@property (nonatomic,strong) NSNumber *currentTime;
//当前页
@property (nonatomic,assign) int number;
//每页大小
@property (nonatomic,assign) int size;

@end

@implementation OTWCommentService

static NSString *commentSearchUrl = @"/app/footprint/comment/search";

static NSString *commentDeleteUrl = @"/app/footprint/comment/delete/{id}";

//抓取足迹列表数据
- (void) commentList:(NSDictionary *) params footprintId:(NSString *)footprintId viewController:(OTWFootprintDetailController *)viewController completion:(requestCompletionBlock)block
{
    if(!_number) _number = 1; //默认会返回10条数据，所以这里直接从1开始
    if(!_size) _size = 10;
    if(_currentTime){
        params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:_number],@"number",[NSNumber numberWithInt:_size],@"size",_currentTime,@"currentTime",footprintId,@"footprintId",nil];
    }else{
        params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:_number],@"number",[NSNumber numberWithInt:_size],@"size",footprintId,@"footprintId",nil];
    }
    [OTWNetworkManager doGET:commentSearchUrl parameters:params success:^(id responseObject){
        
        if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
            
            NSDictionary *body = responseObject[@"body"];
            NSArray *commentArray = body[@"content"];
            if(commentArray && commentArray.count>0){
                for (NSDictionary *dict in commentArray) {
                    OTWCommentModel *commentModel = [OTWCommentModel mj_objectWithKeyValues:dict];
                    OTWCommentFrame *commentFrame = [[OTWCommentFrame alloc] init];
                    [commentFrame setCommentModel:commentModel];
                    [viewController.commentFrameArray addObject:commentFrame];
                }
                [viewController.tableView reloadData];
                if(commentArray.count < _size){ //查询的数据小于分页数据 表示已完成 这里可能会存在多请求一次数据库
                    [viewController.tableView.mj_footer endRefreshingWithNoMoreData];
                    viewController.tableView.mj_footer.hidden = YES;
                    [viewController.tableView reloadData];
                }else{
                    _number ++;
                    [viewController.tableView.mj_footer endRefreshing];
                }
            }else{
                [viewController.tableView.mj_footer endRefreshingWithNoMoreData];
                viewController.tableView.mj_footer.hidden = YES;
                [viewController.tableView reloadData];
            }
        }else{
            if([responseObject[@"messageCode"] isEqualToString:@"000202"]){
                [viewController.indicatorView stopAnimating];
                viewController.errorTipsLabel.text = @"足迹已被删除";
                viewController.firstLoadingView.hidden = NO;
                viewController.tableView.hidden = YES;
                viewController.commentBGView.hidden = YES;
                //发出足迹删除通知
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:footprintId,@"footprintId", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"foorprintAlreadyDeleted" object:nil userInfo:dict];
            }else{
                [OTWUtils alertFailed:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO target:viewController];
            }
        }
        
    } failure:^(NSError *error){
        [viewController netWorkErrorTips:error];
    }];
}

//删除足迹
- (void) deleteCommentById:(NSString *)commentId viewController:(OTWFootprintDetailController *)viewController completion:(requestCompletionBlock)block
{
    MBProgressHUD *hud = [OTWUtils alertLoading:@"" userInteractionEnabled:YES target:viewController];
    [OTWNetworkManager doPOST:[commentDeleteUrl stringByReplacingOccurrencesOfString:@"{id}" withString:commentId] parameters:nil success:^(id responseObject){
        [hud hideAnimated:YES];
        if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
            //删除成功
            int i = 0;
            for (OTWCommentFrame *commentFrame in viewController.commentFrameArray) {
                if([commentFrame.commentModel.commentId.description isEqualToString:commentId]){
                    
                    //设置评论总数 - 1
                    
                    OTWFootprintListModel *footprintDetail = viewController.detailFrame.footprintDetailModel;
                    
                    footprintDetail.footprintCommentNum -- ;
                    
                    viewController.commentSunLabel.text = [[NSString stringWithFormat:@"%ld",(long)viewController.detailFrame.footprintDetailModel.footprintCommentNum] stringByAppendingString:@"条评论"];
                    
                    if(footprintDetail.business){
                        //如果是商家评论，这里发送一下评论是否变化的通知
                        NSDictionary *dict = @{
                                               @"footprintId":footprintDetail.footprintId.description,
                                               @"footprintLikeNum":[NSNumber numberWithInteger:footprintDetail.footprintLikeNum],
                                               @"footprintCommentNum":[NSNumber numberWithInteger:footprintDetail.footprintCommentNum],
                                               @"ifLike":[NSNumber numberWithBool:footprintDetail.ifLike]
                                               };
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshFootprint" object:nil userInfo:dict];
                    }
                    
                    [viewController.commentFrameArray removeObjectAtIndex:i];
                    [viewController.tableView beginUpdates];
                    [viewController.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                    [viewController.tableView endUpdates];
                    break;
                }
                i ++ ;
            }
            if(viewController.commentFrameArray.count == 0){
                [viewController notFundCommentBGView].hidden = NO;
                viewController.tableView.mj_footer.hidden = YES;
                [viewController refreshTableViewHeader];
                [viewController.tableView reloadData];
            }
        }else{
            [viewController errorTips:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO];
        }
    } failure:^(NSError *error){
        [viewController netWorkErrorTips:error];
    }];
}

@end
