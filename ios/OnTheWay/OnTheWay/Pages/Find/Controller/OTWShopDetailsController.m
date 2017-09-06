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

@property (nonatomic,strong) UIView *imgView;

@property (nonatomic,assign) CGFloat photoH;

@property (nonatomic,strong) UILabel *shopName;

@property (nonatomic,strong) UIImageView *shopAddressIcon;

@property (nonatomic,strong) UILabel *shopAddress;

@property (nonatomic,strong) UIImageView *shopPhoneIcon;

@property (nonatomic,strong) UILabel *shopPhone;

@property (nonatomic,strong) UIView *shopActiveView;

@property (nonatomic,strong) UIView *bottomBtnGroup;

@property (nonatomic,strong) UIView *goMapView;

@property (nonatomic,strong) UIView *signInView;

@property (nonatomic,strong) UIView *customRightNavigationBarView;

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
    
    [self setCustomNavigationRightView:self.customRightNavigationBarView];
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
        _ShopDetailsTableViewHeader=[[UIView alloc] init];
        _ShopDetailsTableViewHeader.backgroundColor=[UIColor clearColor];
        
        //商家信息uiview
        [_ShopDetailsTableViewHeader addSubview: self.ShopDetailsTopTableViewHeader] ;
        
        // 大家说uiview
        [_ShopDetailsTableViewHeader addSubview: self.ShopDetailsBottomTableViewHeader] ;
        
        _ShopDetailsTableViewHeader.frame=CGRectMake(0, 0, SCREEN_WIDTH, self.ShopDetailsBottomTableViewHeader.MaxY);
        
    }
    return _ShopDetailsTableViewHeader;
}
-(UIView*)ShopDetailsTopTableViewHeader{
    if(!_ShopDetailsTopTableViewHeader){
        _ShopDetailsTopTableViewHeader=[[UIView alloc] init];
        _ShopDetailsTopTableViewHeader.backgroundColor=[UIColor whiteColor];
        
        _ShopDetailsTopTableViewHeader.layer.borderWidth=0.5;
        _ShopDetailsTopTableViewHeader.layer.borderColor=[UIColor color_d5d5d5].CGColor;

        //商店名称
        [_ShopDetailsTopTableViewHeader addSubview:self.shopName];
        
        //商店地址图标

        [_ShopDetailsTopTableViewHeader addSubview:self.shopAddressIcon];
        
        //商店地址
        
        [_ShopDetailsTopTableViewHeader addSubview:self.shopAddress];
        
        
        //商店电话图标
        
        [_ShopDetailsTopTableViewHeader addSubview:self.shopPhoneIcon];
        
        //商店电话号码
   
        [_ShopDetailsTopTableViewHeader addSubview:self.shopPhone];
        
         //商店图片
        [_ShopDetailsTopTableViewHeader addSubview:self.imgView];
       
        
        // [_ShopDetailsTopTableViewHeader addSubview:self.shopImgView];
        
        // 商家券列表
//        UIView *quanIconBox=[[UIView alloc]initWithFrame:CGRectMake(self.shopImgView.MaxX+10, shopPhoneIcon.MaxY+6.5,SCREEN_WIDTH-self.shopImgView.Witdh-77-10-30 , 15)];
//        for(int i=0;i<icons.count;i++){
//            UIImageView *quanIcon=[[UIImageView alloc]initWithFrame:CGRectMake(i*22.5, 0, 15, 15)];
//            quanIcon.image=[UIImage imageNamed:icons[i]];
//            [quanIconBox addSubview:quanIcon];

      //  }
   
      //   [_ShopDetailsTopTableViewHeader addSubview:quanIconBox];
        
        //优惠活动
        [_ShopDetailsTopTableViewHeader addSubview:self.shopActiveView];
        
        //操作部分
        [_ShopDetailsTopTableViewHeader addSubview:self.bottomBtnGroup];
        
        _ShopDetailsTopTableViewHeader.frame=CGRectMake(0, 10, SCREEN_WIDTH,self.bottomBtnGroup.MaxY );
        
    }
    return _ShopDetailsTopTableViewHeader;
}
-(UILabel*)shopName{
    if(!_shopName){
        _shopName=[[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 20)];
        _shopName.font=[UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _shopName.text=@"胡大饭馆（东直门总店）";
        _shopName.textColor=[UIColor color_202020];
    }
    return _shopName;
}

-(UIImageView*)shopAddressIcon{
    if(!_shopAddressIcon){
        _shopAddressIcon=[[UIImageView alloc] initWithFrame:CGRectMake(15, self.shopName.MaxY+10,13, 13)];
        _shopAddressIcon.image=[UIImage imageNamed:@"dinwgei_2"];
    }
    return _shopAddressIcon;
}

-(UILabel*)shopAddress{
    if(!_shopAddress){
        _shopAddress=[[UILabel alloc] init];
        _shopAddress.text=@"东城区东直门内大街233";
        _shopAddress.font=[UIFont systemFontOfSize:14];
        _shopAddress.textColor=[UIColor color_7d7d7d];
        _shopAddress.numberOfLines=0;
        [_shopAddress sizeToFit];
        _shopAddress.frame=CGRectMake(self.shopAddressIcon.MaxX+5, self.shopName.MaxY+10,SCREEN_WIDTH-15-self.shopAddressIcon.MaxX-5, 12);
        
    }
    return _shopAddress;
}

-(UIImageView*)shopPhoneIcon{
    if(!_shopPhoneIcon){
        _shopPhoneIcon=[[UIImageView alloc] initWithFrame:CGRectMake(15, self.shopAddress.MaxY+6.5,13, 13)];
        _shopPhoneIcon.image=[UIImage imageNamed:@"dianhua"];
    }
    return _shopPhoneIcon;
}

-(UILabel*)shopPhone{
    if(!_shopPhone){
       _shopPhone=[[UILabel alloc] initWithFrame:CGRectMake(self.shopPhoneIcon.MaxX+5, self.shopAddress.MaxY+6.5,SCREEN_WIDTH-15-self.shopPhoneIcon.MaxX-5, 12)];
        _shopPhone.text=@"87474993";
        _shopPhone.font=[UIFont systemFontOfSize:14];
        _shopPhone.textColor=[UIColor color_7d7d7d];
    }
    return _shopPhone;
}

-(UIView*)imgView{
    if(!_imgView){
        _imgView=[[UIView alloc]init];
        int i=4;
        
        if(i>0){
            _imgView.frame=CGRectMake(15,self.shopPhone.MaxY+10, SCREEN_WIDTH-30,self.photoH);
            if(i>3){
                for(int j=0;j<3;j++){
                    UIImageView *shopImgView=[[UIImageView alloc]init];
                    shopImgView.frame=CGRectMake(j*((SCREEN_WIDTH-30-12)/3+6), 0, (SCREEN_WIDTH-30-12)/3, self.photoH);
                    [shopImgView sd_setImageWithURL:[NSURL URLWithString:[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg" stringByAppendingString:@"?imageView2/1/w/222/h/160"] ]];
                     [_imgView addSubview:shopImgView];
                }
                
                UILabel *shopCommentCount=[[UILabel alloc] init];
                shopCommentCount.text=@"+123";
                shopCommentCount.font=[UIFont systemFontOfSize:14];
                [shopCommentCount sizeToFit];
                shopCommentCount.frame=CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-30-12)/3-30, 0,(SCREEN_WIDTH-30-12)/3, self.photoH);
                shopCommentCount.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.6f];
                shopCommentCount.textColor=[UIColor whiteColor];
                shopCommentCount.textAlignment=NSTextAlignmentCenter;
                [_imgView addSubview:shopCommentCount];
                
            }else{
                for(int j=0;j<i;j++){
                    UIImageView *shopImgView=[[UIImageView alloc]init];
                    shopImgView.frame=CGRectMake(j*((SCREEN_WIDTH-30-12)/3+6), 0, (SCREEN_WIDTH-30-12)/3, self.photoH);
                    [shopImgView sd_setImageWithURL:[NSURL URLWithString:[@"http://osx4pwgde.bkt.clouddn.com/16sucai_201401171055.jpg" stringByAppendingString:@"?imageView2/1/w/222/h/160"] ]];
                    [_imgView addSubview:shopImgView];
                }
            }
        }else{
            _imgView.frame=CGRectMake(0,0,0,0);
        }
        
    }
    return _imgView;
}
-(UIView*)shopActiveView{
    if(!_shopActiveView){
        _shopActiveView=[[UIView alloc]init];
        UIView *topCut=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topCut.backgroundColor=[UIColor color_d5d5d5];
        [_shopActiveView addSubview:topCut];
        
        //模拟优惠活动个数
        int k=3;
        if(k>0){
            _shopActiveView.frame=CGRectMake(0, self.imgView.MaxY+10, SCREEN_WIDTH, k*40);
            for(int h=0;h<k;h++){
                if(h==(k-1)){
                    //每个优惠活动的VIEW
                    UIView *oneActiveView=[[UIView alloc]init];
                    oneActiveView.frame=CGRectMake(0, h*40, SCREEN_WIDTH, 40);
                    [_shopActiveView addSubview:oneActiveView];
                    
                    UITapGestureRecognizer  *tapGesturActive=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForActive)];
                    [oneActiveView addGestureRecognizer:tapGesturActive];
                    
                    
                    //活动图标
                    UIImageView *activeIcon=[[UIImageView alloc]initWithFrame:CGRectMake(15, 12.5, 15, 15)];
                    activeIcon.image=[UIImage imageNamed:@"wodekaquan"];
                    [oneActiveView addSubview:activeIcon];
                    
                    //活动 名称
                    UILabel *activeName=[[UILabel alloc]initWithFrame:CGRectMake(activeIcon.MaxX+10, 0, SCREEN_WIDTH-activeIcon.MaxX-10-15-7, 39)];
                    activeName.text=@"送优惠券";
                    activeName.textColor=[UIColor color_757575];
                    activeName.font=[UIFont systemFontOfSize:13];
                    [oneActiveView addSubview:activeName];
                    
                    //活动向右箭头
                    UIImageView *activeArrow=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-7, 15, 7, 12)];
                    activeArrow.image=[UIImage imageNamed:@"arrow_right"];
                    [oneActiveView addSubview:activeArrow];
                    
                }else{
                     DLog(@"%d",k);
                    //每个优惠活动的VIEW
                    UIView *oneActiveView=[[UIView alloc]init];
                    oneActiveView.frame=CGRectMake(0, h*40, SCREEN_WIDTH, 40);
                    [_shopActiveView addSubview:oneActiveView];
                    
                    UITapGestureRecognizer  *tapGesturActive=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForActive)];
                    [oneActiveView addGestureRecognizer:tapGesturActive];
                    
                    //活动图标
                    UIImageView *activeIcon=[[UIImageView alloc]initWithFrame:CGRectMake(15, 12.5, 15, 15)];
                    activeIcon.image=[UIImage imageNamed:@"wodekaquan"];
                    [oneActiveView addSubview:activeIcon];
                    
                    //活动 名称
                    UILabel *activeName=[[UILabel alloc]initWithFrame:CGRectMake(activeIcon.MaxX+10, 0, SCREEN_WIDTH-activeIcon.MaxX-10-15-7, 39)];
                    activeName.text=@"送优惠券";
                    activeName.textColor=[UIColor color_757575];
                    activeName.font=[UIFont systemFontOfSize:13];
                    [oneActiveView addSubview:activeName];
                    
                    //活动向右箭头
                    UIImageView *activeArrow=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-7, 15, 7, 12)];
                    activeArrow.image=[UIImage imageNamed:@"arrow_right"];
                    [oneActiveView addSubview:activeArrow];
                    
                    //下面的间隔线
                    UIView *bottomCut=[[UIView alloc]initWithFrame:CGRectMake(15, 39.5, SCREEN_WIDTH-15, 0.5)];
                    bottomCut.backgroundColor=[UIColor color_d5d5d5];
                    [oneActiveView addSubview:bottomCut];
                }
            }
        }else{
            _shopActiveView.frame=CGRectMake(0, self.imgView.MaxY+10, SCREEN_WIDTH, 0);

        }
    }
    return _shopActiveView;
}

-(void)tapActionForActive{
    DLog(@"点击了优惠");
}
-(UIView*)bottomBtnGroup{
    if(!_bottomBtnGroup){
        _bottomBtnGroup=[[UIView alloc]initWithFrame:CGRectMake(0, self.shopActiveView.MaxY, SCREEN_WIDTH, 44)];
        _bottomBtnGroup.layer.borderWidth=0.5;
        _bottomBtnGroup.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        _bottomBtnGroup.backgroundColor=[UIColor color_f9f9f9];
        
        [_bottomBtnGroup addSubview:self.goMapView];
        [_bottomBtnGroup addSubview:self.signInView];
        
        UIView *centerCut=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 0.5, 44)];
        centerCut.backgroundColor=[UIColor color_d5d5d5];
        [_bottomBtnGroup addSubview:centerCut];
        
    }
    return _bottomBtnGroup;
}

-(UIView*)goMapView{
    if(!_goMapView){
        _goMapView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-0.5)/2, 44)];
        UITapGestureRecognizer  *tapGesturRing=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goMapClick)];
        [_goMapView addGestureRecognizer:tapGesturRing];

        
        UILabel *goMapName=[[UILabel alloc] init];
        goMapName.text=@"到这去";
        goMapName.font=[UIFont systemFontOfSize:12];
        goMapName.textColor=[UIColor color_979797];
        [goMapName sizeToFit];
        goMapName.frame=CGRectMake(((SCREEN_WIDTH-0.5)/2+10+20-goMapName.Witdh)/2, 14.5,goMapName.Witdh, 15);
        [_goMapView addSubview:goMapName];
        
        //图标
        UIImageView *goMapIcon=[[UIImageView alloc] initWithFrame:CGRectMake(goMapName.MinX-10-20, 12,20, 20)];
        goMapIcon.image=[UIImage imageNamed:@"daohang"];
        [_goMapView addSubview:goMapIcon];
        
        
        
    }
    return _goMapView;
}

-(UIView*)signInView{
    if(!_signInView){
        _signInView=[[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-0.5)/2+0.5, 0, (SCREEN_WIDTH-0.5)/2, 44)];
        UITapGestureRecognizer  *tapGesturRing=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionSingIn)];
        [_signInView addGestureRecognizer:tapGesturRing];
        
        
        UILabel *singInName=[[UILabel alloc] init];
        singInName.text=@"签到";
        singInName.font=[UIFont systemFontOfSize:12];
        [singInName sizeToFit];
        singInName.frame=CGRectMake(((SCREEN_WIDTH-0.5)/2+10+20-singInName.Witdh)/2, 14.5,singInName.Witdh, 15);
        //图标
        UIImageView *singInIcon=[[UIImageView alloc] initWithFrame:CGRectMake(singInName.MinX-10-20, 12,20, 20)];
        NSString *status=@"signIn";
        
        if([status isEqualToString:@"signIn"]){
            //已签到
            singInName.textColor=[UIColor color_e50834];
            singInIcon.image=[UIImage imageNamed:@"ar_qiandao_click"];
        }else{
            //没有签到
            singInName.textColor=[UIColor color_979797];
            singInIcon.image=[UIImage imageNamed:@"ar_qiandao"];
        }
        
        [_signInView addSubview:singInName];
        [_signInView addSubview:singInIcon];
        
    }
    return _signInView;
}

-(void)tapActionSingIn{
      DLog(@"点击了签到");
}

-(void)goMapClick{
    DLog(@"点击了到这里去");
}


-(UIView*)ShopDetailsBottomTableViewHeader{
    if(!_ShopDetailsBottomTableViewHeader){
        _ShopDetailsBottomTableViewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, self.bottomBtnGroup.MaxY+20, SCREEN_WIDTH, 35)];
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
-(CGFloat)photoH{
    if(!_photoH || _photoH == 0){
        _photoH=(SCREEN_WIDTH-30-12) /3  *80 /111;
    }
    return _photoH;
}

- (UIView *) customRightNavigationBarView
{
    if(!_customRightNavigationBarView){
        _customRightNavigationBarView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-32, 30, 75, 20)];
        _customRightNavigationBarView.backgroundColor = [UIColor clearColor];
        //分享
        UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(_customRightNavigationBarView.Witdh-20, 0, 20, 20)];
        [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        [_customRightNavigationBarView addSubview: shareBtn];
        [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //收藏
        UIButton *collectBtn=[[UIButton alloc]initWithFrame:CGRectMake(shareBtn.MinX-20-20, 0, 20, 20)];
        [collectBtn setImage:[UIImage imageNamed:@"ar_shoucang"] forState:UIControlStateNormal];
        [_customRightNavigationBarView addSubview: collectBtn];
        [collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _customRightNavigationBarView;
}
-(void)collectBtnClick{
    DLog(@"点击了收藏");
}
-(void)shareBtnClick{
    DLog(@"点击了分享");
}
@end
