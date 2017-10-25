
//
//  OTWNewFootprintsControllerViewController.m
//  OnTheWay
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWNewFootprintsControllerViewController.h"

#import "OTWNewFootprintsTableViewCell.h"

#import "OTWCustomNavigationBar.h"

#import "OTWFootprintListModel.h"

@interface OTWNewFootprintsControllerViewController ()<UITableViewDataSource,UITableViewDelegate>{
        UITableView *_tableView;
       NSMutableArray *_status;
}

@end

@implementation OTWNewFootprintsControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initData
{
    _status = [[NSMutableArray alloc] init];
    NSDictionary *dic=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"他家菜的味道不错，量也很大就是有点小贵，下次考虑还来",@"footprintPhotoArray":@[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg"],@"dateCreatedStr":@"13:09",@"footprintAddress":@"北大街连回路33号"};
    NSDictionary *dic2=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"他家菜的味道不错，量也很大就是有点小贵，下次考虑还来",@"footprintPhotoArray":@[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg"],@"dateCreatedStr":@"13:09",@"footprintAddress":@"北大街连回路33号"};
    NSDictionary *dic3=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"围绕着我的卑微 也许能消退 其实我并不在意 有很多机会像巨人一样的无畏放纵我心里的鬼",@"footprintPhotoArray":@[],@"dateCreatedStr":@"13:09",@"footprintAddress":@"北大街连回路33号"};
    NSDictionary *dic4=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"围绕着我的卑微 也",@"footprintPhotoArray":@[],@"dateCreatedStr":@"13:09",@"footprintAddress":@"北大街连回路33号"};
    OTWFootprintListModel *model = [OTWFootprintListModel statusWithDictionary:dic];
    OTWFootprintListModel *model2= [OTWFootprintListModel statusWithDictionary:dic2];
    OTWFootprintListModel *model3= [OTWFootprintListModel statusWithDictionary:dic3];
    OTWFootprintListModel *model4= [OTWFootprintListModel statusWithDictionary:dic4];
    [_status addObject:model];
    [_status addObject:model2];
    [_status addObject:model3];
    [_status addObject:model4];
    //获取用户数据
}
-(void)buildUI {
    //设置标题
    self.title = @"新的足迹动态";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    [self.view addSubview:_tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 这一组里面有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _status.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
}
#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"OTWNewFootprintsTableViewCellCellIdentifierK";
    OTWNewFootprintsTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWNewFootprintsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
    
    }

    [cell setData:_status[indexPath.row]];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OTWNewFootprintsTableViewCell *cell = (OTWNewFootprintsTableViewCell *)[self tableView:tableView
                                                       cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
