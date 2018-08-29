//
//  myExamCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/4/8.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWAnswerView.h"
#import "HWAnalysisView.h"
@interface myExamCell : UITableViewCell
@property (nonatomic,strong)UILabel *queaTypeLabel;
@property (nonatomic,strong)UILabel *queaTitleLabel;
@property (nonatomic,strong)UIButton *queaSelABtn;
@property (nonatomic,strong)UIButton *queaSelBBtn;
@property (nonatomic,strong)UIButton *queaSelCBtn;
@property (nonatomic,strong)UIButton *queaSelDBtn;
@property (nonatomic,strong)HWAnswerView *answerView;

@property (nonatomic,strong)HWAnalysisView *analyView;


//- (void)setModel:(moreModel *)model;
@end
