//
//  InformationCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/20.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "InformationCell.h"

@implementation InformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImage.hidden = YES;
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = 20;
    self.nameTF.hidden = YES;
    self.sexLabel.hidden = YES;
    self.introductionTV.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
