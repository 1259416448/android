//
//  findSearchViewCell.m
//  OnTheWay
//
//  Created by UI002 on 2017/8/14.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "findSearchViewCell.h"

@interface findSearchViewCell(){
    UIImageView *searchIcon;
    UILabel *searchText;
    UILabel *searchNum;
}
@end

@implementation findSearchViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    searchIcon=[[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 15, 15)];
    searchIcon.image=[UIImage imageNamed:@"sousuo_1"];
     [self.contentView addSubview:searchIcon];
    
    searchNum=[[UILabel alloc]init];
    searchNum.text=@"约132个结果";
    searchNum.font=[UIFont systemFontOfSize:12];
    searchNum.textColor = [UIColor color_979797];
    [searchNum sizeToFit];
    searchNum.frame=CGRectMake(SCREEN_WIDTH-15-searchNum.Witdh, 12,searchNum.Witdh, 15);
    [self.contentView addSubview:searchNum];
    
    searchText=[[UILabel alloc]init];
    searchText.text=@"烤肉自助";
    searchText.font=[UIFont systemFontOfSize:14];
    searchText.textColor = [UIColor color_202020];
     searchText.frame=CGRectMake(searchIcon.MaxX+10, 10,SCREEN_WIDTH-searchIcon.MaxX-searchNum.Witdh-10-15, 20);
    [self.contentView addSubview:searchText];
}


@end
