//
//  InteractionCell.m
//  mingtao
//
//  Created by Linlin Ge on 2017/11/13.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "InteractionCell.h"

@implementation InteractionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImage.layer.cornerRadius = 2;
    self.headImage.clipsToBounds = YES;
}

- (void)configurePlayLiveCellDataModel:(PlayLiveModel *)model {
//    EPLog(@"----------%@------",model.content);
    self.contentLabel.text = model.content;
    
}

+ (CGFloat)cellForHeight:(PlayLiveModel *)model {
    
    CGSize  retSize = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    CGFloat contentHeight = retSize.height +10;
    return contentHeight + 50;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
