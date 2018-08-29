//
//  HWAnalysisView.h
//  HWExercises
//
//  Created by sxmaps_w on 2017/6/1.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWAnalysisView;

@protocol HWAnalysisViewDelegate <NSObject>

- (void)didClickAnaBtnInAnalysisView:(HWAnalysisView *)analysisView;

@end

@interface HWAnalysisView : UIView


@property (nonatomic, weak) UILabel *trueAnswerLabel;
@property (nonatomic, weak) UILabel *anaInfoLabel;
@property (nonatomic, weak) UIView *anaView;
@property (nonatomic, weak) UIImageView *tfView;
@property (nonatomic,weak)UIView *line;


//正确答案
@property (nonatomic, copy) NSString *question_answer;

//解析
@property (nonatomic, copy) NSString *question_describe;

//代理
@property (nonatomic, weak) id<HWAnalysisViewDelegate> delegate;



@property (nonatomic,strong)UIButton *anaBtn;

//根据回答结果显示解析视图
- (void)reloadViewWithUserResult:(NSString *)userResult showTFView:(BOOL)show;

//隐藏解析视图解析视图
- (void)dismissAnalysisInfo;

@end
