//
//  InformTableViewCell.m
//  mingtao
//
//  Created by Linlin Ge on 2017/8/14.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "InformTableViewCell.h"

@implementation InformTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.SignUpBtn.clipsToBounds = YES;
//    self.SignUpBtn.layer.cornerRadius = 2;
    
    self.informLabel.clipsToBounds = YES;
    self.informLabel.layer.cornerRadius = 12;

}
- (void)configureCellDataModel:(LiveModel *)model {
    self.titleLabel.text = model.title;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",skImageUrl,model.image]] placeholderImage:[UIImage imageNamed:@"loading"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
