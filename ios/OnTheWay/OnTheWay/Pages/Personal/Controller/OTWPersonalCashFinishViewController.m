//
//  OTWPersonalCashFinishViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/9/4.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalCashFinishViewController.h"

@interface OTWPersonalCashFinishViewController ()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *finishImg;
@property (nonatomic,strong) UILabel *topOneLabel;
@property (nonatomic,strong) UIView *centerLine;
@property (nonatomic,strong) UILabel *tapTwoLabel;
@property (nonatomic,strong) UIButton *checkBtn;
@property (nonatomic,strong) UILabel *tapThreeLabel;

@end

@implementation OTWPersonalCashFinishViewController

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
    
    [self.contentView addSubview:self.finishImg];
    
    [self.contentView addSubview:self.topOneLabel];
   
    [self.contentView addSubview:self.centerLine];
    
    [self.contentView addSubview:self.tapTwoLabel];
    
    [self.view addSubview: self.checkBtn];
    
    [self.view addSubview:self.tapThreeLabel];
    
}
-(UIView*)contentView{
    if(!_contentView){
        _contentView=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight+10, SCREEN_WIDTH, 226+50)];
        _contentView.layer.borderWidth=0.5;
        _contentView.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        _contentView.backgroundColor=[UIColor whiteColor];
    }
    return _contentView;
}

-(UILabel*)topOneLabel{
    if(!_topOneLabel){
        _topOneLabel=[[UILabel alloc]init];
        _topOneLabel.text=@"提现申请已提交";
        _topOneLabel.textColor=[UIColor color_202020];
        _topOneLabel.font=[UIFont systemFontOfSize:22];
        [_topOneLabel sizeToFit];
        _topOneLabel.frame=CGRectMake((SCREEN_WIDTH-_topOneLabel.Witdh)/2, self.finishImg.MaxY+25, _topOneLabel.Witdh, 31);
    }
    return _topOneLabel;
}

-(UIImageView*)finishImg{
    if(!_finishImg){
        _finishImg=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-110)/2,30, 110, 110)];
        _finishImg.image=[UIImage imageNamed:@"wd_tijiao"];
        _finishImg.layer.masksToBounds=YES;
        _finishImg.layer.cornerRadius = _finishImg.frame.size.width / 2;
    }
    return _finishImg;
}

-(UIView*)centerLine{
    if(!_centerLine){
        _centerLine=[[UIView alloc]initWithFrame:CGRectMake(0, self.topOneLabel.MaxY+30, SCREEN_WIDTH, 0.5)];
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
        [_checkBtn setTitle:@"完成" forState:UIControlStateNormal];
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
    DLog(@"点击了完成");
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
