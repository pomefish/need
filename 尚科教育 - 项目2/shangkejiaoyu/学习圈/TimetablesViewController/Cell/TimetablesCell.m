//
//  TimetablesCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/10.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "TimetablesCell.h"

@implementation TimetablesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)customCellModel:(MessageModel *)model {
    
    self.titleLabel.text = model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
