//
//  OTWPersonalInfoController.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/10.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalInfoController.h"
#import "OTWCustomNavigationBar.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OTWUserModel.h"
#import "OTWPersonalEditNicknameController.h"
#import "OTWAlbumSelectHelper.h"
#import "OTWPersonalSiteGanderViewController.h"
#import "QiniuUploadService.h"
#import "MBProgressHUD+PYExtension.h"
#import <MJExtension.h>

static NSString *userImageUrl = @"/app/user/update/image";

@interface OTWPersonalInfoController() <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *personalHeadImageView;
}

@property (nonatomic,strong) UIImage *arrowImge;

@property (nonatomic,strong) UITableView *personalInfoTableView;

@property (nonatomic,strong) NSMutableArray *tableViewLabelArray;

@end

@implementation OTWPersonalInfoController


- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotice) name:@"userEdit" object:nil];
    _arrowImge = [UIImage imageNamed:@"arrow_right"];
    //检查是否登陆，否则跳转到登录界面
    [self initData];
    [self buildUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getNotice
{
    [[OTWUserModel shared] load];
    [self.personalInfoTableView reloadData];
}

#pragma mark - initData
- (void) initData
{
    _tableViewLabelArray = [[NSMutableArray alloc]init];
    [_tableViewLabelArray addObject:@"头像"];
    [_tableViewLabelArray addObject:@"名称"];
    [_tableViewLabelArray addObject:@"性别"];
    //[_tableViewLabelArray addObject:@"地区"];
    [_tableViewLabelArray addObject:@"手机号"];
    //获取用户数据
    [[OTWUserModel shared] load];
}


#pragma mark - UI
-(void)buildUI
{
    //设置头部信息
    self.title=@"个人信息";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    self.view.backgroundColor = [UIColor color_f4f4f4];
    //使用UITableView，展示基本信息
    self.personalInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    self.personalInfoTableView.dataSource = self;
    self.personalInfoTableView.delegate = self;
    self.personalInfoTableView.backgroundColor = [UIColor clearColor];
    // 设置边框颜色
    self.personalInfoTableView.separatorColor= [UIColor color_d5d5d5];
    [self.view addSubview:self.personalInfoTableView];
    
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
    if(indexPath.row==0){
        return 85;
    }
    return 50;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0: // 头像
        {
            [[OTWAlbumSelectHelper shared] showInViewController:self imageBlock:^(UIImage *image) {
                if (image) {
                    [self uploadImageToServer:image];
                }
            }];
        }
            break;
        case 1:
        {
            OTWPersonalEditNicknameController *personalEditNicknameVC = [[OTWPersonalEditNicknameController alloc] init];
            [self.navigationController pushViewController:personalEditNicknameVC animated:YES];
        }
            break;
        case 2:
        {
            OTWPersonalSiteGanderViewController *personalSiteGanderVC = [[OTWPersonalSiteGanderViewController alloc] init];
            [self.navigationController pushViewController:personalSiteGanderVC animated:YES];
        }
            
        default:
            break;
    }
}

#pragma mark 返回第indexPath这行对应的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     四种style，分别是
     Default : 不显示detailTextLabel
     Value1 : 在右边显示detailTextLabel
     Value2 : 不显示图片，显示detailTextLabel
     Subtitle : 在底部显示detailTextLabel
     */
    
    
    UITableViewCell *cell;
    
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self setCellLabel:cell cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text =_tableViewLabelArray[indexPath.row] ;
        cell.textLabel.textColor = [UIColor color_202020];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row != _tableViewLabelArray.count-1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if(indexPath.row == 0){
            UIView *personalHeadImageBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 73, 55)];
            NSURL *url ;
            if(![OTWUserModel shared].headImg){
                url = [NSURL URLWithString:@"https://sources.cc520.me/share/img/o_1b4t0srq81sm31g699lk1ob1e7r3t4.jpg?imageView2/1/w/78/h/78"];
            }else{
                url = [NSURL URLWithString:[OTWUserModel shared].headImg];
            }
            personalHeadImageView = [[UIImageView alloc] init];
            personalHeadImageView.frame = CGRectMake(0, 0, 55, 55);
            personalHeadImageView.layer.cornerRadius = personalHeadImageView.Witdh/2.0;
            personalHeadImageView.layer.masksToBounds = YES;
            //UIImage *personalHeadImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [personalHeadImageView setImageWithURL:url];
            UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55+10, (personalHeadImageBGView.Height-15)/2 , 8, 15)];
            [backImageView setImage: _arrowImge ];
            [personalHeadImageBGView addSubview: backImageView];
            [personalHeadImageBGView addSubview:personalHeadImageView];
            cell.accessoryView = personalHeadImageBGView;
        }else{
            if(indexPath.row==1){
                cell.detailTextLabel.text = [OTWUserModel shared].name;
            }else if(indexPath.row==2){
                if([[OTWUserModel shared].gender isEqualToString:@"secrecy"]){
                    cell.detailTextLabel.text =@"未设置";
                }else if([[OTWUserModel shared].gender isEqualToString:@"man"]){
                    cell.detailTextLabel.text =@"男";
                }else{
                    cell.detailTextLabel.text =@"女";
                }
            }else if(indexPath.row==3){
                cell.detailTextLabel.text =[[OTWUserModel shared].mobilePhoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4)  withString:@"****"];
            }
            cell.detailTextLabel.textColor = [UIColor color_202020];
            if(indexPath.row != _tableViewLabelArray.count-1){
                UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 8, 15)];
                [backImageView setImage: _arrowImge ];
                cell.accessoryView =backImageView;
            }
        }
        
    }
    
    return cell;
}

-(void)uploadImageToServer:(UIImage *)image
{
    //上传图片到七牛
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.label.text = @"正在上传头像";
    [QiniuUploadService uploadImage:image progress:^(NSString *key, float progress) {
        DLog(@"已成功上传了 progress %f",progress);
    } success:^(OTWDocument *document) {
        NSDictionary *documentDict = document.mj_keyValues;
        [self sendRequest:documentDict completion:^(id result, NSError *error) {
            if (result) {
                [hud hideAnimated:YES];
                if([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]){
                    //保存用户信息
                    [OTWUserModel shared].headImg = result[@"body"][@"headImg"];
                    [[OTWUserModel shared] dump];
                    //推送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userEdit" object:self];
                    personalHeadImageView.image = image;
                    [self errorTips:@"上传成功" userInteractionEnabled:NO];
                }else{
                    DLog(@"message - %@  messageCode - %@",result[@"message"],result[@"messageCode"]);
                    [self errorTips:@"上传失败，请检查您的网络是否连接" userInteractionEnabled:YES];
                }
            }
        }];
    } failure:^{
        [hud hideAnimated:YES];
        [self errorTips:@"头像失败，请检查您的网络是否连接" userInteractionEnabled:YES];
    }];
}

-(void)sendRequest:(NSDictionary *)params completion:(requestCompletionBlock)block
{
    [OTWNetworkManager doPOST:userImageUrl parameters:params success:^(id responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}

- (void)setCellLabel:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1){
        cell.detailTextLabel.text = [OTWUserModel shared].name;
    }
    if (indexPath.row==2) {
        if([[OTWUserModel shared].gender isEqualToString:@"secrecy"]){
            cell.detailTextLabel.text =@"未设置";
        }else if([[OTWUserModel shared].gender isEqualToString:@"man"]){
            cell.detailTextLabel.text =@"男";
        }else{
            cell.detailTextLabel.text =@"女";
        }
    }
}


@end
