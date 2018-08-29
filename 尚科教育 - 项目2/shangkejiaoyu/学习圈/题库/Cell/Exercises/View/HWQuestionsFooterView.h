//
//  HWQuestionsFooterView.h
//  HWExercises
//
//  Created by sxmaps_w on 2017/6/1.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWAnalysisView.h"
@class HWQuestionsFooterView;

@protocol HWQuestionsFooterViewDelegate <NSObject>

- (void)questionsFooterView:(HWQuestionsFooterView *)questionsFooterView didClickOptionButton:(BOOL)isNextButton;
@end

//jeixi
//@protocol HWAnalysisViewDelegate <NSObject>
//
//- (void)didClickAnaBtnInAnalysisView:(HWAnalysisView *)analysisView;
//
//@end

@interface HWQuestionsFooterView : UIView

@property (nonatomic, weak) id<HWQuestionsFooterViewDelegate> delegate;

@property (nonatomic,strong)UILabel *totalQueLabel;
@property (nonatomic,strong)UILabel *rightILabel;
@property (nonatomic,strong)UIButton *rightImageView;

@property (nonatomic,strong)UILabel *errorILabel;
@property (nonatomic,strong)UIButton *errorImageView;
@property (nonatomic,strong)UIButton *btn;


//jiexi
@property (nonatomic,strong)HWAnalysisView *analyView;
//正确答案
@property (nonatomic, copy) NSString *trueAnswer;

//解析
@property (nonatomic, copy) NSString *analysisInfo;

//代理
@property (nonatomic, weak) id<HWAnalysisViewDelegate> andelegate;



@property (nonatomic,strong)UIButton *anaBtn;

//根据回答结果显示解析视图
- (void)reloadViewWithUserResult:(NSString *)userResult showTFView:(BOOL)show;

//隐藏解析视图解析视图
- (void)dismissAnalysisInfo;

@property (nonatomic, weak) UIImageView *tfView;
@property (nonatomic, weak) UIView *anaView;
@property (nonatomic, weak) UILabel *trueAnswerLabel;
@property (nonatomic, weak) UILabel *anaInfoLabel;

@end
