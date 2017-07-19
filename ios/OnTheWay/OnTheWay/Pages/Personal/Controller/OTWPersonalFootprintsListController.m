//
//  OTWPersonalFootprintsListController.m
//  OnTheWay
//
//  Created by apple on 2017/7/18.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalFootprintsListController.h"
#import "OTWPersonalFootprintsListModel.h"
#import "OTWPersonalFootprintsListTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface OTWPersonalFootprintsListController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSMutableArray<OTWPersonalFootprintsListModel *> *_status;
}
@property (nonatomic,strong) UIView *PersonalFootprintsListTableViewHeader;
@property(nonatomic,strong) UILabel *userName;
@property(nonatomic,strong) UIView *headerImgBg;
@property(nonatomic,strong) UIImageView *headerImg;
@property(nonatomic,strong) UIImageView *bgImg;
@property(nonatomic,strong) UILabel *fansNum;
@property(nonatomic,strong) UILabel *centerCell;
@property(nonatomic,strong) UILabel *zanNum;

@end

@implementation  OTWPersonalFootprintsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化数据
    [self initData];
    
    [self buildUI];
}

-(void)initData{
    
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"OTWUserFootprintList.plist" ofType:nil];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fullPath];
    _status = [[NSMutableArray alloc] init];
    if(array && array.count>0){
        for (NSDictionary *dict in array) {
            [_status addObject:[OTWPersonalFootprintsListModel initWithDict:dict]];
        }
    }
}

-(void)buildUI{
    //设置标题
    //    self.title = @"商家详情";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    [self setRightNavigationTitle:@"+ 关注"];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65-20) style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    [self.view addSubview:_tableView];
    
    //设置tableview的第一行显示内容
    _tableView.tableHeaderView=self.PersonalFootprintsListTableViewHeader;
    
}

#pragma mark 返回每组行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _status.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _status[section].monthData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"findViewCellI";
    OTWPersonalFootprintsListTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        
        cell=[[OTWPersonalFootprintsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData:_status[indexPath.section].monthData[indexPath.row]];
    return cell;
}
#pragma mark - 代理方法
#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OTWPersonalFootprintsListTableViewCell *cell = (OTWPersonalFootprintsListTableViewCell *)[self tableView:tableView  cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 0;
    }else{
        return 40;
    }
}

#pragma mark - 自定义分组头
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * sectionHeader=[[UIView alloc] init];
    
    if(section!=0){
        sectionHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH,40);
        sectionHeader .backgroundColor=[UIColor whiteColor];
        
        //月份的左边线条
        UILabel *sectionHeaderLeft=[[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 1,40)];
        sectionHeaderLeft.backgroundColor=[UIColor color_d5d5d5];
        [sectionHeader addSubview:sectionHeaderLeft];
        
        //月份的左边圆点
        UILabel *sectionHeaderCil=[[UILabel alloc] initWithFrame:CGRectMake(20, 9.5, 6,6)];
        sectionHeaderCil.backgroundColor=[UIColor color_202020];
        sectionHeaderCil.layer.cornerRadius = 3;
        sectionHeaderCil.layer.masksToBounds = YES;
        [sectionHeader addSubview:sectionHeaderCil];
        
        //月份的名称
        UILabel *sectionHeaderText=[[UILabel alloc] init];
        sectionHeaderText.text=[_status[section].month stringByAppendingString:@"月"];
        sectionHeaderText.frame=CGRectMake(36, 5, 40, 15);
        sectionHeaderText.font=[UIFont systemFontOfSize:17];
        sectionHeaderText.textColor=[UIColor color_202020];
        [sectionHeader addSubview:sectionHeaderText];
        
    }else{
        sectionHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH,0);
    }
    return sectionHeader;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)PersonalFootprintsListTableViewHeader{
    if(!_PersonalFootprintsListTableViewHeader){
        _PersonalFootprintsListTableViewHeader=[[UIView alloc]init];
        _PersonalFootprintsListTableViewHeader.backgroundColor=[UIColor whiteColor];
        _PersonalFootprintsListTableViewHeader.frame=CGRectMake(0, 0,SCREEN_WIDTH, 191);
        
        //背景图片
        [_PersonalFootprintsListTableViewHeader addSubview:self.bgImg];
        
        //头像背景
        [_PersonalFootprintsListTableViewHeader addSubview:self.headerImgBg];
        //头像
        [self.headerImgBg addSubview:self.headerImg];
        //名称
        [_PersonalFootprintsListTableViewHeader addSubview:self.userName];
        
        //粉丝
        [_PersonalFootprintsListTableViewHeader addSubview:self.fansNum];
        //中间阻隔线
        [_PersonalFootprintsListTableViewHeader addSubview:self.centerCell];
        //被赞
        [_PersonalFootprintsListTableViewHeader addSubview:self.zanNum];
        
    }
    return _PersonalFootprintsListTableViewHeader;
}

-(UILabel*)userName{
    if(!_userName){
        _userName=[[UILabel alloc] initWithFrame:CGRectMake(0,self.headerImgBg.MaxY+10 , SCREEN_WIDTH, 22.5)];
        _userName.text=@"想起一个很长的名字";
        _userName.textColor=[UIColor whiteColor];
        _userName.textAlignment=NSTextAlignmentCenter;
        _userName.font=[UIFont systemFontOfSize:16];
    }
    return _userName;
}
-(UIView*)headerImgBg{
    if(!_headerImgBg){
        _headerImgBg=[[UIView alloc] init];
        _headerImgBg.frame=CGRectMake((SCREEN_WIDTH-90)/2, 1, 90, 90);
        _headerImgBg.layer.cornerRadius=90/2;
        _headerImgBg.layer.masksToBounds = YES;
        _headerImgBg.backgroundColor=[UIColor whiteColor];
    }
    return _headerImgBg;
}

-(UIImageView*)headerImg{
    if(!_headerImg){
        _headerImg=[[UIImageView alloc]init];
        _headerImg.frame=CGRectMake(4, 4, 82, 82);
        [_headerImg setImageWithURL:[NSURL URLWithString:@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg?imageView2/1/w/180/h/180"]];
        _headerImg.layer.cornerRadius=82/2;
        _headerImg.layer.masksToBounds = YES;
    }
    return _headerImg;
}

-(UIImageView*)bgImg{
    if(!_bgImg){
        _bgImg=[[UIImageView alloc]init];
        _bgImg.frame=CGRectMake(0, 0, SCREEN_WIDTH, 171);
        _bgImg.image=[UIImage imageNamed:@"bg"];
    }
    return _bgImg;
}

-(UILabel*)fansNum{
    if(!_fansNum){
        _fansNum=[[UILabel alloc]initWithFrame:CGRectMake(0, self.userName.MaxY+10, SCREEN_WIDTH/2-1-10, 13)];
        _fansNum.text=[@"粉丝" stringByAppendingString:@"1234"] ;
        _fansNum.textColor=[UIColor color_ffe8e3];
        _fansNum.font=[UIFont systemFontOfSize:12];
        _fansNum.textAlignment=NSTextAlignmentRight;
    }
    return _fansNum;
}
-(UILabel*)zanNum{
    if(!_zanNum){
        _zanNum=[[UILabel alloc]initWithFrame:CGRectMake(self.centerCell.MaxX+10,  self.userName.MaxY+10, SCREEN_WIDTH-1-10, 13)];
        _zanNum.text=[@"被赞" stringByAppendingString:@"1234"] ;
        _zanNum.textColor=[UIColor color_ffe8e3];
        _zanNum.font=[UIFont systemFontOfSize:12];
    }
    return _zanNum;
}
-(UILabel*)centerCell{
    if(!_centerCell){
        _centerCell=[[UILabel alloc]initWithFrame:CGRectMake(self.fansNum.MaxX+10,  self.userName.MaxY+12, 1, 10)];
        _centerCell.backgroundColor=[UIColor color_ffe8e3];
        
    }
    return _centerCell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
