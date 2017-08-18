//
//  OTWPersonalSiteHowClaimShopViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalSiteHowClaimShopViewController.h"

@interface OTWPersonalSiteHowClaimShopViewController ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *goClaimBtn;

@end

@implementation OTWPersonalSiteHowClaimShopViewController

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
    self.title = @"如何认领商家";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    
    //大背景
    self.view.backgroundColor=[UIColor whiteColor];
    
    //内容大背景
    [self.view addSubview: self.bgView];
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
        _bgView=[[UIView alloc]init];
        _bgView.frame=CGRectMake(0,self.navigationHeight, SCREEN_WIDTH, 500);
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(40, 15, SCREEN_WIDTH-40*2, 21)];
        title.text=@"完成以下四个步骤即可成为商户";
        title.textColor=[UIColor color_202020];
        title.font=[UIFont systemFontOfSize:15];
        [_bgView addSubview:title];
        
        //第一步
        UILabel *titleFirst=[[UILabel alloc]initWithFrame:CGRectMake(40, title.MaxY+20, SCREEN_WIDTH-40*2, 21)];
        titleFirst.textColor=[UIColor color_202020];
        titleFirst.font=[UIFont systemFontOfSize:15];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"第一步：点击下方的“我要认领商家”按钮"];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor redColor]
                              range:NSMakeRange(9, 8)];
        titleFirst.attributedText = AttributedStr;
        [_bgView addSubview:titleFirst];
        
        //第一步图片
        
    }
    return _bgView;
}
@end
