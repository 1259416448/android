//
//  OTWAddNewShopNextViewController.m
//  OnTheWay
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWAddNewShopNextViewController.h"
#import "CreateShopModel.h"
#import "CreateShopFormModel.h"
#import "CreateShopTFCell.h"
#import "CreateShopTVCell.h"
#import "CreateShopTVTWOCell.h"
#import "CreateShopPicCell.h"
#import "CreateShopAddressCell.h"
#import "CreateShopCardPicCell.h"
#import "OTWBusinessExpand.h"
#import "QiniuUploadService.h"
#import "OTWBusinessService.h"
#import "OTWSearchShopListViewController.h"
#import <MJExtension.h>

@interface OTWAddNewShopNextViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *tableViewData;
@property (nonatomic,strong) NSMutableArray *tableViewDataOfForm;
@property (nonatomic,strong) NSMutableArray *tableViewDataOfIdentityCard;
@property (nonatomic,strong) NSMutableArray *tableViewDataOfLicenceCard;

@property (nonatomic,strong) UIView *shopHeaderV;
@property (nonatomic,strong) UIView *shopHeaderBGV;
@property (nonatomic,strong) UILabel *shopNameV;
@property (nonatomic,strong) UIImageView *shopLocationV;
@property (nonatomic,strong) UILabel *shopLocatioinContentV;
@property (nonatomic,strong) UIImageView *shopTelephoneV;
@property (nonatomic,strong) UILabel *shopTelephoneContentV;
@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *submitButton;
@property (nonatomic,strong) CreateShopFormModel *createShopFormModel;

@end

@implementation OTWAddNewShopNextViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[OTWLaunchManager sharedManager].mainTabController hiddenTabBarWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setBase
{
    self.title = @"提交认领资料";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor = [UIColor color_f4f4f4];
    DLog(@"formData%@",self.createShopFormModel.mj_keyValues);
    [self reloadShopHeaderV];
    [self.shopHeaderV addSubview:self.shopNameV];
    [self.shopHeaderV addSubview:self.shopLocationV];
    [self.shopHeaderV addSubview:self.shopLocatioinContentV];
    [self.shopHeaderV addSubview:self.shopTelephoneV];
    [self.shopHeaderV addSubview:self.shopTelephoneContentV];
    [self.shopHeaderBGV addSubview:self.shopHeaderV];
    [self.view addSubview:self.tableV];
    [self initDataSource];
}

- (void)reloadShopHeaderV
{
    CGFloat X = CGRectGetMaxX(self.shopLocationV.frame) + 5;
    CGFloat Y = CGRectGetMaxY(self.shopNameV.frame) + 10;
    CGFloat W = SCREEN_WIDTH - 15*2 - 13 - 5;
    CGSize addressSize=[self.createShopFormModel.address boundingRectWithSize:CGSizeMake(W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    CGRect addressRect = CGRectMake(X, Y, addressSize.width, addressSize.height);
    self.shopLocatioinContentV.frame = addressRect;
    CGFloat shopHeaderVH = 0.f;
    if (![self bInputIsEmpty:self.createShopFormModel.contactInfo]) {
        shopHeaderVH = CGRectGetMaxY(self.shopTelephoneContentV.frame) + 15;
        self.shopTelephoneV.hidden = NO;
        self.shopTelephoneContentV.hidden = NO;
    } else {
        shopHeaderVH = CGRectGetMaxY(self.shopLocatioinContentV.frame) + 15;
        self.shopTelephoneV.hidden = YES;
        self.shopTelephoneContentV.hidden = YES;
    }
    self.shopHeaderV.frame = CGRectMake(0, 10, SCREEN_WIDTH, shopHeaderVH);
    DLog(@"%f",shopHeaderVH);
    self.shopHeaderBGV.frame = CGRectMake(0, 0, SCREEN_WIDTH, shopHeaderVH + 10*2);

}

- (void)initDataSource
{
    self.shopNameV.text = self.createShopFormModel.shopName;
    self.shopLocatioinContentV.text = self.createShopFormModel.address;
    self.shopTelephoneContentV.text = self.createShopFormModel.contactInfo;
    
    CreateShopModel *userNameModel = [[CreateShopModel alloc] init];
    userNameModel.title = @"提交人姓名";
    userNameModel.titileW = 82.f;
    userNameModel.placeholder = @"输入姓名";
    userNameModel.isRequire = NO;
    userNameModel.key = @"name";
    userNameModel.cellType = CreateSHopCellType_TF;
    userNameModel.maxInputLenth = 30;
    [self.tableViewDataOfForm addObject:userNameModel];
    
    
    CreateShopModel *userPhoneModel = [[CreateShopModel alloc] init];
    userPhoneModel.title = @"提交人手机号";
    userPhoneModel.titileW = 98.f;
    userPhoneModel.placeholder = @"输入手机号";
    userPhoneModel.isRequire = NO;
    userPhoneModel.key = @"mobilePhoneNumber";
    userPhoneModel.cellType = CreateSHopCellType_TF;
    userPhoneModel.maxInputLenth = 15;
    [self.tableViewDataOfForm addObject:userPhoneModel];
    
    CreateShopModel *credentialTypeModel = [[CreateShopModel alloc] init];
    credentialTypeModel.title = @"证件类型";
    credentialTypeModel.titileW = 70.f;
    credentialTypeModel.isRequire = NO;
    credentialTypeModel.placeholder = @"身份证";
    credentialTypeModel.key = @"certificateType";
    credentialTypeModel.cellType = CreateSHopCellType_TV_BACK;
    [self.tableViewDataOfForm addObject:credentialTypeModel];
    
    CreateShopModel *credentialNumModel = [[CreateShopModel alloc] init];
    credentialNumModel.title = @"证件号码";
    credentialNumModel.titileW = 70.f;
    credentialNumModel.placeholder = @"输入证件号码";
    credentialNumModel.isRequire = NO;
    credentialNumModel.key = @"certificateNumber";
    credentialNumModel.cellType = CreateSHopCellType_TF;
    credentialNumModel.maxInputLenth = 15;
    [self.tableViewDataOfForm addObject:credentialNumModel];
    
    CreateShopModel *organizeNumModel = [[CreateShopModel alloc] init];
    organizeNumModel.title = @"组织机构代码";
    organizeNumModel.titileW = 98.f;
    organizeNumModel.placeholder = @"输入组织机构代码";
    organizeNumModel.isRequire = NO;
    organizeNumModel.key = @"organizationNumber";
    organizeNumModel.cellType = CreateSHopCellType_TF;
    organizeNumModel.maxInputLenth = 15;
    [self.tableViewDataOfForm addObject:organizeNumModel];
    
    CreateShopModel *cardPicTipModel = [[CreateShopModel alloc] init];
    cardPicTipModel.cellType = CreateSHopCellType_TV_TWO;
    cardPicTipModel.title = @"手持身份证正面照片";
    cardPicTipModel.titileW = 150.f;
    cardPicTipModel.childTitleW = 150.f;
    cardPicTipModel.placeholder = @"保持照片自己清晰";
    [self.tableViewDataOfIdentityCard addObject:cardPicTipModel];
    
    CreateShopModel *cardPicSelectModel = [[CreateShopModel alloc] init];
    cardPicSelectModel.cellType = CreateSHopCellType_Card_PIC;
    cardPicSelectModel.key = @"certificateImage";
    [self.tableViewDataOfIdentityCard addObject:cardPicSelectModel];
    
    CreateShopModel *licenceCardPicTipModel = [[CreateShopModel alloc] init];
    licenceCardPicTipModel.cellType = CreateSHopCellType_TV_TWO;
    licenceCardPicTipModel.title = @"手持营业执照照片";
    licenceCardPicTipModel.titileW = 150.f;
    licenceCardPicTipModel.childTitleW = 150.f;
    licenceCardPicTipModel.placeholder = @"保持照片自己清晰";
    [self.tableViewDataOfLicenceCard addObject:licenceCardPicTipModel];
    
    CreateShopModel *licenceCardPicSelectModel = [[CreateShopModel alloc] init];
    licenceCardPicSelectModel.cellType = CreateSHopCellType_Card_PIC;
    licenceCardPicSelectModel.key = @"businessLicenseImage";
    [self.tableViewDataOfLicenceCard addObject:licenceCardPicSelectModel];
    
    [self.tableViewData addObject:self.tableViewDataOfForm];
    [self.tableViewData addObject:self.tableViewDataOfLicenceCard];
    [self.tableViewData addObject:self.tableViewDataOfIdentityCard];

    if (self.tableV) {
        [self.tableV reloadData];
    }
}

#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGRectGetHeight(self.shopHeaderBGV.frame);
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

#pragma mark 返回分组数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableViewData count];
}

#pragma mark 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewData[section] count];
}

#pragma mark 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreateShopModel *createModel = _tableViewData[indexPath.section][indexPath.row];
    if(createModel.cellType == CreateSHopCellType_TF){
        return [CreateShopTFCell cellHeight:createModel];
    }
    if(createModel.cellType == CreateSHopCellType_TV || createModel.cellType == CreateSHopCellType_TV_BACK){
        return [CreateShopTVCell cellHeight:createModel];
    }
    if(createModel.cellType == CreateSHopCellType_TV_TWO){
        return [CreateShopTVTWOCell cellHeight:createModel];
    }
    if (createModel.cellType == CreateSHopCellType_PIC) {
        return [CreateShopPicCell cellHeight:createModel];
    }
    if (createModel.cellType == CreateSHopCellType_Address) {
        return [CreateShopAddressCell cellHeight:createModel];
    }
    if (createModel.cellType == CreateSHopCellType_Card_PIC) {
        return [CreateShopCardPicCell cellHeight:createModel];
    }
    return 50.f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreateShopModel *createModel = createModel = self.tableViewData[indexPath.section][indexPath.row];
    if (createModel.cellType == CreateSHopCellType_TF) {
        static NSString *tfCellId = @"tfCellId";
        CreateShopTFCell *cell = [tableView dequeueReusableCellWithIdentifier:tfCellId];
        if (cell == nil)
        {
            cell = [[CreateShopTFCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tfCellId];
        }
        [cell refreshContent:createModel formModel:self.createShopFormModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (createModel.cellType == CreateSHopCellType_TV || createModel.cellType == CreateSHopCellType_TV_BACK) {
        static NSString *tvCellId = @"tvCellId";
        CreateShopTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tvCellId];
        if (cell == nil)
        {
            cell = [[CreateShopTVCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tvCellId];
        }
        [cell refreshContent:createModel formModel:self.createShopFormModel control:self.navigationController];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (createModel.cellType == CreateSHopCellType_Address) {
        static NSString *addressCellId = @"addressCellId";
        CreateShopAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellId];
        if (cell == nil)
        {
            cell = [[CreateShopAddressCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addressCellId];
        }
        [cell refreshContent:createModel formModel:self.createShopFormModel control:self.navigationController];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (createModel.cellType == CreateSHopCellType_TV_TWO) {
        static NSString *tvtwoCellId = @"tvtwoCellId";
        CreateShopTVTWOCell *cell = [tableView dequeueReusableCellWithIdentifier:tvtwoCellId];
        if (cell == nil)
        {
            cell = [[CreateShopTVTWOCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tvtwoCellId];
        }
        [cell refreshContent:createModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (createModel.cellType == CreateSHopCellType_PIC) {
        static NSString *picCellId = @"picCellId";
        CreateShopPicCell *cell = [tableView dequeueReusableCellWithIdentifier:picCellId];
        if (cell == nil)
        {
            cell = [[CreateShopPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:picCellId];
        }
        [cell refreshContent:createModel formModel:self.createShopFormModel control:self.navigationController];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (createModel.cellType == CreateSHopCellType_Card_PIC) {
        static NSString *cardPicCellId = @"cardPicCellId";
        CreateShopCardPicCell *cell = [tableView dequeueReusableCellWithIdentifier:cardPicCellId];
        if (cell == nil)
        {
            cell = [[CreateShopCardPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardPicCellId];
        }
        [cell refreshContent:createModel formModel:self.createShopFormModel control:self.navigationController];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        return self.shopHeaderBGV;
    }
    return headerView;
}

#pragma mark 上传照片
- (void)uploadPhotots
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.activityIndicatorColor = [UIColor whiteColor];
    NSMutableArray<UIImage*> *shopAboutImages = [NSMutableArray array];
    if (self.createShopFormModel.certificateImage) {
        [shopAboutImages addObject:self.createShopFormModel.certificateImage];
    } else {
        hud.label.text = @"请上传营业执照";
        return;
    }
    if (self.createShopFormModel.businessLicenseImage) {
        [shopAboutImages addObject:self.createShopFormModel.businessLicenseImage];
    } else {
        hud.label.text = @"请上传身份证";
        return;
    }
    if(shopAboutImages.count > 0){
        hud.label.text = @"正在上传图片";
        [QiniuUploadService uploadImages:shopAboutImages progress:^(CGFloat progress){
            DLog(@"已成功上传了 progress %f",progress);
        }success:^(NSArray<OTWDocument *> *documents){
            hud.label.text = @"正在提交商家信息";
            if (documents.count > 0) {
                self.createShopFormModel.certificatePhoto = [documents objectAtIndex:0];
                self.createShopFormModel.businessLicensePhoto = [documents objectAtIndex:1];
            }
            [self submitFormData:hud];
        }failure:^(){
            [self errorTips:@"发布失败，请检查您的网络是否连接" userInteractionEnabled:YES];
        }];
    }else{
        
    }
}


#pragma mark 提交表单数据
- (void)submitFormData:(MBProgressHUD *)hud
{
    OTWBusinessExpand *businessExpand = [[OTWBusinessExpand alloc] init];
    self.createShopFormModel.businessExpand = businessExpand;
    [self validateFormData];
    NSDictionary *requestBody = [NSDictionary dictionaryWithObjectsAndKeys:self.createShopFormModel.mj_keyValues,@"business",self.createShopFormModel.certificatePhoto.mj_keyValues,@"certificatePhoto",self.createShopFormModel.businessLicensePhoto.mj_keyValues,@"businessLicensePhoto",nil];
        DLog(@"form表单数据为:%@",requestBody.mj_keyValues);
    [OTWBusinessService createBusiness:requestBody completion:^(id result, NSError *error) {
        if (result) {
            [hud hideAnimated:YES];
            if ([[NSString stringWithFormat:@"%@",result[@"code"]] isEqualToString:@"0"]) {
                [self errorTips:@"添加成功" userInteractionEnabled:YES];
                self.createShopFormModel = [[CreateShopFormModel alloc] init];
                OTWSearchShopListViewController *findSearchVC = [[OTWSearchShopListViewController alloc] init];
                [self.navigationController pushViewController:findSearchVC animated:NO];
            } else {
                [self errorTips:@"添加失败，请检查您的网络是否连接" userInteractionEnabled:YES];
            }
        } else {
            [self netWorkErrorTips:error];
        }
        
    }];
}

#pragma mark 验证输入框数据合法性
- (void)validateFormData
{
    if (![self bInputIsEmpty:self.createShopFormModel.name]) {
        self.createShopFormModel.businessExpand.name = self.createShopFormModel.name;
    }
    if (![self bInputIsEmpty:self.createShopFormModel.mobilePhoneNumber]) {
        self.createShopFormModel.businessExpand.mobilePhoneNumber = self.createShopFormModel.mobilePhoneNumber;
    }
    if (![self bInputIsEmpty:self.createShopFormModel.certificateType]) {
        self.createShopFormModel.businessExpand.certificateType = self.createShopFormModel.certificateType;
    }
    if (![self bInputIsEmpty:self.createShopFormModel.certificateNumber]) {
        self.createShopFormModel.businessExpand.certificateNumber = self.createShopFormModel.certificateNumber;
    }
    if (![self bInputIsEmpty:self.createShopFormModel.organizationNumber]) {
        self.createShopFormModel.businessExpand.organizationNumber = self.createShopFormModel.organizationNumber;
    }
    self.createShopFormModel.name = self.createShopFormModel.shopName;
    //默认为身份证
    self.createShopFormModel.businessExpand.certificateType = @"idCard";
    //默认商家类型
    NSMutableArray *typeIds = [NSMutableArray array];
    [typeIds addObject:@"1"];
    [typeIds addObject:@"2"];
    self.createShopFormModel.typeIds = typeIds;
    self.createShopFormModel.businessLicenseImage = nil;
    self.createShopFormModel.certificateImage = nil;
    
}

#pragma mark 判断字符串是否为空
- (BOOL)bInputIsEmpty:(NSString*)str
{
    if (!str) {
        return YES;
    }
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length == 0) {
        return YES;
    }
    return NO;
}

- (NSMutableArray*)tableViewData
{
    if (!_tableViewData) {
        _tableViewData = [[NSMutableArray alloc] init];
    }
    
    return _tableViewData;
}

- (NSMutableArray<CreateShopModel*>*)tableViewDataOfForm
{
    if (!_tableViewDataOfForm) {
        _tableViewDataOfForm = [[NSMutableArray alloc] init];
    }
    return _tableViewDataOfForm;
}

- (NSMutableArray<CreateShopModel*>*)tableViewDataOfLicenceCard
{
    if (!_tableViewDataOfLicenceCard) {
        _tableViewDataOfLicenceCard = [[NSMutableArray alloc] init];
    }
    return _tableViewDataOfLicenceCard;
}

- (NSMutableArray<CreateShopModel*>*)tableViewDataOfIdentityCard
{
    if (!_tableViewDataOfIdentityCard) {
        _tableViewDataOfIdentityCard = [[NSMutableArray alloc] init];
    }
    return _tableViewDataOfIdentityCard;
}

- (CreateShopFormModel*)createShopFormModel
{
    if (!_createShopFormModel) {
        _createShopFormModel = [[CreateShopFormModel alloc] init];
    }
    return _createShopFormModel;
}

- (UIView*)shopHeaderBGV
{
    if (!_shopHeaderBGV) {
        _shopHeaderBGV = [[UIView alloc] init];
        _shopHeaderBGV.backgroundColor = [UIColor clearColor];
    }
    return _shopHeaderBGV;
}

- (UIView*)shopHeaderV
{
    if (!_shopHeaderV) {
        _shopHeaderV = [[UIView alloc] init];
        _shopHeaderV.backgroundColor = [UIColor whiteColor];
    }
    return _shopHeaderV;
}

- (UILabel*)shopNameV
{
    if (!_shopNameV) {
        _shopNameV = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 160, 20)];
        [_shopNameV setFont:[UIFont boldSystemFontOfSize:16]];
        _shopNameV.textAlignment = NSTextAlignmentLeft;
        _shopNameV.textColor = [UIColor color_202020];
        _shopNameV.text = @"胡大饭馆(东直门总店)";
    }
    return _shopNameV;
}

- (UIImageView*)shopLocationV
{
    if (!_shopLocationV) {
        CGFloat Y = CGRectGetMaxY(self.shopNameV.frame) + 13.5;
        _shopLocationV = [[UIImageView alloc] initWithFrame:CGRectMake(15, Y, 13, 13)];
        [_shopLocationV setImage:[UIImage imageNamed:@"dingwei"]];
    }
    return _shopLocationV;
}

- (UILabel*)shopLocatioinContentV
{
    if (!_shopLocatioinContentV) {
        _shopLocatioinContentV = [[UILabel alloc] init];
        [_shopLocatioinContentV setFont:[UIFont systemFontOfSize:14]];
        _shopLocatioinContentV.textColor = [UIColor color_7d7d7d];
        _shopLocatioinContentV.numberOfLines = 0;
    }
    return _shopLocatioinContentV;
}

- (UIImageView*)shopTelephoneV
{
    if (!_shopTelephoneV) {
        CGFloat Y = CGRectGetMaxY(self.shopLocatioinContentV.frame) + 8.5;
        _shopTelephoneV = [[UIImageView alloc] initWithFrame:CGRectMake(15, Y, 13, 13)];
        [_shopTelephoneV setImage:[UIImage imageNamed:@"ar_dianhua"]];
    }
    return _shopTelephoneV;
}

- (UILabel*)shopTelephoneContentV
{
    if (!_shopTelephoneContentV) {
        CGFloat X = CGRectGetMaxX(self.shopLocationV.frame) + 5;
        CGFloat Y = CGRectGetMaxY(self.shopLocatioinContentV.frame) + 5;
        _shopTelephoneContentV = [[UILabel alloc] initWithFrame:CGRectMake(X, Y, 120, 20)];
        [_shopTelephoneContentV setFont:[UIFont systemFontOfSize:14]];
        _shopTelephoneContentV.textAlignment = NSTextAlignmentLeft;
        _shopTelephoneContentV.textColor = [UIColor color_7d7d7d];
    }
    return _shopTelephoneContentV;
}

- (UITableView*)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationHeight) style:UITableViewStyleGrouped];
        _tableV.dataSource = self;
        _tableV.delegate = self;
        _tableV.backgroundColor = [UIColor clearColor];
        _tableV.tableFooterView = self.footView;
    }
    return _tableV;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 131)];
        _footView.backgroundColor = [UIColor color_f4f4f4];
        [_footView addSubview:self.submitButton];
    }
    return _footView;
}

- (UIButton*)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.backgroundColor = [UIColor color_e50834];
        _submitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        CGRect submitButtonRect = CGRectMake(30, 50, self.view.bounds.size.width - 30*2, 44);
        _submitButton.frame = submitButtonRect;
        [_submitButton addTarget:self action:@selector(uploadPhotots) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.layer.cornerRadius = 6;
        _submitButton.layer.masksToBounds = YES;
        
    }
    return _submitButton;
}

- (void)setCreateShopFormData:(CreateShopFormModel *)createShopFormData
{
    self.createShopFormModel = createShopFormData;
    DLog(@"下一页form数据:%@",self.createShopFormModel.mj_keyValues);
}

@end
