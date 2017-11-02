//
//  OTWAlbumSelectHelper.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/12.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWAlbumSelectHelper.h"

@interface OTWAlbumSelectHelper ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) AlbumBlock block;

@property (nonatomic, strong) UIAlertController *actionSheet;

@end

@implementation OTWAlbumSelectHelper

+ (instancetype)shared
{
    static OTWAlbumSelectHelper *albumHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        albumHelper = [[OTWAlbumSelectHelper alloc] init];
    });
    
    return albumHelper;
}

- (void)showInViewController:(UIViewController *)vc imageBlock:(AlbumBlock)block
{
    if (nil == vc) return;
    
    self.vc = vc;
    self.block = block;
    
    [self.vc presentViewController:self.actionSheet animated:YES completion:nil];
}

#pragma mark - 

- (UIAlertController*)actionSheet
{
    if (!_actionSheet) {
        
        _actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = type;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.allowsEditing = YES;
            [self.vc presentViewController:imagePicker animated:YES completion:nil];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = type;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.allowsEditing = YES;
            [self.vc presentViewController:imagePicker animated:YES completion:nil];
            
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [_actionSheet addAction:action1];
        [_actionSheet addAction:action2];
        [_actionSheet addAction:cancleAction];
    }
    
    return _actionSheet;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion: ^{
        
        UIImage *orImage = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData *imageData = UIImageJPEGRepresentation(orImage, 0.4); //压缩图片
        UIImage *image = [UIImage imageWithData:imageData];
        
        self.block(image);
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

@end
