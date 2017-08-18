//
//  OTWPersonalCollectController.m
//  OnTheWay
//
//  Created by apple on 2017/7/26.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalCollectController.h"
#import "OTWCustomNavigationBar.h"
#import "OTWPersonalCollectTableViewCell.h"

@interface OTWPersonalCollectController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView;
    NSMutableArray *status;
}
@property (nonatomic,strong) UIView *noResultView;
@property (nonatomic,strong) UIImageView *noResultImage;
@property (nonatomic,strong) UILabel *noResultLabelOne;
@property (nonatomic,strong) UILabel *noResultLabelTwo;
@end

@implementation OTWPersonalCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI {
    //设置标题
    self.title = @"我的收藏";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    //有收藏
    //[self.view addSubview:tableView];
    
    //无收藏
    [self.view addSubview:self.noResultView];
    
    //不显示底部菜单
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"OTWPersonalCollectTableViewCellCellIdentifierK";
    OTWPersonalCollectTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWPersonalCollectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(UIView*)noResultView{
    if(!_noResultView){
        _noResultView=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight+1, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationHeight)];
        _noResultView.backgroundColor=[UIColor whiteColor];
        [_noResultView addSubview:self.noResultImage];
        [_noResultView addSubview:self.noResultLabelOne];
        [_noResultView addSubview:self.noResultLabelTwo];
    }
    
    return _noResultView;
}
-(UIImageView*)noResultImage{
    if(!_noResultImage){
        _noResultImage=[[UIImageView alloc]init];
        _noResultImage.frame=CGRectMake((SCREEN_WIDTH-151)/2, 130, 151, 109);
        _noResultImage.image=[UIImage imageNamed:@"wd_wushoucang"];
    }
    return _noResultImage;
}

-(UILabel*)noResultLabelOne{
    if(!_noResultLabelOne){
        _noResultLabelOne=[[UILabel alloc]init];
        _noResultLabelOne.text=@"你还没有任何收藏呢";
        _noResultLabelOne.font=[UIFont systemFontOfSize:13];
        _noResultLabelOne.textColor=[UIColor color_979797];
        [_noResultLabelOne sizeToFit];
        _noResultLabelOne.frame=CGRectMake(0, self.noResultImage.MaxY+15, SCREEN_WIDTH, _noResultLabelOne.Height);
        _noResultLabelOne.textAlignment=NSTextAlignmentCenter;
    }
    return _noResultLabelOne;
}

-(UILabel*)noResultLabelTwo{
    if(!_noResultLabelTwo){
        _noResultLabelTwo=[[UILabel alloc]init];
        _noResultLabelTwo.text=@"赶快行动起来吧";
        _noResultLabelTwo.font=[UIFont systemFontOfSize:13];
        _noResultLabelTwo.textColor=[UIColor color_979797];
        [_noResultLabelTwo sizeToFit];
        _noResultLabelTwo.frame=CGRectMake(0, self.noResultLabelOne.MaxY+10, SCREEN_WIDTH, _noResultLabelTwo.Height);
        _noResultLabelTwo.textAlignment=NSTextAlignmentCenter;
    }
    return _noResultLabelTwo;
}
@end
