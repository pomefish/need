//
//  rateView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/8/9.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "rateView.h"

@implementation rateView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews{
    

    
    for (int i = 0;i < 4 ;i++) {
      UIButton * playRateBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
         playRateBtn.frame = CGRectMake(0, (0 + 25)*i, 52, 25);
        if (0 == i) {
            [playRateBtn setTitle:@"1.0X" forState:UIControlStateNormal];
            playRateBtn.tag = 1000 ;
        }else if (1 == i){
             [playRateBtn setTitle:@"1.25X" forState:UIControlStateNormal];
             playRateBtn.tag = 1001 ;
        }else if (2 == i){
             [playRateBtn setTitle:@"1.5X" forState:UIControlStateNormal];
             playRateBtn.tag = 1002 ;
        }else{
             [playRateBtn setTitle:@"2.0X" forState:UIControlStateNormal];
             playRateBtn.tag = 1003 ;
        }
      
        playRateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [playRateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [playRateBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [playRateBtn addTarget:self action:@selector(rateChangeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playRateBtn];
    }
}

- (void)rateChangeAction:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playButtonDelegateWithTag:)]) {
        
        [self.delegate playButtonDelegateWithTag:button.tag];
        
        self.hidden = YES;
    }
    
    
}


@end
