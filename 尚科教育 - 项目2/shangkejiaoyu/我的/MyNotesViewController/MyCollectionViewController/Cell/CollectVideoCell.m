//
//  CollectVideoCell.m
//  mingtao
//
//  Created by Linlin Ge on 2017/3/22.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "CollectVideoCell.h"

@implementation CollectVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellDataModel:(StudyModel *)model {
    if (![model.title isKindOfClass:[NSNull class]]) {
    self.titleLabel.text = model.title;
    }
    
    if (![model.fist_img isKindOfClass:[NSNull class]]) {
    NSString *str = [NSString stringWithFormat:@"%@%@",skImageUrl,model.fist_img];
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:loadingImage];
    }
}
@end
