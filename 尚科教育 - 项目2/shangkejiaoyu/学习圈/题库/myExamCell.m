//
//  myExamCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/4/8.
//  Copyright © 2018年 ShangKe. All rights reserved.
//
#define fontsize [UIFont systemFontOfSize:13]

#import "myExamCell.h"
#import "TGHeader.h"
#import "UILabel+Size.h"
#import "HWAnalysisView.h"

@implementation myExamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];

    }
    return  self;
}



- (void)setUpViews{
    

    
    //问题标签
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 26)];
    typeLabel.font = [UIFont systemFontOfSize:15.f];
    typeLabel.textColor =  kCustomOrangeColor;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.layer.borderWidth = 1;
    
    typeLabel.layer.cornerRadius =2;
    typeLabel.layer.borderColor =[UIColor colorWithRed:255.0/255.0 green:155.0/255.0 blue:0/255.0 alpha:1].CGColor;
    typeLabel.numberOfLines = 0;
    [self addSubview:typeLabel];
    
    self.queaTypeLabel = typeLabel;
    
    
    UILabel *questionLabel = [[UILabel alloc] init];
    questionLabel.font = [UIFont systemFontOfSize:15.f];
    questionLabel.numberOfLines = 0;
    
    [self addSubview:questionLabel];
    self.queaTitleLabel = questionLabel;
    
    //答案选择视图，单选、多选、判断
    HWAnswerView *answerView = [[HWAnswerView alloc] init];
    
    [self addSubview:answerView];
    self.answerView = answerView;
    
    //解析视图
    HWAnalysisView *analysisView = [[HWAnalysisView alloc] init];
    _analyView.line.hidden = YES;
    [self addSubview:analysisView];
    self.analyView = analysisView;
    

}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
