//
//  OTWPersonalSiteHowClaimShopViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/17.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalSiteHowClaimShopViewController.h"
#import "OTWSearchShopListViewController.h"

@interface OTWPersonalSiteHowClaimShopViewController ()
@property (nonatomic,strong) UIScrollView *bgView;
@property (nonatomic,strong) UIButton *goClaimBtn;
@property (nonatomic,assign) CGFloat photoH;


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
    
    [self.view addSubview:self.goClaimBtn];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UIScrollView*)bgView{
    if(!_bgView){
        _bgView=[[UIScrollView alloc]init];
        
        
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
        
        UIImageView *imgFirst=[[UIImageView alloc]initWithFrame:CGRectMake(55, titleFirst.MaxY+20, SCREEN_WIDTH-110, self.photoH)];
        imgFirst.image=[UIImage imageNamed:@"wd_diyibu"];
        [_bgView addSubview:imgFirst];
        
        //第二步文字
        UILabel *titleSecond=[[UILabel alloc]initWithFrame:CGRectMake(40, imgFirst.MaxY+20, SCREEN_WIDTH-40*2, 21)];
        titleSecond.textColor=[UIColor color_202020];
        titleSecond.font=[UIFont systemFontOfSize:15];
        titleSecond.text=@"第二步：在搜索框里搜索您想要认领的商家";
      
        [_bgView addSubview:titleSecond];

        
        //第二步图片
    
        UIImageView *imgSecond=[[UIImageView alloc]initWithFrame:CGRectMake(55, titleSecond.MaxY+20, SCREEN_WIDTH-110, self.photoH)];
        imgSecond.image=[UIImage imageNamed:@"wd_dierbu"];
        [_bgView addSubview:imgSecond];
        
        //第三步文字
        UILabel *titleThree=[[UILabel alloc]initWithFrame:CGRectMake(40, imgSecond.MaxY+20, SCREEN_WIDTH-40*2, 21)];
        titleThree.textColor=[UIColor color_202020];
        titleThree.font=[UIFont systemFontOfSize:15];
        
        NSMutableAttributedString *AttributedStrThr = [[NSMutableAttributedString alloc]initWithString:@"第三步：选择您要认领的商家，点击“认领商家”"];
        [AttributedStrThr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor redColor]
                              range:NSMakeRange(17, 4)];
        titleThree.attributedText = AttributedStrThr;
        [_bgView addSubview:titleThree];
        
        //第三步图片
        UIImageView *imgThree=[[UIImageView alloc]initWithFrame:CGRectMake(55, titleThree.MaxY+20, SCREEN_WIDTH-110, self.photoH)];
        imgThree.image=[UIImage imageNamed:@"wd_disanbu"];
        [_bgView addSubview:imgThree];
        //第四步文字
       UILabel *titleFour=[[UILabel alloc]initWithFrame:CGRectMake(40, imgThree.MaxY+20, SCREEN_WIDTH-40*2, 21)];
       titleFour.textColor=[UIColor color_202020];
       titleFour.font=[UIFont systemFontOfSize:15];
       titleFour.text=@"第四步：认真填写申请人信息即可完成认领";
       [_bgView addSubview:titleFour];
        
        //第四步图片
        
        UIImageView *imgFour=[[UIImageView alloc]initWithFrame:CGRectMake(55, titleFour.MaxY+20, SCREEN_WIDTH-110, self.photoH)];
        imgFour.image=[UIImage imageNamed:@"wd_disibu"];
        [_bgView addSubview:imgFour];
        
        _bgView.frame=CGRectMake(0,self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT-44-self.navigationHeight);
        _bgView.contentSize=CGSizeMake(SCREEN_WIDTH, imgFour.MaxY+60);
    }
    return _bgView;
}
-(CGFloat)photoH{
    if(!_photoH || _photoH == 0){
        _photoH=(SCREEN_WIDTH-110)  *150 /265;
    }
    return _photoH;
}

-(UIButton*)goClaimBtn{
    _goClaimBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    [_goClaimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _goClaimBtn.backgroundColor=[UIColor color_e50834];
    _goClaimBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_goClaimBtn setTitle:@"我要认领商家" forState:UIControlStateNormal];
    [_goClaimBtn setImage:[UIImage imageNamed:@"wd_chengweishanghu"] forState:(UIControlStateNormal)];
    [_goClaimBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
     _goClaimBtn.adjustsImageWhenHighlighted = NO;
    [_goClaimBtn addTarget:self action:@selector(goClaimBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return _goClaimBtn;
}
-(void)goClaimBtnClick{
    DLog(@"点击了我要认领商家");
    OTWSearchShopListViewController *findSearchVC = [[OTWSearchShopListViewController alloc] init];
    [self.navigationController pushViewController:findSearchVC animated:NO];

}
@end
