//
//  IntroduceCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/19.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "IntroduceCell.h"
#import "UIImageView+WebCache.h"
@implementation IntroduceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)customCellModel:(StudyModel *)model {
    self.titleLabel.text = model.title;
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",skImageUrl,model.fist_img]] placeholderImage:[UIImage imageNamed:@"tu1"]];
    if (model.click_count) {
        self.numberLabel.text = [NSString stringWithFormat:@"%@人学习",model.click_count];

    }else{
        self.numberLabel.text = @"0人学习";
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.duration];
    //简介
//    self.describeLabel.text = model.description;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
