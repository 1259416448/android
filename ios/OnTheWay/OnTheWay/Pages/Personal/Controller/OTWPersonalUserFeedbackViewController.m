//
//  OTWPersonalUserFeedbackViewController.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalUserFeedbackViewController.h"

@interface OTWPersonalUserFeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIView *userFeedbackContent;
@property (nonatomic,strong) UITextView *userFeedbackContentTextView;
@property (nonatomic,strong) UILabel *userFeedbackContentTips;
@property (nonatomic,strong) UIView *userFeedbackPhone;
@property (nonatomic,strong) UITextField *userFeedbackPhoneTextView;
@property (nonatomic,strong) UIView *customRightNavigationBarView;

@end

@implementation OTWPersonalUserFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bulidUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bulidUI{
    self.title = @"用户反馈";
    self.view.backgroundColor=[UIColor color_f4f4f4];
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
  [self setCustomNavigationRightView:self.customRightNavigationBarView];
    


    //文本框
    [self.userFeedbackContent addSubview:self.userFeedbackContentTextView];
    [self.userFeedbackContent addSubview:self.userFeedbackContentTips];
    
    [self.userFeedbackPhone addSubview:self.userFeedbackPhoneTextView];
  
    //头部线条
    UIView *firstCut=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    firstCut.backgroundColor=[UIColor color_d5d5d5];
    [self.userFeedbackContent addSubview:firstCut];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIView *) customRightNavigationBarView
{
    if(!_customRightNavigationBarView){
        _customRightNavigationBarView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-32, 30, 34, 22.5)];
        _customRightNavigationBarView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 34, 22.5)];
        titleLabel.text = @"提交";
        titleLabel.textColor = [UIColor color_202020];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [_customRightNavigationBarView addSubview:titleLabel];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userFeedbackReleaseTap)];
        [_customRightNavigationBarView addGestureRecognizer:tapGesturRecognizer];
    }
    return _customRightNavigationBarView;
}
-(void)userFeedbackReleaseTap{
    if ([_userFeedbackContentTextView.text isEqualToString:@""] || _userFeedbackContentTextView.text == nil) {
        [OTWUtils alertFailed:@"请先填写反馈内容哦" userInteractionEnabled:NO target:self];
        return;
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * dic = @{@"contactInfo":self.userFeedbackPhoneTextView.text,
                               @"content":self.userFeedbackContentTextView.text};
        NSString * url = @"/app/feedback/create";
        [OTWNetworkManager doPOST:url parameters:dic success:^(id responseObject) {
            if([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"0"]){
                [OTWUtils alertSuccess:@"反馈成功" userInteractionEnabled:NO target:self];
                dispatch_after(5, dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
            
        }];
        
    });
}
-(UIView*)userFeedbackContent{
    if(!_userFeedbackContent){
        _userFeedbackContent=[[UIView alloc]initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, 200)];
        _userFeedbackContent.backgroundColor = [UIColor whiteColor];
    
        [self.view addSubview:_userFeedbackContent];
    }
    return _userFeedbackContent;
}

-(UIView*)userFeedbackPhone{
    if(!_userFeedbackPhone){
        _userFeedbackPhone=[[UIView alloc]initWithFrame:CGRectMake(0, self.userFeedbackContent.MaxY, SCREEN_WIDTH, 50)];
        _userFeedbackPhone.layer.borderWidth=0.5;
         _userFeedbackPhone.backgroundColor = [UIColor whiteColor];
        _userFeedbackPhone.layer.borderColor=[UIColor color_d5d5d5].CGColor;
        [self.view addSubview:_userFeedbackPhone];
    }
    return _userFeedbackPhone;
}
- (UITextView *) userFeedbackContentTextView
{
    if(!_userFeedbackContentTextView){
        _userFeedbackContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.userFeedbackContentTips.MinX, self.userFeedbackContentTips.MinY, SCREEN_WIDTH - self.userFeedbackContentTips.MinX * 2,200 - 30)];
        _userFeedbackContentTextView.textColor = [UIColor color_202020];
        _userFeedbackContentTextView.font = [UIFont systemFontOfSize:15];
        _userFeedbackContentTextView.delegate = self;
        _userFeedbackContentTextView.textContainerInset = UIEdgeInsetsMake(0,0, 0, 0);
        _userFeedbackContentTextView.layoutManager.allowsNonContiguousLayout = NO;
        _userFeedbackContentTextView.textAlignment = NSTextAlignmentLeft;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _userFeedbackContentTextView;
}
- (UILabel*)userFeedbackContentTips{
    
    if(!_userFeedbackContentTips){
        _userFeedbackContentTips = [[UILabel alloc] init];
        _userFeedbackContentTips.text=@"欢迎提出宝贵意见和建议，我们会努力做得更好，不超过500字。";
        _userFeedbackContentTips.textColor = [UIColor color_757575];
        _userFeedbackContentTips.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
         _userFeedbackContentTips.numberOfLines = 0;
        [_userFeedbackContentTips sizeToFit];
        _userFeedbackContentTips.frame=CGRectMake(15, 16, SCREEN_WIDTH-30,46);
        
    }
    
  return _userFeedbackContentTips;
}
- (UITextField *) userFeedbackPhoneTextView
{
    if(!_userFeedbackPhoneTextView){
        _userFeedbackPhoneTextView = [[UITextField alloc] initWithFrame:CGRectMake(15,15,SCREEN_WIDTH-30,20)];
         _userFeedbackPhoneTextView.placeholder = @"留下您的电话，方便与您联系（非必填）";
        _userFeedbackPhoneTextView.backgroundColor = [UIColor clearColor];
        _userFeedbackPhoneTextView.delegate = self;
        _userFeedbackPhoneTextView.tag = 10001;
        _userFeedbackPhoneTextView.font = [UIFont systemFontOfSize:15];
         [_userFeedbackPhoneTextView setValue:[UIColor color_979797] forKeyPath:@"_placeholderLabel.textColor"];

    }
    return _userFeedbackPhoneTextView;
}
#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.userFeedbackContentTips.hidden = YES;
    }

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length == 0){
        self.userFeedbackContentTips.hidden = NO;
             }
}

@end
