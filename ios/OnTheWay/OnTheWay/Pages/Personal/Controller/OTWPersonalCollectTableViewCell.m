//
//  OTWPersonalCollectTableViewCell.m
//  OnTheWay
//
//  Created by apple on 2017/7/26.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWPersonalCollectTableViewCell.h"

@interface OTWPersonalCollectTableViewCell (){
    UILabel *shopName;
    UIView *shopQuanView;
    UIImageView *shopAddressView;
    UILabel *shopAddress;

}
@end

@implementation OTWPersonalCollectTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    
}

@end
