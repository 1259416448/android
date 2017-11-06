//
//  OTWPersonalSiteGanderViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/7/27.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalSiteGanderViewController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWPersonalInfoController.h"
#import "MBProgressHUD+PYExtension.h"
#import "OTWUserModel.h"

static NSString *genderUrl = @"/app/user/update/gender";

@interface OTWPersonalSiteGanderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *tableViewLabelArray;
@property (nonatomic,strong) UIImage *checkImge;
@property (nonatomic,strong) UITableView *personalGanderTableView;

@end

@implementation OTWPersonalSiteGanderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _checkImge = [UIImage imageNamed:@"xuanze"];
    //检查是否登陆，否则跳转到登录界面
    [self initData];
    [self buildUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void) initData
{
    _tableViewLabelArray = [[NSMutableArray alloc]init];
    //初始化可变字典
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"男",@"genderName",@"man",@"gender",nil];
    //初始化一个空的可变字典
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"女",@"genderName",@"woman",@"gender",nil];
    [_tableViewLabelArray addObject:dic1];
    [_tableViewLabelArray addObject:dic2];
 
}

#pragma mark - UI
-(void)buildUI
{
    //设置头部信息
    self.title=@"性别";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    self.view.backgroundColor = [UIColor color_f4f4f4];
    //使用UITableView，展示基本信息
    self.personalGanderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    self.personalGanderTableView.dataSource = self;
    self.personalGanderTableView.delegate = self;
    self.personalGanderTableView.backgroundColor = [UIColor clearColor];
    // 设置边框颜色
    self.personalGanderTableView.separatorColor= [UIColor color_d5d5d5];
    [self.view addSubview:self.personalGanderTableView];
    
}
#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableViewLabelArray.count;
}

#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self saveGender:self.tableViewLabelArray[indexPath.row]];
}

#pragma mark 返回第indexPath这行对应的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        //设置行的icon图片
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text =[_tableViewLabelArray[indexPath.row] objectForKey:@"genderName"];
        cell.textLabel.textColor = [UIColor color_202020];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if([[_tableViewLabelArray[indexPath.row] objectForKey:@"gender"] isEqualToString:[OTWUserModel shared].gender]){
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 13.13, 14)];
        [backImageView setImage: _checkImge ];
        cell.accessoryView =backImageView;
    }
    return cell;
}

-(void)saveGender:(NSMutableDictionary *)genderObj
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.activityIndicatorColor = [UIColor whiteColor];
    [self sendRequest:genderObj completion:^(id result, NSError *error) {
        if (result) {
            [hud hideAnimated:YES];
            if ([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]) {
                //保存用户信息
                [OTWUserModel shared].gender = genderObj[@"gender"];
                [[OTWUserModel shared] dump];
                //推送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userEdit" object:self];
                [self errorTips:@"修改成功" userInteractionEnabled:NO];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),2.0*NSEC_PER_SEC, 0); //2秒后执行
                dispatch_source_set_event_handler(_timer, ^{
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                });
                dispatch_resume(_timer);
            } else {
                [self netWorkErrorTips:error];
            }
        }
    }];
}

-(void)sendRequest:(NSDictionary *)params completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doPOST:genderUrl parameters:params success:^(id responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

@end
