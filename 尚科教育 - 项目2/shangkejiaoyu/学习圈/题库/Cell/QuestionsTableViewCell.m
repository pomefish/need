//
//  QuestionsTableViewCell.m
//  mingtao
//
//  Created by Linlin Ge on 2017/7/8.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "QuestionsTableViewCell.h"

@implementation QuestionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)customCellModel:(MessageModel *)model {
    self.titleLabel.text = model.c_name;
    if ([model.type isEqualToString:@"0"]) {
        self.numberLabel.text = @"未测试";
    }else{
        self.numberLabel.text = @"已测试";
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
