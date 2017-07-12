//
//  OTWAlbumSelectHelper.h
//  OnTheWay
//
//  Created by machunyan on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AlbumBlock)(UIImage *image);

/**
 * 相册选择
 * note 需要在info.plist 中添加 NSCameraUsageDescription & NSPhotoLibraryUsageDescription 属性
 */
@interface OTWAlbumSelectHelper : NSObject

+ (instancetype)shared;

/**
 * 显示到视图控制器
 * @param vc 当前需要展示的视图
 * @param block 选中的image回调
 */
- (void)showInViewController:(UIViewController*)vc imageBlock:(AlbumBlock)block;

@end
