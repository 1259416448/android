//
//  OTWPersonalWalletViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/15.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalWalletViewController.h"
#import "OTWPersonalWalletDetailViewController.h"
@interface OTWPersonalWalletViewController (){
    NSNumber *num;
}

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIImageView *balanceIcon;
@property (nonatomic,strong) UILabel *balanceText;
@property (nonatomic,strong) UILabel *balanceNum;
@property (nonatomic,strong) UIButton *cashMoneyBtn;
@property (nonatomic,strong) UIButton *walletDetailBtn;
@property (nonatomic,strong) UIView *contenView;
@property (nonatomic,strong) UIImageView *contentIcon;
@property (nonatomic,strong) UILabel *contentText;

@end

@implementation OTWPersonalWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bulidUI];
    
    //模拟余额数据
    num=[NSNumber numberWithFloat:0.00];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bulidUI{
    self.title = @"我的钱包";
    self.view.backgroundColor=[UIColor whiteColor];
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //背景
    [self.view addSubview:self.bgView];
    
    //提现
    [self.view addSubview:self.cashMoneyBtn];
    //钱包明细
    [self.view addSubview:self.walletDetailBtn];
    //联系客服
    [self.view addSubview:self.contenView];
    //不显示底部菜单
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIView*)bgView{
    if(!_bgView){
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH,290-self.navigationHeight)];
        [_bgView addSubview: self.bgImg];
        [_bgView addSubview: self.balanceIcon];
        [_bgView addSubview: self.balanceText];
        [_bgView addSubview: self.balanceNum];
    }
    return _bgView;
}

-(UIImageView*)bgImg{
    if(!_bgImg){
        _bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,290-self.navigationHeight)];
        _bgImg.image=[UIImage imageNamed:@"wd_bg_2"];
    }
    return _bgImg;
}
-(UIImageView*)balanceIcon{
    if(!_balanceIcon){
        _balanceIcon=[[UIImageView alloc]initWithFrame:CGRectMake(35, 104-self.navigationHeight, 20,20)];
        _balanceIcon.image=[UIImage imageNamed:@"wd_jinbi"];
    }
    return _balanceIcon;
}
-(UILabel*)balanceText{
    if(!_balanceText){
        _balanceText=[[UILabel alloc]initWithFrame:CGRectMake(self.balanceIcon.MaxX+10, 104-self.navigationHeight, 65, 21)];
        _balanceText.text=@"我的余额";
        _balanceText.textColor=[UIColor whiteColor];
        _balanceText.font=[UIFont systemFontOfSize:15];
    }
    return _balanceText;
}

-(UILabel*)balanceNum{
    if(!_balanceNum){
        _balanceNum=[[UILabel alloc]initWithFrame:CGRectMake(35, self.balanceText.MaxY+30, SCREEN_WIDTH-35, 85)];
        _balanceNum.textColor=[UIColor whiteColor];
        _balanceNum.font=[UIFont systemFontOfSize:65];
        if(num.floatValue==0.00){
            _balanceNum.text=@"暂无余额";
        }else{
            _balanceNum.text=[NSString stringWithFormat:@"%ld", (long)num];
        }
    }
    return _balanceNum;
}
-(UIButton*)cashMoneyBtn{
    if(!_cashMoneyBtn){
        _cashMoneyBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, self.bgView.MaxY+80, SCREEN_WIDTH-60, 44)];
        [_cashMoneyBtn setTitle:@"提现" forState:UIControlStateNormal];
        _cashMoneyBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        _cashMoneyBtn.titleLabel.textColor=[UIColor whiteColor];
        [_cashMoneyBtn.layer setMasksToBounds:YES];
        [_cashMoneyBtn.layer setCornerRadius:3.0];
        if(num.floatValue==0.00)
        {
            _cashMoneyBtn.backgroundColor=[UIColor color_d5d5d5];
        }else{
             _cashMoneyBtn.backgroundColor=[UIColor color_e50834];
              [_cashMoneyBtn addTarget:self action:@selector(cashMoneyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        _cashMoneyBtn.showsTouchWhenHighlighted = NO;
     
    }
    return _cashMoneyBtn;
}

-(void)cashMoneyBtnClick{
    DLog(@"点击了提现");
}
-(UIButton*)walletDetailBtn{
    if(!_walletDetailBtn){
        _walletDetailBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, self.cashMoneyBtn.MaxY+15, SCREEN_WIDTH-60, 43)];
        [_walletDetailBtn setTitle:@"钱包明细" forState:UIControlStateNormal];
        _walletDetailBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_walletDetailBtn setTitleColor:[UIColor color_979797] forState:UIControlStateNormal];
        [_walletDetailBtn.layer setMasksToBounds:YES];
        [_walletDetailBtn.layer setCornerRadius:3.0];
        [_walletDetailBtn.layer setBorderWidth:0.5];
        _walletDetailBtn.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        _walletDetailBtn.showsTouchWhenHighlighted = NO;
        [_walletDetailBtn addTarget:self action:@selector(walletDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _walletDetailBtn;
}
-(void)walletDetailBtnClick{
    DLog(@"点击了钱包明细");
 
    OTWPersonalWalletDetailViewController *personalWalletDetailVC = [[OTWPersonalWalletDetailViewController alloc] init];
    [self.navigationController pushViewController:personalWalletDetailVC animated:YES];
}

-(UIView*)contenView{
    if(!_contenView){
        _contenView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_HEIGHT, 49)];
        _contenView.backgroundColor=[UIColor color_f4f4f4];
        
        UIView *firstCut=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 0.5)];
        firstCut.backgroundColor=[UIColor color_d5d5d5];
        [_contenView addSubview:firstCut];
        [_contenView addSubview:self.contentText];
        [_contenView addSubview:self.contentIcon];
        UITapGestureRecognizer  *tapGesturContent=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionForContent)];
        [_contenView addGestureRecognizer:tapGesturContent];
    }
    return _contenView;
}
-(UILabel*)contentText{
    if(!_contentText){
        _contentText=[[UILabel alloc]init];
        _contentText.textColor=[UIColor color_979797];
        _contentText.text=@"联系客服";
        _contentText.font=[UIFont systemFontOfSize:14];
        [_contentText sizeToFit];
        _contentText.frame=CGRectMake((SCREEN_WIDTH-_contentText.Witdh+20+10)/2, 14.5, _contentText.Witdh, 20);
    
    }
    return _contentText;
}
-(UIImageView*)contentIcon{
    if(!_contentIcon){
        _contentIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.contentText.MinX-30, 14.5, 20,20)];
        _contentIcon.image=[UIImage imageNamed:@"wd_kefu"];

    }
    return _contentIcon;
}
-(void)tapActionForContent{
    DLog(@"点击了联系客服");
}
@end
