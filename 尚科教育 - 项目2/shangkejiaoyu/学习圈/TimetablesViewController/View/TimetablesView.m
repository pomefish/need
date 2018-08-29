//
//  TimetablesView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/30.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "TimetablesView.h"

@implementation TimetablesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}

- (void)initCustomView {
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(10, 10, kWidth - 20, kHeight - 20);
    [self.btn setImage:loadingImage forState:UIControlStateNormal];
    [self addSubview:self.btn];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.btn.frame) - 40, kWidth - 20, 40);
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    [self.btn addSubview:self.titleLabel];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
