//
//  OTWFootprintDetailController.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintDetailController.h"
#import "OTWFootprintDetailModel.h"
#import "OTWFootprintDetailViewCell.h"
#import "OTWCommentModel.h"
#import "OTWFootprintDetailFrame.h"
#import "OTWCommentFrame.h"

#import <SDCycleScrollView.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <IQKeyboardManager.h>
#import <IQKeyboardReturnKeyHandler.h>

#define footprintContentFont [UIFont systemFontOfSize:17]
#define padding 15

@interface OTWFootprintDetailController () <UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) OTWFootprintDetailModel *model;

@property (nonatomic,strong) UITableView *tableView;
//详情
@property (nonatomic,strong) OTWFootprintDetailFrame *detailFrame;

//评论数据
@property (nonatomic,strong) NSMutableArray<OTWCommentFrame *> *commentFrameArray;

//评论填写区域 start
@property (nonatomic,strong) UIView *commentBGView;
@property (nonatomic,strong) UILabel *commentSunLabel;
@property (nonatomic,strong) UIImageView *likeImageView;
@property (nonatomic,strong) UIImageView *shareImageView;
@property (nonatomic,strong) UIView *writeCommentView;
@property (nonatomic,strong) UIImageView *writeCommentImageView;
@property (nonatomic,strong) UITextField *writeCommentField;
//评论填写区域 end

//足迹详情 start

@property (nonatomic,strong) UIView *tableHeaderView;
@property (nonatomic,strong) UIView *footprintDetailBGView;
@property (nonatomic,strong) UIImageView *userHeadImgImageView;
@property (nonatomic,strong) UILabel *userNicknameLabel;
@property (nonatomic,strong) UILabel *footprintDateCreateLabel;
@property (nonatomic,strong) UIView *footprintPhotoView;
@property (nonatomic,strong) UILabel *footprintContentLabel;
@property (nonatomic,strong) UIImageView *footprintAddressImageView;
@property (nonatomic,strong) UILabel *footprintAddressLabel;
@property (nonatomic,strong) UIView *topLine;
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic,strong) SDCycleScrollView *photoScrollView;
@property (nonatomic,strong) UILabel *photoPageControllerLabel;
@property (nonatomic,assign) BOOL wasKeyboardManagerEnabled;

//足迹详情 end
@property (nonatomic, strong) IQKeyboardReturnKeyHandler  *returnKeyHandler;

@end

@implementation OTWFootprintDetailController

static NSString *imageView2Params = @"?imageView2/1/w/690/h/500";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self buildUI];
    //监听键盘的通知
    self.automaticallyAdjustsScrollViewInsets = NO;
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    [self.writeCommentField resignFirstResponder];
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self.view endEditing:YES];
    
}
-(void)dealloc
{
    self.returnKeyHandler = nil;
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    DLog(@">>>>>>>>>");
    return YES;
}
    /**
     *  当键盘改变了frame(位置和尺寸)的时候调用
     */
- (void) keyboardWillChangeFrameNotify:(NSNotification*)notify
{
        // 0.取出键盘动画的时间
        CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        // 1.取得键盘最后的frame
        CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        // 2.计算控制器的view需要平移的距离
        CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
        // 3.执行动画
        [UIView animateWithDuration:duration animations:^{
            self.tableView.frame = CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT + transformY - self.commentBGView.Height-self.navigationHeight);
            //self.tableViewBottomConstraint.constant = -transformY + self.commentBGView.Height;// tableView的bottom距父视图bottom的距离
            self.commentBGView.transform = CGAffineTransformMakeTranslation(0, transformY);
            [self scrollTableViewToBottom];
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
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    //先通过上一界面传递的id数据   获取足迹详情和加载最近评论信息,在构建页面
    [self model];
     //表格的初始化需要等数据请求完毕
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self buildTableHeaderView];
    //增加底部评论信息
    [self.view addSubview:self.commentBGView];
    [self.commentBGView addSubview:self.writeCommentView];
    [self.writeCommentView addSubview:self.writeCommentImageView];
    [self.commentBGView addSubview:self.commentSunLabel];
    [self.commentBGView addSubview:self.likeImageView];
    [self.commentBGView addSubview:self.shareImageView];
    [self.writeCommentView addSubview:self.writeCommentField];
    self.commentSunLabel.text = [[NSString stringWithFormat:@"%ld",(long)_detailFrame.footprintDetailModel.footprintCommentNum] stringByAppendingString:@"条评论"];
}

- (UIView *) buildTableHeaderView
{
    [self.tableHeaderView addSubview:self.footprintDetailBGView];
    [self.footprintDetailBGView addSubview:self.topLine];
    [self.footprintDetailBGView addSubview:self.userHeadImgImageView];
    [self.footprintDetailBGView addSubview:self.userNicknameLabel];
    [self.footprintDetailBGView addSubview:self.footprintDateCreateLabel];
    if(self.detailFrame.footprintDetailModel.footprintPhotoArray && self.detailFrame.footprintDetailModel.footprintPhotoArray.count>0){
        [self.footprintDetailBGView addSubview:self.footprintPhotoView];
        [self.footprintPhotoView addSubview:self.photoScrollView];
        self.photoScrollView.delegate = self;
    }
    [self.footprintDetailBGView addSubview:self.footprintContentLabel];
    [self.footprintDetailBGView addSubview:self.footprintAddressImageView];
    [self.footprintDetailBGView addSubview:self.footprintAddressLabel];
    [self.footprintDetailBGView addSubview:self.bottomLine];
    
    [self.userHeadImgImageView setImageWithURL:[NSURL URLWithString:_detailFrame.footprintDetailModel.userHeadImg]];
    self.userNicknameLabel.text = _detailFrame.footprintDetailModel.userNickname;
    self.footprintDateCreateLabel.text = _detailFrame.footprintDetailModel.dateCreatedStr;
    self.footprintContentLabel.text = _detailFrame.footprintDetailModel.footprintContent;
    self.footprintAddressLabel.text = _detailFrame.footprintDetailModel.footprintAddress;
    return self.tableHeaderView;
}

- (OTWFootprintDetailModel *) model
{
    if(!_model){
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"OTWFootprintDetail.plist" ofType:nil];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:fullPath];
        _model = [OTWFootprintDetailModel initWithDict:dict];
        _detailFrame = [[OTWFootprintDetailFrame alloc] init];
        [_detailFrame setFootprintDetailModel: _model.footprintDetail];
        _commentFrameArray = [[NSMutableArray alloc] init];
        if(_model.comments){
            for (OTWCommentModel *commentModel in _model.comments) {
                OTWCommentFrame *commentFrame = [[OTWCommentFrame alloc] init];
                [commentFrame setCommentModel:commentModel];
                [_commentFrameArray addObject:commentFrame];
            }
        }
    }
    return _model;
}

- (UITableView*) tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationHeight-49) style:UITableViewStylePlain];
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
    if(_commentFrameArray){
        return _commentFrameArray.count;
    }
    return 0;
}

#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_commentFrameArray){
        return [_commentFrameArray objectAtIndex:indexPath.row].cellHeight;
    }
    return 0;
}
#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
}

#pragma mark - 返回第indexPath这行对应的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OTWFootprintDetailViewCell cellWithTableView:tableView data:[_commentFrameArray objectAtIndex:indexPath.row]];
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
        CGFloat W = SCREEN_WIDTH - 173;
        _writeCommentView = [[UIView alloc] initWithFrame:CGRectMake(padding, 7, W , 33)];
        _writeCommentView.layer.cornerRadius = _writeCommentView.Height / 2.0;
        _writeCommentView.backgroundColor = [UIColor color_f4f4f4];
    }
    return _writeCommentView;
}

- (UITextField *) writeCommentField
{
    if(!_writeCommentField){
        _writeCommentField = [[UITextField alloc] initWithFrame:CGRectMake(self.writeCommentImageView.MaxX+5, 6.5, self.writeCommentView.Witdh - 33 - 15 , 20)];
        _writeCommentField.placeholder = @"写评论";
        [_writeCommentField setValue:[UIColor color_979797] forKeyPath:@"_placeholderLabel.textColor"];
        _writeCommentField.font = [UIFont systemFontOfSize:15];
        _writeCommentField.textColor = [UIColor color_202020];
        _writeCommentField.delegate = self;
    }
    return _writeCommentField;
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
        _commentSunLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.writeCommentView.MaxX + 10, 17.5, 70, 15)];
        _commentSunLabel.font = [UIFont systemFontOfSize:11];
        _commentSunLabel.textColor = [UIColor color_979797];
    }
    return _commentSunLabel;
}

- (UIImageView *) likeImageView
{
    if(!_likeImageView){
        _likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 62 - 17, 15, 17, 17)];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLikeAction)];
        [_likeImageView addGestureRecognizer:tapGesturRecognizer];
        _likeImageView.image = [UIImage imageNamed:@"zan"];
    }
    return _likeImageView;
}

- (UIImageView *) shareImageView
{
    if(!_shareImageView){
        _shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.likeImageView.MaxX + 30 , 16.8, 17, 15)];
        _shareImageView.image = [UIImage imageNamed:@"fenxiang"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShareAction)];
        [_shareImageView addGestureRecognizer:tapGesturRecognizer];
    }
    return _shareImageView;
}

#pragma mark - like tap

- (void) tapLikeAction
{
    DLog(@"点击了点赞按钮");
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
        _footprintDetailBGView.frame = CGRectMake(0, 10, SCREEN_WIDTH, _detailFrame.cellHeight - 10);
    }
    return _footprintDetailBGView;
}

- (UIImageView *) userHeadImgImageView{
    if(!_userHeadImgImageView){
        _userHeadImgImageView = [[UIImageView alloc] init];
        //设置frame
        _userHeadImgImageView.frame = CGRectMake(padding, 15, 45, 45);
        _userHeadImgImageView.layer.cornerRadius = _userHeadImgImageView.Witdh/2.0;
        _userHeadImgImageView.layer.masksToBounds = YES;
    }
    return _userHeadImgImageView;
}

- (UILabel *) userNicknameLabel{
    if(!_userNicknameLabel){
        _userNicknameLabel = [[UILabel alloc] init];
        CGFloat X = self.userHeadImgImageView.MaxX+10;
        CGFloat W = SCREEN_WIDTH - X - padding;
        _userNicknameLabel.frame = CGRectMake(X, 17.5, W, 20);
        _userNicknameLabel.textColor = [UIColor color_202020];
        _userNicknameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _userNicknameLabel;
}

- (UILabel *) footprintDateCreateLabel{
    if(!_footprintDateCreateLabel){
        _footprintDateCreateLabel = [[UILabel alloc] init];
        CGFloat Y = self.userNicknameLabel.MaxY + 5;
        _footprintDateCreateLabel.frame = CGRectMake(self.userNicknameLabel.X, Y , self.userNicknameLabel.Witdh, 15);
        _footprintDateCreateLabel.textColor = [UIColor color_979797];
        _footprintDateCreateLabel.font = [UIFont systemFontOfSize:12];
    }
    return _footprintDateCreateLabel;
}

- (UIView *) footprintPhotoView
{
    if(!_footprintPhotoView){
        _footprintPhotoView = [[UIView alloc] init];
        _footprintPhotoView.frame = CGRectMake(padding, self.userHeadImgImageView.MaxY + 15, SCREEN_WIDTH-padding*2, _detailFrame.photoViewH);
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
        if(_detailFrame){
            CGFloat W = SCREEN_WIDTH - padding *2;
            _footprintContentLabel.frame = CGRectMake(padding, self.footprintPhotoView.MaxY+10, W, _detailFrame.contentH);
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
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _detailFrame.cellHeight)];
        _tableHeaderView.backgroundColor = [UIColor clearColor];
        //        _tableHeaderView.layer.shadowColor = [UIColor blackColor].CGColor;
        //        _tableHeaderView.layer.shadowOpacity = 0.1;
        //        _tableHeaderView.layer.shadowOffset = CGSizeMake(0, -0.5);
        //        _tableHeaderView.layer.shadowRadius = 0.5;
    }
    return _tableHeaderView;
}

- (SDCycleScrollView *) photoScrollView
{
    if(!_photoScrollView){
        NSMutableArray *imageUrlStringsGroup = [[NSMutableArray alloc] init];
        for (NSString *url in _detailFrame.footprintDetailModel.footprintPhotoArray) {
            //增加图片处理参数
            [imageUrlStringsGroup addObject:[url stringByAppendingString:imageView2Params]];
        }
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
    DLog(@"点击图片了");
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    //改变photoPageControllerLabel
    self.photoPageControllerLabel.text = [[[NSString stringWithFormat:@"%ld",(long)(index + 1)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)self.photoScrollView.imageURLStringsGroup.count]];
    
}

#pragma mark - 移除所有delegate
- (void) moveDelegate
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.photoScrollView.delegate = nil;
    _writeCommentField.delegate = nil;
    _writeCommentField = nil;
    self.tableView = nil;
    [self.view removeFromSuperview];
    self.view = nil;
    DLog(@"self moveDelegate");
}

@end
