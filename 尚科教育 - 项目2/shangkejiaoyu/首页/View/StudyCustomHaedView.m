//
//  StudyCustomHaedView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "StudyCustomHaedView.h"
#import "TGHeader.h"
@implementation StudyCustomHaedView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _haedView = [UIView new];
    _haedView.frame = CGRectMake(0, 10, kScreenWidth, 40);
    _haedView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_haedView];
    
    _titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 160, 20)];
    _titleLabel.text = @"哈哈";
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.textColor = kCustomNavColor;
    [_haedView addSubview:_titleLabel];
    
    _titleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, 10, 100, 20)];
    _titleTextLabel.font = [UIFont systemFontOfSize:16];
    [_haedView addSubview:_titleTextLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(kWidth - 15 - 50, 17.5, 50, 20);
    _button.titleLabel.font = [UIFont systemFontOfSize:13];
    [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:_button];
    
    _arrowImage = [UIImageView new];
//    _arrowImage.image = [UIImage imageNamed:@"jiantou_01"];
    _arrowImage.frame = CGRectMake(kWidth - 20 - 8, 30, 8, 14);
    [self addSubview:_arrowImage];
    
}

@end
