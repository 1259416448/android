//
//  NSString+RegexCategory.h
//  OnTheWay
//
//  Created by 周扬扬 on 2017/7/8.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegexCategory)

- (BOOL)isValidateByRegex:(NSString *)regex;

- (BOOL)isMobileNumberClassification;

- (BOOL)isMobileNumber;

- (BOOL)isEmailAddress;

- (BOOL) simpleVerifyIdentityCardNum;

- (BOOL)isCarNumber;

- (BOOL)isMacAddress;

- (BOOL)isValidUrl;

- (BOOL)isValidChinese;

- (BOOL)isValidPostalcode;

- (BOOL)isValidTaxNo;

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value ;

- (BOOL)bankCardluhmCheck;

- (BOOL)isIPAddress;


@end
