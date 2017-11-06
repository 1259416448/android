//
//  OTWUserModel.m
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/11.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWUserModel.h"

@implementation OTWUserModel

static NSString *userIdKey = @"id";
static NSString *genderKey = @"gender";
static NSString *headImgYuanKey = @"headImgYuan";
static NSString *usernameKey = @"username";
static NSString *mobilePhoneNumberKey = @"mobilePhoneNumber";
static NSString *headImgKey = @"headImg";
static NSString *nameKey = @"name";
static NSString *userKey = @"otwCurrenUser";


static OTWUserModel *user = nil;
+(instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[OTWUserModel alloc] init];
    });
    return user;
}

-(void)dump
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:[OTWUserModel shared]];
    [userDefaults setObject:userData forKey:userKey];
    [userDefaults synchronize];
}

-(void)load{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefaults objectForKey:userKey];
    [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    [userDefaults synchronize];
}

-(void)logout{
    [OTWUserModel shared].userId = @"";
    [OTWUserModel shared].gender = @"";
    [OTWUserModel shared].headImgYuan = @"";
    [OTWUserModel shared].username = @"";
    [OTWUserModel shared].mobilePhoneNumber = @"";
    [OTWUserModel shared].headImg = @"";
    [OTWUserModel shared].name = @"";
    [[OTWUserModel shared] dump];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super self];
    if(self){
        [OTWUserModel shared].userId = [coder decodeObjectForKey:userIdKey];
        [OTWUserModel shared].gender = [coder decodeObjectForKey:genderKey];
        [OTWUserModel shared].headImgYuan = [coder decodeObjectForKey:headImgYuanKey];
        [OTWUserModel shared].username = [coder decodeObjectForKey:usernameKey];
        [OTWUserModel shared].mobilePhoneNumber = [coder decodeObjectForKey:mobilePhoneNumberKey];
        [OTWUserModel shared].headImg = [coder decodeObjectForKey:headImgKey];
        [OTWUserModel shared].name = [coder decodeObjectForKey:nameKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[OTWUserModel shared].userId forKey:userIdKey];
    [coder encodeObject:[OTWUserModel shared].gender forKey:genderKey];
    [coder encodeObject:[OTWUserModel shared].headImgYuan forKey:headImgYuanKey];
    [coder encodeObject:[OTWUserModel shared].username forKey:usernameKey];
    [coder encodeObject:[OTWUserModel shared].mobilePhoneNumber forKey:mobilePhoneNumberKey];
    [coder encodeObject:[OTWUserModel shared].headImg forKey:headImgKey];
    [coder encodeObject:[OTWUserModel shared].name forKey:nameKey];
}

@end

