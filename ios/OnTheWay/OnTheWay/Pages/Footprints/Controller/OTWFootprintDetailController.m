//
//  OTWFootprintDetailController.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintDetailController.h"
#import "OTWFootprintDetailViewCell.h"
#import "OTWFootprintsChangeAddressController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWCommentService.h"
#import "OTWUserModel.h"
#import "OTWPersonalFootprintsListController.h"

#import <SDCycleScrollView.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <IQKeyboardManager.h>
#import <IQKeyboardReturnKeyHandler.h>
#import "PYPhotoBrowser.h"
#import "OTWFootprintService.h"
#import <MJExtension.h>

#define footprintContentFont [UIFont systemFontOfSize:17]
#define likeLabelFont [UIFont fontWithName:@"HelveticaNeue-Medium" size:8]
#define padding 15

@interface OTWFootprintDetailController () <UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UITextViewDelegate>

//评论填写区域 start
@property (nonatomic,strong) UILabel *commentSunLabel;
@property (nonatomic,strong) UIView *likeView;
@property (nonatomic,strong) UIImageView *likeImageView;
@property (nonatomic,strong) UIImageView *shareImageView;
@property (nonatomic,strong) UIView *writeCommentView;
@property (nonatomic,strong) UILabel *commentLabel;
@property (nonatomic,strong) UIImageView *writeCommentImageView;
@property (nonatomic,strong) UITextView *writeCommentTextView;
@property (nonatomic,assign) CGFloat lastTextViewTextHeight;
@property (nonatomic,assign) CGFloat lastTextViewDifHeight;

//点赞总数
@property (nonatomic,strong) UIView *likeSumBGView;
@property (nonatomic,strong) UILabel *likeSumLabel;
@property (nonatomic,strong) UILabel *plugsLabel;

//评论填写区域 end

//足迹详情 start
@property (nonatomic,strong) UIView *tableHeaderView;
@property (nonatomic,strong) UIView *footprintDetailBGView;
@property (nonatomic,strong) UIView *footprintHeaderBGView;
@property (nonatomic,strong) UIView *commentHeaderBGView;
@property (nonatomic,strong) UIView *commentHeaderTopLine;
@property (nonatomic,strong) UIImageView *commentHeaderImageView;
@property (nonatomic,strong) UILabel *commentHeaderLabel;
@property (nonatomic,strong) UIImageView *userHeadImgImageView;
@property (nonatomic,strong) UIButton *userNicknameButton;
@property (nonatomic,strong) UILabel *footprintDateCreateLabel;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIAlertController *deleteAlertController;
@property (nonatomic,strong) UIView *footprintPhotoView;
@property (nonatomic,strong) UILabel *footprintContentLabel;
@property (nonatomic,strong) UIImageView *footprintAddressImageView;
@property (nonatomic,strong) UILabel *footprintAddressLabel;
@property (nonatomic,strong) UIView *topLine;
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic,strong) SDCycleScrollView *photoScrollView;
@property (nonatomic,strong) UILabel *photoPageControllerLabel;
@property (nonatomic,assign) BOOL wasKeyboardManagerEnabled;
//没有评论显示缺省信息
@property (nonatomic,strong) UIView *notFundCommentBGView;
@property (nonatomic,strong) UIImageView *qiangshafaImageView;
@property (nonatomic,strong) UILabel *qiangshafaLabel;

@property (nonatomic,assign) BOOL openKeyboard;


//足迹详情 end
@property (nonatomic, strong) IQKeyboardReturnKeyHandler  *returnKeyHandler;

@property (nonatomic, strong) NSMutableArray *footprintImageUrls;

@property (nonatomic,strong) OTWCommentService *commentService;

@property (nonatomic,strong) UIAlertController *alertController;

@property (nonatomic,strong) NSString *deleteCommentId;

@property (nonatomic,assign) BOOL ifSubLike;

@property (nonatomic,assign) long likeTime;

@end

@implementation OTWFootprintDetailController

static NSString *imageView2Params = @"?imageView2/1/w/690/h/500";
static NSString *imageMogr2Params = @"?imageMogr2/thumbnail/!20p";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //监听键盘的通知
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.ifSubLike = NO;
    self.likeTime = 0;
    [self buildUI];
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeySend;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.writeCommentField resignFirstResponder];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self.writeCommentTextView resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.returnKeyHandler = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    
}

-(void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
- (void) keyboardWillChangeFrameNotify:(NSNotification*)notify
{
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeySend;
    // 0.取出键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    // 3.执行动画
    
    _lastTextViewDifHeight = self.lastTextViewTextHeight - 20;
    [self.writeCommentTextView scrollRangeToVisible:NSMakeRange(self.writeCommentTextView.text.length-1, 1)];
    [UIView animateWithDuration:duration animations:^{
        if(transformY == 0){
            if(_openKeyboard){
                self.commentBGView.frame = CGRectMake(self.commentBGView.MinX, self.commentBGView.MinY + self.lastTextViewDifHeight ,self.commentBGView.Witdh, 49);
                self.writeCommentView.frame = CGRectMake(self.writeCommentView.MinX, self.writeCommentView.MinY, SCREEN_WIDTH - 160, 33 );
                self.writeCommentTextView.frame = CGRectMake(self.writeCommentTextView.MinX, self.writeCommentTextView.MinY, self.writeCommentView.Witdh-33-15,20);
                self.commentSunLabel.hidden = NO;
                self.likeView.hidden = NO;
                //判断是否输入内容
                if(self.writeCommentTextView.text.length==0){
                    self.commentLabel.hidden = NO;
                }
            }
            _openKeyboard = NO;
        }else{
            if(!_openKeyboard){
                self.commentBGView.frame = CGRectMake(self.commentBGView.MinX, self.commentBGView.MinY-self.lastTextViewDifHeight, self.commentBGView.Witdh, 49 + self.lastTextViewDifHeight);
                self.writeCommentView.frame = CGRectMake(self.writeCommentView.MinX, self.writeCommentView.MinY, SCREEN_WIDTH - padding *2, self.writeCommentView.Height + self.lastTextViewDifHeight);
                self.writeCommentTextView.frame = CGRectMake(self.writeCommentTextView.MinX, self.writeCommentTextView.MinY, self.writeCommentView.Witdh-33-15, self.lastTextViewTextHeight);
                self.commentSunLabel.hidden = YES;
                self.likeView.hidden = YES;
                self.commentLabel.hidden = YES;
            }
            _openKeyboard = YES;
        }
        self.tableView.frame = CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT + transformY - self.commentBGView.Height-self.navigationHeight);
        self.commentBGView.transform = CGAffineTransformMakeTranslation(0, transformY);
        [self scrollTableViewToBottom];
    } completion:^(BOOL finished){
        if(_openKeyboard){
            self.writeCommentTextView.selectedRange = NSMakeRange(self.writeCommentTextView.text.length, 0);
        }
    }];
}

/**
 *  tableView快速滚动到底部
 */
#pragma mark - tableView快速滚动到底部 请一定不要使用动画 animated:NO 使用动画会出现评论cell渲染错乱！！！
- (void)scrollTableViewToBottom
{
    if (self.commentFrameArray.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.commentFrameArray.count - 1) inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buildUI
{
    //设置标题
    self.title = @"足迹详情";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    [self setCustomNavigationRightView:self.shareImageView];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    //先通过上一界面传递的id数据   获取足迹详情和加载最近评论信息,在构建页面
    [self.view addSubview:self.firstLoadingView];
}

- (void) buildTableView
{
    self.firstLoadingView.hidden = YES;
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComment)];
    self.tableView.tableHeaderView = [self buildTableHeaderView];
    //增加底部评论信息
    [self.view addSubview:self.commentBGView];
    [self.commentBGView addSubview:self.writeCommentView];
    [self.commentBGView addSubview:self.commentSunLabel];
    [self.commentBGView addSubview:self.likeView];
    [self.likeView addSubview:self.likeSumBGView];
    [self.likeSumBGView addSubview:self.likeSumLabel];
    [self.likeSumBGView addSubview:self.plugsLabel];
    [self.writeCommentView addSubview:self.writeCommentTextView];
    [self.writeCommentView addSubview:self.writeCommentImageView];
    [self.writeCommentView addSubview:self.commentLabel];
    self.commentSunLabel.text = [[NSString stringWithFormat:@"%ld",(long)self.detailFrame.footprintDetailModel.footprintCommentNum] stringByAppendingString:@"条评论"];
    [self.view bringSubviewToFront:self.customNavigationBar];
    //设置一下下拉刷新初始化状态
    if(self.commentFrameArray.count<10){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = YES;
    }
    [self refreshTableViewHeader];
    [self refreshLikeBGView];
}

/**
 * 刷新header View ，主要是判断一下有误评论，需要动态改变一下 headerView的高度
 */
- (void) refreshTableViewHeader
{
    if(self.commentFrameArray.count == 0 && !self.notFundCommentBGView.hidden){
        self.notFundCommentBGView.hidden = NO;
        self.tableView.tableHeaderView.frame = CGRectMake(self.tableView.tableHeaderView.MinX, self.tableView.tableHeaderView.MinY, self.tableView.tableHeaderView.Witdh, self.tableView.tableHeaderView.Height + 170);
    }else{
        self.notFundCommentBGView.hidden = YES;
        self.tableView.tableHeaderView.frame = CGRectMake(self.tableView.tableHeaderView.MinX, self.tableView.tableHeaderView.MinY, self.tableView.tableHeaderView.Witdh, self.detailFrame.cellHeight);
    }
}

/**
 * 刷新点赞数据
 */
- (void) refreshLikeBGView
{
    //判断是否大于1w
    CGSize textSize = CGSizeMake(19, 10);
    NSString *content = [NSString stringWithFormat:@"%ld",(long)self.detailFrame.footprintDetailModel.footprintLikeNum];
    if(self.detailFrame.footprintDetailModel.footprintLikeNum<10000){
        textSize = [OTWUtils sizeWithString:content font:likeLabelFont maxSize:CGSizeMake(19, 10)];
        self.plugsLabel.hidden = YES;
    }else{
        self.plugsLabel.hidden = NO;
        content = @"9999";
    }
    CGFloat w = self.plugsLabel.hidden?10:14;
    self.likeSumBGView.frame = CGRectMake(14 , 8.5 , textSize.width + w , 12 );
    self.likeSumLabel.frame = CGRectMake(5, 1, textSize.width, textSize.height);
    self.plugsLabel.frame = CGRectMake(self.likeSumLabel.MaxX, 0, 5, 10);
    self.likeSumLabel.text = content;
}

#pragma mark - 加载更多评论
- (void) loadMoreComment
{
    [self.commentService commentList:nil footprintId:_fid viewController:self completion:nil];
}

#pragma mark - 构建足迹详情View
- (UIView *) buildTableHeaderView
{
    [self.footprintHeaderBGView addSubview:self.footprintDetailBGView];
    [self.footprintHeaderBGView addSubview:self.commentHeaderTopLine];
    [self.footprintHeaderBGView addSubview:self.commentHeaderBGView];
    [self.commentHeaderBGView addSubview:self.commentHeaderImageView];
    [self.commentHeaderBGView addSubview:self.commentHeaderLabel];
    [self.footprintHeaderBGView addSubview:self.notFundCommentBGView];
    [self.notFundCommentBGView addSubview:self.qiangshafaImageView];
    [self.notFundCommentBGView addSubview:self.qiangshafaLabel];
    [self.tableHeaderView addSubview:self.footprintHeaderBGView];
    [self.footprintDetailBGView addSubview:self.topLine];
    [self.footprintDetailBGView addSubview:self.userHeadImgImageView];
    [self.footprintDetailBGView addSubview:self.userNicknameButton];
    [self.footprintDetailBGView addSubview:self.footprintDateCreateLabel];
    if([[OTWUserModel shared].userId.description isEqualToString:self.detailFrame.footprintDetailModel.userId.description]){
        [self.footprintDetailBGView addSubview:self.deleteButton];
    }
    if(self.detailFrame.footprintDetailModel.footprintPhotoArray && self.detailFrame.footprintDetailModel.footprintPhotoArray.count>0){
        [self.footprintDetailBGView addSubview:self.footprintPhotoView];
        [self.footprintPhotoView addSubview:self.photoScrollView];
        self.photoScrollView.delegate = self;
    }
    [self.footprintDetailBGView addSubview:self.footprintContentLabel];
    [self.footprintDetailBGView addSubview:self.footprintAddressImageView];
    [self.footprintDetailBGView addSubview:self.footprintAddressLabel];
    [self.footprintDetailBGView addSubview:self.bottomLine];
    
    [self.userHeadImgImageView setImageWithURL:[NSURL URLWithString:self.detailFrame.footprintDetailModel.userHeadImg]];
    [self.userNicknameButton setTitle:self.detailFrame.footprintDetailModel.userNickname forState:UIControlStateNormal];
    self.footprintDateCreateLabel.text = self.detailFrame.footprintDetailModel.dateCreatedStr;
    self.footprintContentLabel.text = self.detailFrame.footprintDetailModel.footprintContent;
    self.footprintAddressLabel.text = self.detailFrame.footprintDetailModel.footprintAddress;
    return self.tableHeaderView;
}

#pragma mark - Setter

- (NSMutableArray<OTWCommentFrame*>*)commentFrameArray
{
    if (!_commentFrameArray) {
        _commentFrameArray = [[NSMutableArray alloc] init];
    }
    
    return _commentFrameArray;
}

- (OTWFootprintDetailFrame*)detailFrame
{
    if (!_detailFrame) {
        _detailFrame = [[OTWFootprintDetailFrame alloc] init];
    }
    
    return _detailFrame;
}

#pragma mark - 点赞
-(void)likeFootprint:(id)footprintId
{
    if(!footprintId) return;
    [OTWFootprintService likeFootprint:footprintId completion:^(id result, NSError *error) {
        if (result) {
            if ([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]) {
                NSString *tips = @"取消赞";
                if(self.detailFrame.footprintDetailModel.ifLike){
                    self.detailFrame.footprintDetailModel.ifLike = NO;
                    self.detailFrame.footprintDetailModel.footprintLikeNum -- ;
                }else{
                    tips = @"已点赞";
                    self.detailFrame.footprintDetailModel.ifLike = YES;
                    self.detailFrame.footprintDetailModel.footprintLikeNum ++ ;
                }
                [OTWUtils alertSuccess:tips userInteractionEnabled:NO target:self];
                [self setlikeImageViewImage:self.detailFrame.footprintDetailModel.ifLike];
                [self refreshLikeBGView];
            }else{
                [self errorTips:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO];
            }
        }else{
            [self netWorkErrorTips:error];
        }
        self.ifSubLike = NO;
    }];
}

- (UITableView*) tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationHeight-49) style:UITableViewStyleGrouped];
        //_tableView.frame = CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationHeight);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle  = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentFrameArray.count;
}

#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat h = 0.5;
    if(tableView.mj_footer.isHidden){
        h = 10;
    }
    return h;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat h = 0.5;
    if(tableView.mj_footer.isHidden){
        h = 10;
    }
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
    if(h == 0.5){
        sectionView.backgroundColor = [UIColor color_d5d5d5];
    }else{
        sectionView.backgroundColor = [UIColor clearColor];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = [UIColor color_d5d5d5];
        [sectionView addSubview:line2];
        
    }
    return sectionView;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    sectionView.backgroundColor = [UIColor clearColor];
    return sectionView;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.commentFrameArray objectAtIndex:indexPath.row].cellHeight;
}
#pragma mark 点击行
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DLog(@"我点击了：%ld",indexPath.row);
//}

#pragma mark - 返回第indexPath这行对应的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"OTWFootprintComment";
    OTWFootprintDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [OTWFootprintDetailViewCell cellWithTableView:tableView reuseIdentifier:identifier];
        WeakSelf(self);
        cell.block = ^(UITableViewCell *cell){
            //然后使用indexPathForCell方法，就得到indexPath了~
            NSIndexPath *indexPath = [tableView indexPathForCell:cell];
            OTWCommentFrame *commentFrame = weakself.commentFrameArray[indexPath.row];
            OTWPersonalFootprintsListController *personalSiteVC = [OTWPersonalFootprintsListController initWithIfMyFootprint:[[OTWUserModel shared].userId.description isEqualToString:commentFrame.commentModel.userId.description]];
            personalSiteVC.userId = commentFrame.commentModel.userId.description;
            personalSiteVC.userNickname = commentFrame.commentModel.userNickname;
            personalSiteVC.userHeaderImg = commentFrame.commentModel.userHeadImg;
            [weakself.navigationController pushViewController:personalSiteVC animated:YES];
        };
    }
    // 设置数据
    [cell setData:self.commentFrameArray[indexPath.row]];
    //添加长按手势
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressedAct:)];
    [cell.contentView addGestureRecognizer:longPressed];
    return cell;
}

- (void) longPressedAct:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan){
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return;
        //判断评论用户是否是自己
        if([[OTWUserModel shared].userId.description isEqualToString:self.commentFrameArray[indexPath.row].commentModel.userId.description]){
            _deleteCommentId = self.commentFrameArray[indexPath.row].commentModel.commentId.description;
            [self presentViewController:self.alertController animated:YES completion:nil];
        }
    }
}

-(UIAlertController*)alertController
{
    if(!_alertController){
        _alertController = [UIAlertController alertControllerWithTitle:@"" message:@"删除当前评论后数据不可恢复，确定请点击删除。" preferredStyle:UIAlertControllerStyleActionSheet];
        WeakSelf(self);
        [_alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //执行删除方法
            [weakself deleteCommentById];
        }]];
        [_alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _alertController;
}

#pragma mark - 删除足迹评论
- (void) deleteCommentById
{
    if(_deleteCommentId){
        [self.commentService deleteCommentById:_deleteCommentId viewController:self completion:nil];
    }
}

#pragma mark - 底部评论布局
- (UIView *) commentBGView
{
    if(!_commentBGView){
        _commentBGView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _commentBGView.backgroundColor = [UIColor whiteColor];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topLine.backgroundColor = [UIColor color_d5d5d5];
        [_commentBGView addSubview:topLine];
    }
    return _commentBGView;
}

- (UIView *) writeCommentView
{
    if(!_writeCommentView){
        CGFloat W = SCREEN_WIDTH - 160;
        _writeCommentView = [[UIView alloc] initWithFrame:CGRectMake(padding, 7, W , 33)];
        _writeCommentView.layer.cornerRadius = _writeCommentView.Height / 2.0;
        _writeCommentView.backgroundColor = [UIColor color_f4f4f4];
    }
    return _writeCommentView;
}

- (UITextView *) writeCommentTextView
{
    if(!_writeCommentTextView){
        _writeCommentTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.writeCommentImageView.MaxX+5, 6.5, self.writeCommentView.Witdh - 33 - 15 , 20)];
        _writeCommentTextView.font = [UIFont systemFontOfSize:15];
        _writeCommentTextView.textColor = [UIColor color_202020];
        _writeCommentTextView.backgroundColor = [UIColor clearColor];
        _writeCommentTextView.textContainerInset = UIEdgeInsetsMake(0,0, 0, 0);
        _writeCommentTextView.layoutManager.allowsNonContiguousLayout = NO;
        _writeCommentTextView.delegate = self;
        _writeCommentTextView.returnKeyType = UIReturnKeySend;
    }
    return _writeCommentTextView;
}

- (UILabel *) commentLabel
{
    if(!_commentLabel){
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.writeCommentTextView.MinX, self.writeCommentTextView.MinY, 50 , self.writeCommentTextView.Height )];
        _commentLabel.text = @"写评论";
        _commentLabel.textColor = [UIColor color_979797];
        _commentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _commentLabel;
}

- (UIImageView *) writeCommentImageView
{
    if(!_writeCommentImageView){
        _writeCommentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 13, 13)];
        _writeCommentImageView.image = [UIImage imageNamed:@"xiepinglun"];
    }
    return _writeCommentImageView;
}

- (UILabel *) commentSunLabel
{
    if(!_commentSunLabel){
        _commentSunLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.writeCommentView.MaxX + 10, 17.5, 93 , 15)];
        _commentSunLabel.font = [UIFont systemFontOfSize:11];
        _commentSunLabel.textColor = [UIColor color_979797];
    }
    return _commentSunLabel;
}

-(UIView *) likeView
{
    if(!_likeView){
        _likeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 37 - 20, 0, 49, 50)];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLikeAction)];
        [_likeView addGestureRecognizer:tapGesturRecognizer];
        [_likeView addSubview:self.likeImageView];
    }
    return _likeView;
}

- (UIImageView *) likeImageView
{
    if(!_likeImageView){
        _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13.5, 20, 20)];
        [self setlikeImageViewImage:self.detailFrame.footprintDetailModel.ifLike];
        _likeImageView.tintColor = [UIColor redColor];
    }
    return _likeImageView;
}

- (void) setlikeImageViewImage:(BOOL) ifLike
{
    if(ifLike){
        self.likeImageView.image = [UIImage imageNamed:@"zj_zan_click"];
    }else{
        self.likeImageView.image = [UIImage imageNamed:@"zj_zan"];
    }
    
}

- (UIImageView *) shareImageView
{
    if(!_shareImageView){
        _shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-15, 15, 20, 20)];
        _shareImageView.image = [UIImage imageNamed:@"fenxiang"];
    }
    return _shareImageView;
}

#pragma mark - like tap

- (void) tapLikeAction
{
    //设置了一个3秒内不能重复提交
    if(self.likeTime - [NSDate date].timeIntervalSince1970 > -3) return;
    if(self.ifSubLike) return;
    self.likeTime = [NSDate date].timeIntervalSince1970;
    [self likeFootprint:self.detailFrame.footprintDetailModel.footprintId.description];
}

#pragma mark - share tap
- (void) tapShareAction
{
    DLog(@"点击了分享按钮");
}


#pragma mark - 足迹详情布局
- (UIView *) footprintDetailBGView
{
    if(!_footprintDetailBGView){
        _footprintDetailBGView = [[UIView alloc] init];
        _footprintDetailBGView.backgroundColor = [UIColor whiteColor];
        _footprintDetailBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.detailFrame.cellHeight - 46);
    }
    return _footprintDetailBGView;
}

- (UIView*) footprintHeaderBGView
{
    if (!_footprintHeaderBGView) {
        _footprintHeaderBGView = [[UIView alloc] init];
        _footprintHeaderBGView.backgroundColor = [UIColor color_f4f4f4];
        _footprintHeaderBGView.frame = CGRectMake(0, 10, SCREEN_WIDTH, self.detailFrame.cellHeight);
    }
    return _footprintHeaderBGView;
}

- (UIView*)commentHeaderTopLine
{
    if (!_commentHeaderTopLine) {
        _commentHeaderTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.detailFrame.cellHeight - 36 , SCREEN_WIDTH, 0.5)];
        _commentHeaderTopLine.backgroundColor = [UIColor color_d5d5d5];
    }
    return _commentHeaderTopLine;
}

- (UIView*)commentHeaderBGView
{
    if (!_commentHeaderBGView) {
        _commentHeaderBGView = [[UIView alloc] init];
        _commentHeaderBGView.backgroundColor = [UIColor whiteColor];
        CGFloat Y = CGRectGetMaxY(self.commentHeaderTopLine.frame);
        _commentHeaderBGView.frame = CGRectMake(0, Y, SCREEN_WIDTH,36);
    }
    return _commentHeaderBGView;
}

- (UIImageView*)commentHeaderImageView
{
    if (!_commentHeaderImageView) {
        _commentHeaderImageView = [[UIImageView alloc] init];
        _commentHeaderImageView.frame = CGRectMake(15,12.5,10,10);
        [_commentHeaderImageView setImage:[UIImage imageNamed:@"ar_dajiashuo"]];
    }
    return _commentHeaderImageView;
}

- (UILabel*)commentHeaderLabel
{
    if (!_commentHeaderLabel) {
        _commentHeaderLabel = [[UILabel alloc] init];
        CGFloat X = CGRectGetMaxX(self.commentHeaderImageView.frame) + 5;
        _commentHeaderLabel.frame = CGRectMake(X, 10 , 26, 15);
        _commentHeaderLabel.textColor = [UIColor color_979797];
        _commentHeaderLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _commentHeaderLabel.text = @"评论";
    }
    return _commentHeaderLabel;
}

- (UIImageView *) userHeadImgImageView{
    if(!_userHeadImgImageView){
        _userHeadImgImageView = [[UIImageView alloc] init];
        //设置frame
        _userHeadImgImageView.frame = CGRectMake(padding, 15, 45, 45);
        _userHeadImgImageView.layer.cornerRadius = _userHeadImgImageView.Witdh/2.0;
        _userHeadImgImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoAction)];
        _userHeadImgImageView.userInteractionEnabled = YES;
        [_userHeadImgImageView addGestureRecognizer:recognizer];
    }
    return _userHeadImgImageView;
}

- (UIButton *) userNicknameButton{
    if(!_userNicknameButton){
        _userNicknameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat X = self.userHeadImgImageView.MaxX+10;
        //CGFloat W = SCREEN_WIDTH - X - padding;
        _userNicknameButton.frame = CGRectMake(X, 17.5, self.detailFrame.nicknameH, 20);
        [_userNicknameButton setTitleColor:[UIColor color_202020] forState:UIControlStateNormal];
        _userNicknameButton.titleLabel.font = [UIFont systemFontOfSize:16];
        UIImage *imageSeleted = [UIImage imageWithColor:[UIColor color_f4f4f4] size:CGSizeMake(self.detailFrame.nicknameH, 20)];
        UIImage *imageNormal = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.detailFrame.nicknameH, 20)];
        [_userNicknameButton setBackgroundImage:imageNormal forState:UIControlStateNormal];
        [_userNicknameButton setBackgroundImage:imageSeleted forState:UIControlStateHighlighted];
        [_userNicknameButton addTarget:self action:@selector(userInfoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userNicknameButton;
}

- (void) userInfoAction
{
    OTWPersonalFootprintsListController *personalSiteVC = [OTWPersonalFootprintsListController initWithIfMyFootprint:[[OTWUserModel shared].userId.description isEqualToString:self.detailFrame.footprintDetailModel.userId.description]];
    personalSiteVC.userId = self.detailFrame.footprintDetailModel.userId.description;
    personalSiteVC.userNickname = self.detailFrame.footprintDetailModel.userNickname;
    personalSiteVC.userHeaderImg = self.detailFrame.footprintDetailModel.userHeadImg;
    [self.navigationController pushViewController:personalSiteVC animated:YES];
}

- (UILabel *) footprintDateCreateLabel{
    if(!_footprintDateCreateLabel){
        _footprintDateCreateLabel = [[UILabel alloc] init];
        CGFloat Y = self.userNicknameButton.MaxY + 5;
        _footprintDateCreateLabel.frame = CGRectMake(self.userNicknameButton.X, Y , self.detailFrame.dateCreatedStrW, 15);
        _footprintDateCreateLabel.textColor = [UIColor color_979797];
        _footprintDateCreateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _footprintDateCreateLabel;
}

- (UIButton *) deleteButton
{
    if(!_deleteButton){
        _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteButton.frame =CGRectMake(self.footprintDateCreateLabel.MaxX + 5, self.footprintDateCreateLabel.MinY, 31, 15);
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.backgroundColor = [UIColor clearColor];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor color_202020] forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _deleteButton;
}

#pragma mark - 点击删除按钮
- (void) deleteButtonClicked
{
    [self presentViewController:self.deleteAlertController animated:YES completion:nil];
}

- (UIAlertController *) deleteAlertController
{
    if(!_deleteAlertController){
        _deleteAlertController = [UIAlertController alertControllerWithTitle:@"" message:@"删除当前足迹后数据不可恢复，确定请点击删除。" preferredStyle:UIAlertControllerStyleActionSheet];
        WeakSelf(self);
        [_deleteAlertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //执行删除方法
            [weakself deleteFootprintById];
        }]];
        [_deleteAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _deleteAlertController;
}

- (void) deleteFootprintById
{
    [OTWFootprintService deleteFootprintById:self.detailFrame.footprintDetailModel.footprintId.description viewController:self completion:^(id result, NSError *error) {
        if(result){
            [self performSelector:@selector(cacelDetail) withObject:nil afterDelay:1.5f];
        }
    }];
}

- (void) cacelDetail
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *) footprintPhotoView
{
    if(!_footprintPhotoView){
        _footprintPhotoView = [[UIView alloc] init];
        _footprintPhotoView.frame = CGRectMake(padding, self.userHeadImgImageView.MaxY + 15, SCREEN_WIDTH-padding*2, self.detailFrame.photoViewH);
    }
    return _footprintPhotoView;
}

- (UILabel *) footprintContentLabel
{
    if(!_footprintContentLabel){
        _footprintContentLabel = [[UILabel alloc] init];
        _footprintContentLabel.textColor = [UIColor color_202020];
        _footprintContentLabel.font = footprintContentFont;
        _footprintContentLabel.numberOfLines = 0;
        //需计算文字高度
        if(self.detailFrame){
            CGFloat W = SCREEN_WIDTH - padding *2;
            _footprintContentLabel.frame = CGRectMake(padding, self.detailFrame.photoViewH==0?self.footprintPhotoView.MaxY:self.footprintPhotoView.MaxY+10, W, self.detailFrame.contentH);
        }
    }
    return _footprintContentLabel;
}

- (UIImageView *) footprintAddressImageView
{
    if(!_footprintAddressImageView){
        _footprintAddressImageView = [[UIImageView alloc] init];
        _footprintAddressImageView.frame = CGRectMake(padding, self.footprintContentLabel.MaxY+16, 9.8, 9.8);
        _footprintAddressImageView.image = [UIImage imageNamed:@"dinwgei_2"];
    }
    return _footprintAddressImageView;
}

- (UILabel *) footprintAddressLabel
{
    if(!_footprintAddressLabel){
        _footprintAddressLabel = [[UILabel alloc] init];
        _footprintAddressLabel.textColor = [UIColor color_979797];
        _footprintAddressLabel.font = [UIFont systemFontOfSize:13];
        CGFloat W = SCREEN_WIDTH-self.footprintAddressImageView.MaxX-padding-5;
        _footprintAddressLabel.frame = CGRectMake(_footprintAddressImageView.MaxX+4, self.footprintContentLabel.MaxY+15, W, 12);
    }
    return _footprintAddressLabel;
}

- (UIView *) topLine
{
    if(!_topLine){
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _topLine.backgroundColor = [UIColor color_d5d5d5];
    }
    return _topLine;
}

- (UIView *) bottomLine
{
    if(!_bottomLine){
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.footprintDetailBGView.Height+0.5, SCREEN_WIDTH, 0.5)];
        _bottomLine.backgroundColor = [UIColor color_d5d5d5];
    }
    return _bottomLine;
}

- (UIView *) tableHeaderView
{
    if(!_tableHeaderView){
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.detailFrame.cellHeight)];
        _tableHeaderView.backgroundColor = [UIColor clearColor];
    }
    return _tableHeaderView;
}

- (SDCycleScrollView *) photoScrollView
{
    if(!_photoScrollView){
        NSMutableArray *imageUrlStringsGroup = [[NSMutableArray alloc] init];
        for (NSString *url in self.detailFrame.footprintDetailModel.footprintPhotoArray) {
            //增加图片处理参数
            [imageUrlStringsGroup addObject:[url stringByAppendingString:imageView2Params]];
        }
        DLog(@"图片轮播%@",imageUrlStringsGroup.mj_keyValues)
        _photoScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.footprintPhotoView.Witdh, self.footprintPhotoView.Height) imageURLStringsGroup:imageUrlStringsGroup];
        _photoScrollView.autoScroll = NO;
        _photoScrollView.showPageControl = NO;
        //增加分页控制信息
        UIView *pageControllerBGView = [[UIView alloc] initWithFrame:CGRectMake(_photoScrollView.Witdh - 10 - 30, _photoScrollView.Height - 10 - 20 , 30 , 20)];
        pageControllerBGView.backgroundColor = [UIColor blackColor];
        pageControllerBGView.layer.cornerRadius = 1;
        pageControllerBGView.layer.opacity = 0.6;
        [_photoScrollView addSubview:pageControllerBGView];
        [_photoScrollView addSubview:self.photoPageControllerLabel];
        self.photoPageControllerLabel.text = [@"1/" stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)imageUrlStringsGroup.count]];
        //self.photoPageControllerLabel.text = @"9/9";
    }
    return _photoScrollView;
}

- (UILabel *) photoPageControllerLabel
{
    if(!_photoPageControllerLabel){
        _photoPageControllerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.footprintPhotoView.Witdh - 10 - 30, self.footprintPhotoView.Height - 13 - 13.5, 30 , 13)];
        _photoPageControllerLabel.textColor = [UIColor whiteColor];
        _photoPageControllerLabel.font = [UIFont systemFontOfSize:13];
        _photoPageControllerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _photoPageControllerLabel;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    photoBroseView.imagesURL = self.footprintImageUrls;
    photoBroseView.currentIndex = index;
    photoBroseView.showFromView = self.footprintPhotoView;
    photoBroseView.hiddenToView = self.footprintPhotoView;
    //photoBroseView.placeholderImage = [UIImage imageNamed:@"zhanweitu"];
    [photoBroseView show];
}

- (NSMutableArray *) footprintImageUrls
{
    if(!_footprintImageUrls){
        if(self.detailFrame.footprintDetailModel.footprintPhotoArray && self.detailFrame.footprintDetailModel.footprintPhotoArray.count>0){
            _footprintImageUrls = [[NSMutableArray alloc] init];
            for (NSString *url in self.detailFrame.footprintDetailModel.footprintPhotoArray) {
                //这里可能要添加一些参数，目前未添加
                [_footprintImageUrls addObject:url];
            }
        }
    }
    return _footprintImageUrls;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    //改变photoPageControllerLabel
    self.photoPageControllerLabel.text = [[[NSString stringWithFormat:@"%ld",(long)(index + 1)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)self.photoScrollView.imageURLStringsGroup.count]];
    
}

#pragma mark - UITextViewDetegate

- (void)textViewDidChange:(UITextView *)textView{
    [self updateLastTextViewTextHeight];
    [UIView animateWithDuration:0.3 animations:^{
        //改变frame
        if(_openKeyboard){
            self.commentBGView.frame = CGRectMake(self.commentBGView.MinX, self.commentBGView.MinY-self.lastTextViewDifHeight, self.commentBGView.Witdh, self.commentBGView.Height+self.lastTextViewDifHeight);
            self.writeCommentView.frame=CGRectMake(self.writeCommentView.MinX, self.writeCommentView.MinY, self.writeCommentView.Witdh, self.writeCommentView.Height+self.lastTextViewDifHeight);
            self.writeCommentTextView.frame = CGRectMake(self.writeCommentTextView.MinX, self.writeCommentTextView.MinY, self.writeCommentTextView.Witdh, self.lastTextViewTextHeight);
            self.tableView.frame = CGRectMake(self.tableView.MinX, self.tableView.MinY, self.tableView.Witdh, self.tableView.Height-self.lastTextViewDifHeight);
            //加上这句话就不会出现闪一下的问题了
            [self.writeCommentTextView scrollRangeToVisible:NSMakeRange(self.writeCommentTextView.text.length-1, 1)];
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self sentComment];
        [self.writeCommentTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 发送评论
- (void) sentComment
{
    //判断一下  comment内容不能为空
    NSString *content = self.writeCommentTextView.text;
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(content.length == 0){
        return ;
    }
    NSDictionary *commentDict = [NSDictionary dictionaryWithObjectsAndKeys:[self.writeCommentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"content",_fid,@"footprintId",nil];
    [OTWFootprintService releaseComment:commentDict completion:^(id result, NSError *error) {
        if (result) {
            if ([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]) {
                self.writeCommentTextView.text = @"";
                [self textViewDidChange:self.writeCommentTextView];
                self.commentLabel.hidden = NO;
                OTWCommentModel *newCommentModel = [OTWCommentModel mj_objectWithKeyValues:result[@"body"]];
                OTWCommentFrame *newCommentFrame = [[OTWCommentFrame alloc] init];
                [newCommentFrame setCommentModel:newCommentModel];
                [self.commentFrameArray insertObject:newCommentFrame atIndex:0];
                self.detailFrame.footprintDetailModel.footprintCommentNum++;
                self.commentSunLabel.text = [[NSString stringWithFormat:@"%ld",(long)self.detailFrame.footprintDetailModel.footprintCommentNum] stringByAppendingString:@"条评论"];
                //如果沙发显示，需要隐藏一下
                [self refreshTableViewHeader];
                [self.tableView reloadData];
            }else{
                if([result[@"messageCode"] isEqualToString:@"000202"]){
                    [self.indicatorView stopAnimating];
                    self.errorTipsLabel.text = @"足迹已被删除";
                    self.firstLoadingView.hidden = NO;
                    self.tableView.hidden = YES;
                    self.commentBGView.hidden = YES;
                    //发出足迹删除通知
                    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:_fid,@"footprintId", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"foorprintAlreadyDeleted" object:nil userInfo:dict];
                }else{
                    [self errorTips:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO];
                }
            }
        }else{
            [self netWorkErrorTips:error];
        }
    }];
}

#pragma mark - 获取足迹详情
-(void)fetchFootprintDetailById:(id)footprintId
{
    [OTWFootprintService getFootprintDetailById:footprintId completion:^(id result, NSError *error) {
        if (result) {
            if ([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]) {
                OTWFootprintListModel *footprintDetail = [OTWFootprintListModel mj_objectWithKeyValues:result[@"body"]];
                NSArray<OTWCommentModel *> *commentArray = [OTWCommentModel mj_objectArrayWithKeyValuesArray:result[@"body"][@"comments"]];
                if(commentArray && commentArray.count>0){
                    for (OTWCommentModel *commentModel in commentArray) {
                        OTWCommentFrame *commentFrame = [[OTWCommentFrame alloc] init];
                        [commentFrame setCommentModel:commentModel];
                        [self.commentFrameArray addObject:commentFrame];
                    }
                }
                [self.detailFrame setFootprintDetailModel:footprintDetail];
                [self buildTableView];
            }else{
                if([result[@"messageCode"] isEqualToString:@"000202"]){
                    [self.indicatorView stopAnimating];
                    self.errorTipsLabel.text = @"足迹已被删除";
                    //发出足迹删除通知
                    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:_fid,@"footprintId", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"foorprintAlreadyDeleted" object:nil userInfo:dict];
                }else{
                    [self errorTips:@"服务端繁忙，请稍后再试" userInteractionEnabled:NO];
                }
            }
        }else{
            [self netWorkErrorTips:error];
        }
    }];
}

- (CGFloat) updateLastTextViewTextHeight{
    CGFloat minHeight = 20; //最小的高度
    CGFloat maxHeight = 60; //最大的高度
    CGFloat contentSize = 0;
    //设置宽
    self.writeCommentTextView.frame = CGRectMake(self.writeCommentTextView.MinX, self.writeCommentTextView.MinY, self.commentBGView.Witdh - padding * 2 - 15 - 33, self.writeCommentTextView.Height);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        CGRect textFrame=[[self.writeCommentTextView layoutManager]usedRectForTextContainer:[self.writeCommentTextView textContainer]];
        contentSize = textFrame.size.height;
    }else {
        contentSize = self.writeCommentTextView.contentSize.height;
    }
    if (contentSize<minHeight) {
        _lastTextViewTextHeight = minHeight;
    }else if (contentSize>maxHeight){
        _lastTextViewTextHeight = maxHeight;
    }else{
        _lastTextViewTextHeight = contentSize;
    }
    _lastTextViewDifHeight = _lastTextViewTextHeight - self.writeCommentTextView.Height;
    return _lastTextViewTextHeight;
}

- (CGFloat) lastTextViewDifHeight{
    if(!_lastTextViewDifHeight){
        _lastTextViewDifHeight = 0;
    }
    return _lastTextViewDifHeight;
}

- (CGFloat) lastTextViewTextHeight
{
    if(!_lastTextViewTextHeight)
    {
        _lastTextViewTextHeight = 20;
    }
    return _lastTextViewTextHeight;
}

- (UIView *) firstLoadingView
{
    if(!_firstLoadingView){
        _firstLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, 50)];
        _firstLoadingView.backgroundColor = [UIColor clearColor];
        [_firstLoadingView addSubview:self.indicatorView];
        [_firstLoadingView addSubview:self.errorTipsLabel];
    }
    return _firstLoadingView;
}

- (UIActivityIndicatorView *) indicatorView
{
    if(!_indicatorView){
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 15, 0, 30, 30)];
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}

- (UILabel *) errorTipsLabel
{
    if(!_errorTipsLabel){
        _errorTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _errorTipsLabel.textColor = [UIColor color_757575];
        _errorTipsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _errorTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _errorTipsLabel;
}

- (UIView *) notFundCommentBGView
{
    if(!_notFundCommentBGView){
        _notFundCommentBGView = [[UIView alloc] initWithFrame:CGRectMake(0, self.commentHeaderBGView.MaxY, SCREEN_WIDTH, 170)];
        _notFundCommentBGView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor color_d5d5d5];
        [_notFundCommentBGView addSubview:line];
    }
    return _notFundCommentBGView;
}

- (UIImageView *) qiangshafaImageView
{
    if(!_qiangshafaImageView){
        _qiangshafaImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 55 )/2, 40, 55, 72)];
        _qiangshafaImageView.image = [UIImage imageNamed:@"zj_qiangshafa"];
    }
    return _qiangshafaImageView;
}

- (UILabel *) qiangshafaLabel
{
    if(!_qiangshafaLabel){
        _qiangshafaLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 140) / 2, self.qiangshafaImageView.MaxY, 140, 18.5)];
        _qiangshafaLabel.textAlignment = NSTextAlignmentCenter;
        _qiangshafaLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _qiangshafaLabel.textColor = [UIColor color_979797];
        _qiangshafaLabel.text = @"还没人评论~快抢沙发！";
    }
    return _qiangshafaLabel;
}

- (UIView *) likeSumBGView
{
    if(!_likeSumBGView){
        _likeSumBGView = [[UIView alloc] init];
        _likeSumBGView.backgroundColor = [UIColor color_e50834];
        _likeSumBGView.layer.cornerRadius = 6;
    }
    return _likeSumBGView;
}

- (UILabel *) likeSumLabel
{
    if(!_likeSumLabel){
        _likeSumLabel = [[UILabel alloc] init];
        _likeSumLabel.font = likeLabelFont;
        _likeSumLabel.textColor = [UIColor whiteColor];
    }
    return _likeSumLabel;
}

- (UILabel *) plugsLabel
{
    if(!_plugsLabel){
        _plugsLabel = [[UILabel alloc] init];
        _plugsLabel.textColor = [UIColor whiteColor];
        _plugsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:8];
        _plugsLabel.text = @"+";
    }
    return _plugsLabel;
}

- (void) setFid:(NSString *)fid
{
    _fid = fid;
    [self fetchFootprintDetailById:fid];
}

- (OTWCommentService *) commentService
{
    if(!_commentService){
        _commentService = [[OTWCommentService alloc] init];
    }
    return _commentService;
}

@end
