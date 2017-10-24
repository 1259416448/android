//
//  OTWAddNewShopViewController.m
//  OnTheWay
//
//  Created by apple on 2017/8/21.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWAddNewShopViewController.h"
#import "OTWAddNewShopNextViewController.h"
#import "CreateShopTFCell.h"
#import "CreateShopTVCell.h"
#import "CreateShopTVTWOCell.h"
#import "CreateShopPicCell.h"
#import "CreateShopAddressCell.h"
#import "OTWSelectBarViewController.h"

#import <MJExtension.h>

@interface OTWAddNewShopViewController ()<UITableViewDelegate,UITableViewDataSource,CreateShopPicCellDelegate,CreateShopTVCellDelegate>

@property (nonatomic,strong) NSMutableArray *tableViewData;
@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) UIButton *submitButton;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UILabel *tipsLabel;

@property (nonatomic,strong) CreateShopFormModel *createShopFormModel;

@end

@implementation OTWAddNewShopViewController

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
    self.title = @"添加新商家";
    [self setLeftNavigationImage:[UIImage imageNamed:@"back_2"]];
    self.view.backgroundColor = [UIColor color_f4f4f4];
    [self.view addSubview:self.tableV];
//    [self.view addSubview:self.submitButton];
    [self initDataSource];
}

- (void)initDataSource
{
    CreateShopModel *nameModel = [[CreateShopModel alloc] init];
    nameModel.title = @"商家名称";
    nameModel.titileW = 70.f;
    nameModel.placeholder = @"请输入商家名称";
    nameModel.isRequire = YES;
    nameModel.key = @"shopName";
    nameModel.cellType = CreateSHopCellType_TF;
    nameModel.maxInputLenth = 30;
    [self.tableViewData addObject:nameModel];
    
    CreateShopModel *addressModel = [[CreateShopModel alloc] init];
    addressModel.title = @"商家地址";
    addressModel.titileW = 70.f;
    addressModel.placeholder = @"请选择商家地址";
    addressModel.isRequire = YES;
    addressModel.key = @"address";
    addressModel.cellType = CreateSHopCellType_Address;
    [self.tableViewData addObject:addressModel];
    
    CreateShopModel *phoneModel = [[CreateShopModel alloc] init];
    phoneModel.title = @"商家电话";
    phoneModel.titileW = 70.f;
    phoneModel.placeholder = @"请输入商家电话";
    phoneModel.isRequire = NO;
    phoneModel.key = @"contactInfo";
    phoneModel.cellType = CreateSHopCellType_TF;
    phoneModel.maxInputLenth = 15;
    [self.tableViewData addObject:phoneModel];
    
    CreateShopModel *shopTpyeModel = [[CreateShopModel alloc] init];
    shopTpyeModel.title = @"商家类型";
    shopTpyeModel.titileW = 70.f;
    shopTpyeModel.isRequire = NO;
    shopTpyeModel.placeholder = @"请选择商家类型";
    shopTpyeModel.key = @"typeIds";
    shopTpyeModel.cellType = CreateSHopCellType_TV_BACK;
    [self.tableViewData addObject:shopTpyeModel];
    
    CreateShopModel *picTipModel = [[CreateShopModel alloc] init];
    picTipModel.cellType = CreateSHopCellType_TV_TWO;
    picTipModel.title = @"上传商家照片";
    picTipModel.titileW = 100.f;
    picTipModel.childTitleW = 100.f;
    picTipModel.placeholder = @"最多上传9张照片";
    [self.tableViewData addObject:picTipModel];
    
    CreateShopModel *picSelectModel = [[CreateShopModel alloc] init];
    picSelectModel.cellType = CreateSHopCellType_PIC;
    picSelectModel.cellHigh = (SCREEN_WIDTH - 60) / 4 + 30;
    [self.tableViewData addObject:picSelectModel];

    if (self.tableV) {
        [self.tableV reloadData];
    }
}

#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark 返回分组数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewData.count;
}

#pragma mark 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreateShopModel *createModel = _tableViewData[indexPath.row];
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
        return createModel.cellHigh;
    }
    if (createModel.cellType == CreateSHopCellType_Address) {
        return [CreateShopAddressCell cellHeight:createModel];
    }
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreateShopModel *createModel = self.tableViewData[indexPath.row];
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
        cell.delegate = self;
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
        cell.delegate = self;
        return cell;
    }
    return nil;
}
#pragma mark CreateShopTVCellDelegate
- (void)didChangeType:(NSString *)typeStr
{
    CreateShopModel *createModel = self.tableViewData[3];
    createModel.placeholder = typeStr;
    [_tableV reloadData];
}

- (void)submitFormData
{
    DLog(@"form表单数据为:%@",self.createShopFormModel.mj_keyValues);
    OTWAddNewShopNextViewController *addNewShopNextVC = [[OTWAddNewShopNextViewController alloc] init];
    [addNewShopNextVC setCreateShopFormData:self.createShopFormModel];
    [self.navigationController pushViewController:addNewShopNextVC animated:NO];
    
    
}

- (void)toChildView
{
    OTWSelectBarViewController *addNewShopNextVC = [[OTWSelectBarViewController alloc] init];
    [self.navigationController pushViewController:addNewShopNextVC animated:NO];
}

- (void)didChangeCellHigh:(CGFloat)cellHigh
{
    [self.tableV reloadData];
}

#pragma mark 设置cell数据


- (NSMutableArray<CreateShopModel*>*)tableViewData
{
    if (!_tableViewData) {
        _tableViewData = [[NSMutableArray alloc] init];
    }
    return _tableViewData;
}

- (CreateShopFormModel*)createShopFormModel
{
    if (!_createShopFormModel) {
        _createShopFormModel = [[CreateShopFormModel alloc] init];
    }
    return _createShopFormModel;
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

- (UIButton*)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [_submitButton setTitle:@"下一步" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.backgroundColor = [UIColor color_e50834];
        _submitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        CGRect submitButtonRect = CGRectMake(30, 75, SCREEN_WIDTH - 30*2, 44);
        _submitButton.frame = submitButtonRect;
        [_submitButton addTarget:self action:@selector(submitFormData) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.layer.cornerRadius = 6;
        _submitButton.layer.masksToBounds = YES;
        
    }
    return _submitButton;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        _footView.backgroundColor = [UIColor color_f4f4f4];
        [_footView addSubview:self.tipsLabel];
        [_footView addSubview:self.submitButton];
    }
    return _footView;
}
- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 11)];
        _tipsLabel.textColor = [UIColor color_e50834];
        _tipsLabel.font = [UIFont systemFontOfSize:11];
        _tipsLabel.text = @"* 为必填信息";
    }
    return _tipsLabel;
}

@end
