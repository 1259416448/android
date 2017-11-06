//
//  OTWPersonalCashCheckViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/9/4.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalCashCheckViewController.h"

#import "OTWPersonalCashFinishViewController.h"

@interface OTWPersonalCashCheckViewController ()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UIView *bankView;
@property (nonatomic,strong) UIImageView *bankImg;
@property (nonatomic,strong) UILabel *bankName;
@property (nonatomic,strong) UILabel *money;
@property (nonatomic,strong) UILabel *tapOneLabel;
@property (nonatomic,strong) UIView *centerLine;
@property (nonatomic,strong) UILabel *tapTwoLabel;
@property (nonatomic,strong) UIButton *checkBtn;
@property (nonatomic,strong) UILabel *tapThreeLabel;

@end

@implementation OTWPersonalCashCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buildUI{
    
    //设置标题
    self.title = @"确认转账信息";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor color_f4f4f4];
    
    [self.view addSubview:self.contentView];
    
    [self.contentView addSubview:self.userName];
    
    [self.contentView addSubview:self.bankView];
    
    [self.bankView addSubview:self.bankName];
    
    [self.bankView addSubview:self.bankImg];
    
    [self.contentView addSubview:self.money];
    
    [self.contentView addSubview:self.tapOneLabel];
    
    [self.contentView addSubview:self.centerLine];
    
    [self.contentView addSubview:self.tapTwoLabel];
    
    [self.view addSubview: self.checkBtn];
    
    [self.view addSubview:self.tapThreeLabel];

}
-(UIView*)contentView{
    if(!_contentView){
        _contentView=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight+10, SCREEN_WIDTH, 253)];
        _contentView.layer.borderWidth=0.5;
        _contentView.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        _contentView.backgroundColor=[UIColor whiteColor];
    }
    return _contentView;
}

-(UILabel*)userName{
    if(!_userName){
        _userName=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 31)];
        _userName.text=@"姚子铭";
        _userName.textColor=[UIColor color_202020];
        _userName.font=[UIFont systemFontOfSize:22];
        _userName.textAlignment=NSTextAlignmentCenter;
    }
    return _userName;
}
-(UIView*)bankView{
    if(!_bankView){
        _bankView=[[UIView alloc]initWithFrame:CGRectMake(0, self.userName.MaxY+5, SCREEN_WIDTH, 20)];
    }
    return _bankView;
}
-(UILabel*)bankName{
    if(!_bankName){
        _bankName=[[UILabel alloc]init];
        _bankName.text=@"招商银行（4325）";
        _bankName.textColor=[UIColor color_979797];
        _bankName.font=[UIFont systemFontOfSize:14];
        [_bankName sizeToFit];
        _bankName.frame=CGRectMake((SCREEN_WIDTH+20-_bankName.Witdh)/2, 0, _bankName.Witdh, 20);
    }
    return _bankName;
}

-(UIImageView*)bankImg{
    if(!_bankImg){
        _bankImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.bankName.MinX-20, 2.5, 15, 15)];
        _bankImg.image=[UIImage imageNamed:@"wd_zhaoshang"];
        _bankImg.layer.masksToBounds=YES;
        _bankImg.layer.cornerRadius = _bankImg.frame.size.width / 2;
    }
    return _bankImg;
}

-(UILabel*)money{
    if(!_money){
        _money=[[UILabel alloc]initWithFrame:CGRectMake(0, self.bankView.MaxY+25, SCREEN_WIDTH, 36)];
        _money.text=@"325.21元";
        _money.textColor=[UIColor color_202020];
        _money.font=[UIFont systemFontOfSize:30];
        _money.textAlignment=NSTextAlignmentCenter;
    }
    return _money;
}

-(UILabel*)tapOneLabel{
    if(!_tapOneLabel){
        _tapOneLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.money.MaxY+5, SCREEN_WIDTH, 20)];
        _tapOneLabel.text=@"免手续费";
        _tapOneLabel.textColor=[UIColor color_979797];
        _tapOneLabel.font=[UIFont systemFontOfSize:14];
        _tapOneLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _tapOneLabel;
}
-(UIView*)centerLine{
    if(!_centerLine){
        _centerLine=[[UIView alloc]initWithFrame:CGRectMake(0, self.tapOneLabel.MaxY+25, SCREEN_WIDTH, 0.5)];
        _centerLine.backgroundColor=[UIColor color_d5d5d5];
    }
    return _centerLine;
}
-(UILabel*)tapTwoLabel{
    if(!_tapTwoLabel){
        _tapTwoLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.centerLine.MaxY+14.5, SCREEN_WIDTH, 18)];
        _tapTwoLabel.text=@"3-5个工作日内到账";
        _tapTwoLabel.textColor=[UIColor color_ff9144];
        _tapTwoLabel.font=[UIFont systemFontOfSize:15];
        _tapTwoLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _tapTwoLabel;
}
-(UIButton*)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_checkBtn setTitle:@"确认提现" forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkBtn.backgroundColor = [UIColor color_e50834];
        _checkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        CGRect submitButtonRect = CGRectMake(30,self.contentView.MaxY+50 , SCREEN_WIDTH - 30*2, 44);
        _checkBtn.frame = submitButtonRect;
        [_checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _checkBtn.layer.cornerRadius = 6;
        _checkBtn.layer.masksToBounds = YES;
        
    }
    return _checkBtn;
}
-(void)checkBtnClick{
    DLog(@"点击了确认提现");
    OTWPersonalCashFinishViewController *personalFinishVC = [[OTWPersonalCashFinishViewController alloc] init];
    [self.navigationController pushViewController:personalFinishVC animated:YES];
}
-(UILabel*)tapThreeLabel{
    if(!_tapThreeLabel){
        _tapThreeLabel=[[UILabel alloc]initWithFrame:CGRectMake(34.5, self.checkBtn.MaxY+15,SCREEN_WIDTH-34.5 , 16.5)];
        _tapThreeLabel.text=@"到账后，会有系统消息通知你";
        _tapThreeLabel.textColor=[UIColor color_979797];
        _tapThreeLabel.font=[UIFont systemFontOfSize:12];
    }
    return _tapThreeLabel;
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
