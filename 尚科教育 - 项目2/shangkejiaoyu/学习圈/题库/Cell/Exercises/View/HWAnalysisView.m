//
//  HWAnalysisView.m
//  HWExercises
//
//  Created by sxmaps_w on 2017/6/1.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import "HWAnalysisView.h"
#import "HWExercises_prefix.pch"
@interface HWAnalysisView ()



@end

@implementation HWAnalysisView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //解析按钮
        UIButton *anaBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 9, 60,26 )];
//        [anaBtn setImage:[UIImage imageNamed:@"exerc_analysisView_anaBtn"] forState:UIControlStateNormal];
//        anaBtn.backgroundColor = [UIColor whiteColor];
        [anaBtn setTitle:@"解析" forState:UIControlStateNormal];
          [anaBtn setTitleColor:kCustomOrangeColor forState:UIControlStateNormal];
        [anaBtn addTarget:self action:@selector(anaBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
      
        anaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        anaBtn.layer.borderWidth = 1;
        anaBtn.layer.cornerRadius = 2;
        anaBtn.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:155.0/255.0 blue:0/255.0 alpha:1].CGColor;        self.anaBtn = anaBtn;
//        [self addSubview:_anaBtn];
        
        //正误标识图
        UIImageView *tfView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
        _tfView.backgroundColor = [UIColor greenColor];
        tfView.contentMode = UIViewContentModeCenter;
        [self addSubview:tfView];
        self.tfView = tfView;
        
        //答案解析视图
        UIView *anaView = [[UIView alloc] init];
        anaView.hidden = YES;
//        anaView.frame = CGRectMake(0, 44, KMainW, 100);
        [self addSubview:anaView];
        self.anaView = anaView;
        
        //线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, KMainW - 20, 0.5)];
        line.backgroundColor = KLineColor;
        [anaView addSubview:line];
        self.line = line;
        
        //解析标签
        UILabel *anaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth -20, 15)];
        anaLabel.text = @"试题讲解";
        anaLabel.font = [UIFont systemFontOfSize:15.f];
        anaLabel.textAlignment = NSTextAlignmentCenter;
        [anaView addSubview:anaLabel];
        
        //正确答案
        UILabel *trueAnswerLabel = [[UILabel alloc] init];
        trueAnswerLabel.textColor = kCustomOrangeColor;
        trueAnswerLabel.font = [UIFont systemFontOfSize:14.f];
        trueAnswerLabel.numberOfLines = 0;
        [anaView addSubview:trueAnswerLabel];
        self.trueAnswerLabel = trueAnswerLabel;
        
        //解析信息
        UILabel *anaInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, KMainW - 25, 50)];
        anaInfoLabel.textColor = [UIColor blackColor];
//        _anaInfoLabel.backgroundColor = [UIColor redColor];
        anaInfoLabel.font = [UIFont systemFontOfSize:14.f];
        anaInfoLabel.numberOfLines = 0;
        [anaView addSubview:anaInfoLabel];
        self.anaInfoLabel = anaInfoLabel;
    }
    
    return self;
}

- (void)anaBtnOnClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(didClickAnaBtnInAnalysisView:)]) {
        [_delegate didClickAnaBtnInAnalysisView:self];
    }
}

- (void)setTrueAnswer:(NSString *)trueAnswer
{
    _question_answer = trueAnswer;
}

- (void)setAnalysisInfo:(NSString *)analysisInfo
{
    _question_describe = analysisInfo;
}


//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[HWToolBox findViewController:self].view endEditing:YES];
}

- (void)dismissAnalysisInfo
{
    _tfView.hidden = YES;
    _anaView.hidden = YES;
    
    CGRect frame = self.frame;
    frame.size.height = 44;
    self.frame = frame;
}

@end
