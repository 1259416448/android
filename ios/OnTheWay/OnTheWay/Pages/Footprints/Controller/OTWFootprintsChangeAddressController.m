//
//  OTWFootprintsChangeAddressController.m
//  OnTheWay
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWFootprintsChangeAddressController.h"
#import "OTWFootprintsChangeAddressModel.h"
#import "OTWFootprintsChangeAddressCellTableViewCell.h"

@interface OTWFootprintsChangeAddressController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *footprintTableView;
@property (nonatomic,strong) UISearchBar *footprintSearchAddress;

@end
@implementation OTWFootprintsChangeAddressController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI
{
    //设置标题
    self.title = @"所在地址";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    
    [self.view addSubview:self.footprintTableView];
    
}

-(UITableView *)footprintTableView{
    if(!_footprintTableView){
        _footprintTableView=[[UITableView alloc] init];
    }
    return _footprintTableView;
}
@end
