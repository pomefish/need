//
//  BottomView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/4/1.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "BottomView.h"
#import "QuesDetailViewController.h"
@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setviews];
    }
    return  self;
}


- (void)setviews{
    self.totalQueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    _totalQueLabel.text = @"1/3";
    [self addSubview:_totalQueLabel];
    
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_totalQueLabel.frame)+ 5, 5, 30, 30)];
    _rightImageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_rightImageView];
    
    self.rightILabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+2, 0, 40, 40)];
    _rightILabel.text  = @"13";
    _rightILabel.textColor = kCustomGreenColor;
    [self addSubview:_rightILabel];
    
    
    self.errorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightILabel.frame)+ 5, 5, 30, 30)];
    _errorImageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_errorImageView];
    
    self.errorILabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_errorImageView.frame)+2, 0, 40, 40)];
    _errorILabel.text  = @"10";
    _errorILabel.textColor = kCustomOrangeColor;
    [self addSubview:_errorILabel];
    
    self.quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _quedingBtn.frame = CGRectMake(CGRectGetMaxX(_errorILabel.frame)+5, 0, kScreenWidth - CGRectGetMaxX(_errorILabel.frame)-5 , 40);
    _quedingBtn.backgroundColor = kCustomOrangeColor;
    [_quedingBtn setTitle:@"确认" forState:UIControlStateNormal];
 
    [self addSubview:_quedingBtn];
}


////  获取view所在的视图
//- (UIViewController *)viewController {
//    for (UIView* next = [self superview]; next; next = next.superview) {
//        UIResponder *nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)nextResponder;
//        }
//    }
//    return nil;
//}
//- (void)handleNextTouch:(UIButton *)btn{
//    QuesDetailViewController *VC = [[QuesDetailViewController alloc] init];
////     [[self viewController].navigationController pushViewController:VC animated:YES];
//    [btn setTitle:@"下一题" forState:UIControlStateNormal];
//    
//    
//}
@end
