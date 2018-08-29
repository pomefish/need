//
//  NoDataView.m
//  mingtao
//
//  Created by Linlin Ge on 2017/1/10.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "NoDataView.h"
#import "TGHeader.h"

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tryImage];
        [self addSubview:self.tryLabel];
        [self addSubview:self.tryBtn];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIImageView *)tryImage {
    if (_tryImage == nil) {
        self.tryImage = [UIImageView new];
        self.tryImage.frame = CGRectMake((kScreenWidth - 100) / 2, kScreenHeight/4, 100, 100);
        self.tryImage.image = [UIImage imageNamed:@"no_data"]; 
    }
    return _tryImage;
}

- (UILabel *)tryLabel {
    if (_tryLabel == nil) {
        self.tryLabel = [UILabel new];
        self.tryLabel.text = @"网络好像出错了。";
        self.tryLabel.font = [UIFont systemFontOfSize:14];
        self.tryLabel.textColor = [UIColor lightGrayColor];
        self.tryLabel.frame = CGRectMake(0, CGRectGetMaxY(self.tryImage.frame) + 20, kScreenWidth, 20);
        self.tryLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tryLabel;
}

- (UIButton *)tryBtn {
    if (_tryBtn == nil) {
        self.tryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tryBtn setTitle:@"再试试" forState:UIControlStateNormal];
        [self.tryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.tryBtn.backgroundColor = kCustomViewColor;
        self.tryBtn.layer.cornerRadius =  3;

//        self.tryBtn.layer.borderWidth = 1;
//        self.tryBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.tryBtn.frame = CGRectMake((kScreenWidth - 140) / 2, CGRectGetMaxY(self.tryLabel.frame) + 80, 140, 35);
    }
    return _tryBtn;
}

- (void)noDataViewTryImage:(NSString *)tryImage tryLabel:(NSString *)tryLabel tryBtn:(NSString *)tryBtn {
    self.tryImage.image = [UIImage imageNamed:tryImage];
    
    self.tryLabel.text = tryLabel;
    
    [self.tryBtn setTitle:tryBtn forState:UIControlStateNormal];

}

@end
