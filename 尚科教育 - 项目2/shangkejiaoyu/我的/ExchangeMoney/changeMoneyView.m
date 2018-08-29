//
//  changeMoneyView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/6/15.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "changeMoneyView.h"

@implementation changeMoneyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self setUYpViews];
    }
    return  self;
}

- (void)setUYpViews{
    CGFloat hh = 30;
    CGFloat space = 15;
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kWidth, hh)];
    self.topLabel.text = @"兑换赏金";
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.backgroundColor = [UIColor whiteColor];
    self.topLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_topLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topLabel.frame) +space, kWidth, hh)];
    self.titleLabel.text = @"兑换数额：";
    _titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
    
    self.jinBeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), 60, hh +8)];
    self.jinBeiLabel.text = @"学习币";
    _jinBeiLabel.backgroundColor = [UIColor whiteColor];
    self.jinBeiLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_jinBeiLabel];
    
    self.amountTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_jinBeiLabel.frame), CGRectGetMaxY(_titleLabel.frame), kWidth  - 60, hh +8)];
    _amountTF.backgroundColor = [UIColor whiteColor];
    _amountTF.placeholder = @" 输入兑换数额";
    _amountTF.keyboardType = UIKeyboardTypeNumberPad;

    [self addSubview:_amountTF];
    
    self.affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _affirmBtn.frame =CGRectMake(10, CGRectGetMaxY(_jinBeiLabel.frame) +30, kWidth-20, 40);
    [_affirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    _affirmBtn.backgroundColor = kCustomViewColor;
    [self addSubview:_affirmBtn];
    
}

@end
