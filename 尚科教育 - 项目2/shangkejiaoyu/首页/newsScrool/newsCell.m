//
//  newsCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/3/27.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "newsCell.h"

@implementation newsCell 

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return  self;
}



- (void)setUpViews{
   
    
    self.newsLabela = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 30)];
    _newsLabela.backgroundColor = [UIColor redColor];
    [self addSubview:_newsLabela];
    
    self.newsImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_newsLabela.frame), kScreenWidth -20, 120)];
    NSLog(@"开始加载图");
    _newsImage.backgroundColor = [UIColor greenColor];
    [self addSubview:_newsImage];
    
    
    
    
    self.newsLabelb = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.newsLabela.frame) + 10, _newsLabela.frame.size.width, 35)];
    _newsLabelb.backgroundColor = [UIColor redColor];
       NSLog(@"开始加label");
    [self addSubview:_newsLabelb];
}
@end
