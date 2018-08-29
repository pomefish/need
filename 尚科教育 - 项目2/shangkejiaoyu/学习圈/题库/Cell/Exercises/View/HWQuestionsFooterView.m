//
//  HWQuestionsFooterView.m
//  HWExercises
//
//  Created by sxmaps_w on 2017/6/1.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import "HWQuestionsFooterView.h"
#import "HWExercises_prefix.pch"

// gai de
@interface HWAnalysisView ()
//
//@property (nonatomic, weak) UIImageView *tfView;
//@property (nonatomic, weak) UIView *anaView;
//@property (nonatomic, weak) UILabel *trueAnswerLabel;
//@property (nonatomic, weak) UILabel *anaInfoLabel;

@end

@implementation HWQuestionsFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        
        CGFloat verH = 0;
        self.totalQueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 + verH, 59, 40)];
        _totalQueLabel.text = @"0/0";
        _totalQueLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_totalQueLabel];
        
        self.rightImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightImageView.frame = CGRectMake(CGRectGetMaxX(_totalQueLabel.frame)+ 5, 10 + verH, 20, 20);

        [_rightImageView setBackgroundImage:[UIImage imageNamed:@"smile"] forState:UIControlStateNormal];
        [self addSubview:_rightImageView];
        
        self.rightILabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightImageView.frame)+2, 0+ verH, 45, 40)];
        _rightILabel.text  = @"0";
        _rightILabel.font = [UIFont systemFontOfSize:14];;
        _rightILabel.textColor = kCustomGreenColor;
        [self addSubview:_rightILabel];
        
        
        self.errorImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        
            _errorImageView.frame = CGRectMake(CGRectGetMaxX(_rightILabel.frame)+ 5, 10 + verH, 20, 20);
                               
        [_errorImageView setBackgroundImage:[UIImage imageNamed:@"cry"] forState:UIControlStateNormal];
        [self addSubview:_errorImageView];
        
        self.errorILabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_errorImageView.frame)+2, 0 +verH, 45, 40)];
        _errorILabel.text  = @"0";
        _errorILabel.font = [UIFont systemFontOfSize:14];;
        _errorILabel.textColor = kCustomOrangeColor;
        [self addSubview:_errorILabel];
        
//        self.quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _quedingBtn.frame = CGRectMake(CGRectGetMaxX(_errorILabel.frame)+5, 0, kScreenWidth - CGRectGetMaxX(_errorILabel.frame)-5 , 40);
//        _quedingBtn.backgroundColor = kCustomOrangeColor;
//        [_quedingBtn setTitle:@"确认" forState:UIControlStateNormal];
//        
//        [self addSubview:_quedingBtn];


        self.btn =[UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(CGRectGetMaxX(_errorILabel.frame)+25, 0+ verH, kScreenWidth - CGRectGetMaxX(_errorILabel.frame)-25 , 40);

            _btn.tag = 501;
        _btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter ;//设置文字位置，现设为居左，默认的是居中   

        _btn.backgroundColor = kCustomOrangeColor;
        _btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_btn setTitle:@"确定" forState:UIControlStateNormal];
        
            [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(changeQuestionBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_btn];
    
        //上一题、下一题
//        NSArray *titleArray = @[@"上一题", @"下一题"];
//        for (int i = 0; i < titleArray.count; i++) {
//            CGFloat ww = (kScreenWidth - CGRectGetMaxX(_errorILabel.frame)-10)/2;
//            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_errorILabel.frame)+ 10 +(ww+10)*i , 0, ww, 40)];
//            btn.tag = i + 500;
//            btn.backgroundColor = kCustomOrangeColor;
//            btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
//            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
////            [btn setBackgroundImage:[UIImage imageWithColor:KWhiteColor] forState:UIControlStateNormal];
////            [btn setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateHighlighted];
//            [btn setTitleColor:kMainColor forState:UIControlStateNormal];
//            [btn setTitleColor:KWhiteColor forState:UIControlStateHighlighted];
//            [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateDisabled];
//            [btn addTarget:self action:@selector(changeQuestionBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:btn];
//        }
        
        //线
//        for (int i = 0; i < 2; i++) {
        UIView *line = [[UIView alloc] init];
            line.frame = CGRectMake(0, 0 + verH, self.bounds.size.width, 1);
             line.backgroundColor = KLineColor;
            [self addSubview:line];
//        }
    }

    return self;
}



- (void)changeQuestionBtnOnClick:(UIButton *)btn

{   NSLog(@"解析出现了 ");
    
//    [btn setTitle:@"下一题" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(handleNext:) forControlEvents:UIControlEventTouchUpInside];
   
    
    if (_delegate && [_delegate respondsToSelector:@selector(questionsFooterView:didClickOptionButton:)]) {
        [_delegate questionsFooterView:self didClickOptionButton:btn.tag == 501];
    }

}


//- (void)handleNext:(UIButton *)btn
//
//{
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(questionsFooterView:didClickOptionButton:)]) {
//        [_delegate questionsFooterView:self didClickOptionButton:btn.tag == 501];
//    }
//
//
//}
@end
