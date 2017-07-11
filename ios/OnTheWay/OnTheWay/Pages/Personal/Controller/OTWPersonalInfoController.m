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

@interface OTWPersonalInfoController() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImage *arrowImge;

@property (nonatomic,strong) NSMutableArray *tableViewLabelArray;

@end

@implementation OTWPersonalInfoController

- (void)viewDidLoad{
    [super viewDidLoad];
    _arrowImge = [UIImage imageNamed:@"arrow_right"];
    //检查是否登陆，否则跳转到登录界面
    [self initData];
    [self buildUI];
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
    UITableView *personalInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,66, SCREEN_WIDTH, SCREEN_HEIGHT-74) style:UITableViewStyleGrouped];
    personalInfoTableView.dataSource = self;
    personalInfoTableView.delegate = self;
    personalInfoTableView.backgroundColor = [UIColor color_f4f4f4];
    // 设置边框颜色
    personalInfoTableView.separatorColor= [UIColor color_d5d5d5];
    [self.view addSubview:personalInfoTableView];
    
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
    DLog(@"我点击了：%ld",indexPath.row);
    if(indexPath.row==1){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        OTWPersonalEditNicknameController *personalEditNicknameVC = [[OTWPersonalEditNicknameController alloc] init];
        [self.navigationController pushViewController:personalEditNicknameVC animated:YES];
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
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text =_tableViewLabelArray[indexPath.row] ;
        cell.textLabel.textColor = [UIColor color_202020];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.backgroundColor = [UIColor whiteColor];
        
        if(indexPath.row != _tableViewLabelArray.count-1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.row == 0){
            UIView *personalHeadImageBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 73, 55)];
            NSURL *url ;
            if(![OTWUserModel shared].headImg){
                url = [NSURL URLWithString:@"https://sources.cc520.me/share/img/o_1b4t0srq81sm31g699lk1ob1e7r3t4.jpg?imageView2/1/w/78/h/78"];
            }else{
                url = [NSURL URLWithString:[OTWUserModel shared].headImg];
            }
            UIImageView *personalHeadImageView = [[UIImageView alloc] init];
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

@end
