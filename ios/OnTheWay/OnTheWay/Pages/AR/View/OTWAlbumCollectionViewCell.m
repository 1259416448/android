//
//  OTWAlbumCollectionViewCell.m
//  OnTheWay
//
//  Created by 孔俊彦 on 2017/10/13.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "OTWAlbumCollectionViewCell.h"

@implementation OTWAlbumCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor color_f4f4f4];
        _photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 40) / 2, (SCREEN_WIDTH - 40) / 2 * 52 / 67)];
        [self.contentView addSubview:_photo];
    }
    return self;
}
@end
