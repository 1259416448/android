//
//  OTWShopDetailsController.m
//  OnTheWay
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWCustomNavigationBar.h"
#import "OTWShopDetailsController.h"
#import "OTWFootprintListModel.h"
#import "OTWShopDetailsViewCell.h"

@interface OTWShopDetailsController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_status;
    NSMutableArray *icons;
}
@property (nonatomic,strong) UIView *ShopDetailsTableViewHeader;

@property (nonatomic,strong) UIView *ShopDetailsTopTableViewHeader;

@property (nonatomic,strong) UIView *ShopDetailsBottomTableViewHeader;

@property(nonatomic,strong) UIButton *FabiaoButton;

@property (nonatomic,strong) UIImageView *shopImgView;

@end

@implementation OTWShopDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化数据
    [self initData];
    
    [self buildUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController showTabBarWithAnimation:YES];
}

-(void)buildUI{
    //设置标题
    self.title = @"商家详情";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    //创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,65, SCREEN_WIDTH, SCREEN_HEIGHT-65-20) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//将边框去掉
    
    [self.view addSubview:_tableView];
    
    //设置tableview的第一行显示内容
    _tableView.tableHeaderView=self.ShopDetailsTableViewHeader;
    
    [self.view addSubview:self.FabiaoButton];
}
#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _status.count;
}
#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"我点击了：%ld",indexPath.row);
}
#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"findViewCellIdentifierKey2";
    OTWShopDetailsViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[OTWShopDetailsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //在此模块，以便重新布局
    }
    
    OTWFootprintListModel *status=_status[indexPath.row];
    cell.status=status;
    return cell;
}

#pragma mark - 代理方法
#pragma mark 重新设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OTWShopDetailsViewCell *cell = (OTWShopDetailsViewCell *)[self tableView:tableView
                                                       cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


-(void)initData{
    _status = [[NSMutableArray alloc] init];
    NSDictionary *dic=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"他家菜的味道不错，量也很大就是有点小贵，下次考虑还来",@"footprintPhotoArray":@[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg"],@"dateCreatedStr":@"13:09",@"footprintCommentNum":@"126"};
    NSDictionary *dic2=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"他家菜的味道不错，量也很大就是有点小贵，下次考虑还来",@"footprintPhotoArray":@[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg"],@"dateCreatedStr":@"13:09",@"footprintCommentNum":@"126"};
    NSDictionary *dic3=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"围绕着我的卑微 也许能消退 其实我并不在意 有很多机会像巨人一样的无畏放纵我心里的鬼",@"footprintPhotoArray":@[],@"dateCreatedStr":@"13:09",@"footprintCommentNum":@"126"};
    NSDictionary *dic4=@{@"userNickname":@"高世奇",@"userHeadImg":@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg",@"footprintContent":@"围绕着我的卑微 也",@"footprintPhotoArray":@[],@"dateCreatedStr":@"13:09",@"footprintCommentNum":@"126"};
    OTWFootprintListModel *model = [OTWFootprintListModel statusWithDictionary:dic];
    OTWFootprintListModel *model2= [OTWFootprintListModel statusWithDictionary:dic2];
    OTWFootprintListModel *model3= [OTWFootprintListModel statusWithDictionary:dic3];
    OTWFootprintListModel *model4= [OTWFootprintListModel statusWithDictionary:dic4];
    [_status addObject:model];
    [_status addObject:model2];
    [_status addObject:model3];
    [_status addObject:model4];
    
    icons=[[NSMutableArray alloc] init];
    [icons addObject:@"wodekaquan"];
    [icons addObject:@"wodekaquan"];
    [icons addObject:@"wodekaquan"];
    [icons addObject:@"wodekaquan"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UIView*)ShopDetailsTableViewHeader{
    if(!_ShopDetailsTableViewHeader){
        //设置header的背景
        _ShopDetailsTableViewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 165)];
        _ShopDetailsTableViewHeader.backgroundColor=[UIColor clearColor];
        
        //商家信息uiview
        [_ShopDetailsTableViewHeader addSubview: self.ShopDetailsTopTableViewHeader] ;
        
        // 大家说uiview
        [_ShopDetailsTableViewHeader addSubview: self.ShopDetailsBottomTableViewHeader] ;
        
    }
    return _ShopDetailsTableViewHeader;
}
-(UIView*)ShopDetailsTopTableViewHeader{
    if(!_ShopDetailsTopTableViewHeader){
        _ShopDetailsTopTableViewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 110)];
        _ShopDetailsTopTableViewHeader.backgroundColor=[UIColor whiteColor];
        
        _ShopDetailsTopTableViewHeader.layer.borderWidth=0.5;
        _ShopDetailsTopTableViewHeader.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        
        //商店图片
        
            [_ShopDetailsTopTableViewHeader addSubview:self.shopImgView];
        
        
        //商店名称
        UILabel *shopName=[[UILabel alloc] initWithFrame:CGRectMake(self.shopImgView.MaxX+10, 10, SCREEN_WIDTH-15-19-111-20-25, 20)];
        shopName.font=[UIFont systemFontOfSize:16];
        shopName.text=@"胡大饭馆（东直门总店）";
        shopName.textColor=[UIColor color_202020];
        [_ShopDetailsTopTableViewHeader addSubview:shopName];
        
        //商店地址图标
        UIImageView *shopAddressIcon=[[UIImageView alloc] initWithFrame:CGRectMake(self.shopImgView.MaxX+10, shopName.MaxY+10,8, 10)];
        shopAddressIcon.image=[UIImage imageNamed:@"dinwgei_2"];
        [_ShopDetailsTopTableViewHeader addSubview:shopAddressIcon];
        
        //商店地址
        UILabel *shopAddress=[[UILabel alloc] initWithFrame:CGRectMake(shopAddressIcon.MaxX+5, shopName.MaxY+10,SCREEN_WIDTH-self.shopImgView.Witdh-40-30-8-10-6.5, 12)];
        shopAddress.text=@"东城区东直门内大街233";
        shopAddress.font=[UIFont systemFontOfSize:13];
        shopAddress.textColor=[UIColor color_979797];
        [_ShopDetailsTopTableViewHeader addSubview:shopAddress];
        
        //商店电话图标
        UIImageView *shopPhoneIcon=[[UIImageView alloc] initWithFrame:CGRectMake(self.shopImgView.MaxX+10, shopAddress.MaxY+6.5,8, 10)];
        shopPhoneIcon.image=[UIImage imageNamed:@"dianhua"];
        [_ShopDetailsTopTableViewHeader addSubview:shopPhoneIcon];
        
        //商店电话号码
        UILabel *shopPhone=[[UILabel alloc] initWithFrame:CGRectMake(shopPhoneIcon.MaxX+5, shopAddress.MaxY+6.5,SCREEN_WIDTH-self.shopImgView.Witdh-40-30-8-10-6.5, 12)];
        shopPhone.text=@"87474993";
        shopPhone.font=[UIFont systemFontOfSize:11];
        shopPhone.textColor=[UIColor color_979797];
        [_ShopDetailsTopTableViewHeader addSubview:shopPhone];
        
        // 商家券列表
        UIView *quanIconBox=[[UIView alloc]initWithFrame:CGRectMake(self.shopImgView.MaxX+10, shopPhoneIcon.MaxY+6.5,SCREEN_WIDTH-self.shopImgView.Witdh-77-10-30 , 15)];
        for(int i=0;i<icons.count;i++){
            UIImageView *quanIcon=[[UIImageView alloc]initWithFrame:CGRectMake(i*22.5, 0, 15, 15)];
            quanIcon.image=[UIImage imageNamed:icons[i]];
            [quanIconBox addSubview:quanIcon];

        }
   
          [_ShopDetailsTopTableViewHeader addSubview:quanIconBox];
        
        
        //跳转地图图标
        UIImageView *goMapIcon=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-19-25, 15,25, 25)];
        goMapIcon.image=[UIImage imageNamed:@"daohang"];
        [_ShopDetailsTopTableViewHeader addSubview:goMapIcon];
        
        
        UILabel *goMapName=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-37, 45,37, 12)];
        goMapName.text=@"到这去";
        goMapName.font=[UIFont systemFontOfSize:11];
        goMapName.textColor=[UIColor color_979797];
        goMapName.textAlignment=NSTextAlignmentCenter;
        [_ShopDetailsTopTableViewHeader addSubview:goMapName];
        
        
        UIButton *goMap=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-37, 15, 37, 25+5+12)];
        
        [goMap addTarget:self action:@selector(goMapClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_ShopDetailsTopTableViewHeader addSubview:goMap];
        
        //认领商家
        UIView *renlingView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-74, goMapName.MaxY+15, 77, 25)];
         CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        //渐变
         gradientLayer.colors = @[(__bridge id)[UIColor color_ff134c].CGColor, (__bridge id)[UIColor color_ff9144].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, 77,25);
         gradientLayer.locations = @[@0.5, @1.0];
        [renlingView.layer addSublayer:gradientLayer];
        
        renlingView.layer.cornerRadius=3;
        renlingView.layer.masksToBounds = YES;
        renlingView.alpha=0.8;
        
        UIImageView *renlingImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 6, 12.5, 12.5)];
        renlingImg.image=[UIImage imageNamed:@"ar_renling"];
        
        UILabel *renlingName=[[UILabel alloc]initWithFrame:CGRectMake(renlingImg.MaxX+5, 5, 47, 15)];
        renlingName.text=@"认领商家";
        renlingName.textColor=[UIColor whiteColor];
        renlingName.font=[UIFont systemFontOfSize:11];
        
        UITapGestureRecognizer  *tapGestur=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForRenling)];
        [renlingView addGestureRecognizer:tapGestur];
        
        [renlingView addSubview:renlingImg];
        [renlingView addSubview:renlingName];
        [_ShopDetailsTopTableViewHeader addSubview:renlingView];
    }
    return _ShopDetailsTopTableViewHeader;
}
-(UIImageView*)shopImgView{
    if(!_shopImgView){
        _shopImgView=[[UIImageView alloc]init];
        //这里判断商家是否存在图片
        if(1){
            _shopImgView.frame=CGRectMake(15, 10, 111, 80);
            [_shopImgView sd_setImageWithURL:[NSURL URLWithString:[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg" stringByAppendingString:@"?imageView2/1/w/222/h/160"] ]];
            //商店评论条数
            UILabel *shopCommentCount=[[UILabel alloc] init];
            shopCommentCount.text=@"123";
            shopCommentCount.font=[UIFont systemFontOfSize:12];
            [shopCommentCount sizeToFit];
            shopCommentCount.frame=CGRectMake(_shopImgView.width-10-shopCommentCount .frame.size.width-5,  _shopImgView.Height-20, shopCommentCount .frame.size.width+10,15+2.5);
            shopCommentCount.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.6f];
            shopCommentCount.textColor=[UIColor whiteColor];
            shopCommentCount.textAlignment=NSTextAlignmentCenter;
            [_shopImgView addSubview:shopCommentCount];
        }else{
              _shopImgView.frame=CGRectMake(0, 0, 5, 0);
        }
        
    }
    return _shopImgView;
}

-(void)goMapClick{
    DLog(@"点击了到这里去");
}

-(void)tapActionForRenling{
    DLog(@"点击了认领商家");
}
-(UIView*)ShopDetailsBottomTableViewHeader{
    if(!_ShopDetailsBottomTableViewHeader){
        _ShopDetailsBottomTableViewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 35)];
        _ShopDetailsBottomTableViewHeader.backgroundColor=[UIColor whiteColor];
        _ShopDetailsBottomTableViewHeader.layer.borderWidth=0.5;
        _ShopDetailsBottomTableViewHeader.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        
        UIImageView *userSayIcon=[[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 10, 10)];
        userSayIcon.image=[UIImage imageNamed:@"dajiashuo"];
        [_ShopDetailsBottomTableViewHeader addSubview:userSayIcon];
        
        UILabel *userSay=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH-30-15, 15)];
        userSay.text=@"大家说";
        userSay.textColor=[UIColor color_979797];
        userSay.font=[UIFont systemFontOfSize:13];
        [_ShopDetailsBottomTableViewHeader addSubview:userSay];
        
    }
    return _ShopDetailsBottomTableViewHeader;
}
-(UIButton*)FabiaoButton{
    if(!_FabiaoButton){
        _FabiaoButton=[[UIButton alloc] init];
        _FabiaoButton.frame=CGRectMake(SCREEN_WIDTH-15-50, SCREEN_HEIGHT-49-60, 50, 50);
        [_FabiaoButton setImage:[UIImage imageNamed:@"fabiao"] forState:UIControlStateNormal];
        [_FabiaoButton addTarget:self action:@selector(_FabiaoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _FabiaoButton;
}
-(void)_FabiaoButtonClick{
    DLog(@"点击了发表");
}

@end
