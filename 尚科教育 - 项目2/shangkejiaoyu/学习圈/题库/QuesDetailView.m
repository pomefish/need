//
//  QuesDetailView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/4/1.
//  Copyright © 2018年 ShangKe. All rights reserved.
//
#define fontsize [UIFont systemFontOfSize:15]
#import "QuesDetailView.h"
#import "TGHeader.h"
#import "UILabel+Size.h"

@implementation QuesDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return  self;
}


- (void)setUpViews{
    self.queaTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 6, 50, 20)];
    _queaTypeLabel.font = [UIFont systemFontOfSize:13];
    _queaTypeLabel.textColor =  kCustomOrangeColor;
    _queaTypeLabel.textAlignment = NSTextAlignmentCenter;
    _queaTypeLabel.layer.borderWidth = 1;

    _queaTypeLabel.layer.cornerRadius =2;
    _queaTypeLabel.layer.borderColor =[UIColor colorWithRed:255.0/255.0 green:155.0/255.0 blue:0/255.0 alpha:1].CGColor;
    _queaTypeLabel.layer.masksToBounds = YES;
    _queaTypeLabel.text = @"单选题";
    [self addSubview: _queaTypeLabel];
    
    
//    CGRectMake(CGRectGetMaxX(_queaTypeLabel.frame) + 5, 10, kScreenWidth - _queaTypeLabel.frame.size.width - 25, 0)];
    

    self.queaTitleLabel = [[UILabel alloc] init];
    _queaTitleLabel.backgroundColor = [UIColor greenColor];
    _queaTitleLabel.text = @"附i回复i然女解放";
    _queaTitleLabel.font = fontsize;;
    _queaTitleLabel.numberOfLines = 0;
    CGSize titleSize = [_queaTitleLabel boundingRectWithSize:CGSizeMake(kScreenWidth - _queaTypeLabel.frame.size.width - 25, MAXFLOAT)];

   _queaTitleLabel.frame = CGRectMake(CGRectGetMaxX(_queaTypeLabel.frame) + 5, 10, kScreenWidth - _queaTypeLabel.frame.size.width - 25, titleSize.height);
    
    [self addSubview:_queaTitleLabel];
    
    
    CGFloat padding = 10;
    self.queaSelABtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _queaSelABtn.frame = CGRectMake(20, CGRectGetMaxY(_queaTitleLabel.frame) + 30, kScreenWidth - 40, 30);
//    [_queaSelABtn sizeToFit];
    _queaSelABtn.titleLabel.font = fontsize;
    _queaSelABtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _queaSelABtn.backgroundColor = [UIColor greenColor];
    [self addSubview:_queaSelABtn];
    
    self.queaSelBBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _queaSelBBtn.frame = CGRectMake(20, CGRectGetMaxY(_queaSelABtn.frame) + padding, kScreenWidth - 40, 30);
//    [_queaSelBBtn sizeToFit];
    _queaSelBBtn.titleLabel.font = fontsize;
    _queaSelBBtn.backgroundColor = [UIColor yellowColor];
    _queaSelBBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [self addSubview:_queaSelBBtn];
    
    
    self.queaSelCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _queaSelCBtn.frame = CGRectMake(20, CGRectGetMaxY(_queaSelBBtn.frame) + padding, kScreenWidth - 40, 30);
//    [_queaSelCBtn sizeToFit];
    _queaSelCBtn.titleLabel.font = fontsize;
    _queaSelCBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _queaSelCBtn.backgroundColor = [UIColor greenColor];
    [self addSubview:_queaSelCBtn];
    
    
    
    self.queaSelDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _queaSelDBtn.frame = CGRectMake(20, CGRectGetMaxY(_queaSelCBtn.frame) + padding, kScreenWidth - 40, 30);
//    [_queaSelDBtn sizeToFit];
    _queaSelDBtn.titleLabel.font = fontsize;
    _queaSelDBtn.backgroundColor = [UIColor yellowColor];
    [_queaSelDBtn setTitle:@"直通车控制" forState:UIControlStateNormal];
    [_queaSelDBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _queaSelDBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_queaSelDBtn];
    
}
@end
