//
//  TeachingImageCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/8/28.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "TeachingImageCell.h"

@implementation TeachingImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)customCellModel:(MessageModel *)model {
    self.titleLabel.text = model.title;
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",skImageUrl,model.image]] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.detailsLabel.text = model.descriptionStr;
    
    NSMutableAttributedString *numberStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"浏览%@次",model.click_count]];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range=[[numberStr string]rangeOfString:[NSString stringWithFormat:@"%@",model.click_count]];
    [numberStr addAttribute:NSForegroundColorAttributeName value:kCustomViewColor range:range];
     self.browseLabel.attributedText = numberStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
