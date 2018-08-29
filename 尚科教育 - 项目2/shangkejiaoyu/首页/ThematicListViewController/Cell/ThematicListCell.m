//
//  ThematicListCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/1/13.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "ThematicListCell.h"
#import "ContentViewController.h"

@implementation ThematicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _backButton.layer.cornerRadius =  5;
    _backButton.layer.masksToBounds = YES;
    
    _titleImage.layer.cornerRadius =  5;
    _titleImage.layer.masksToBounds = YES;
}

- (void)customThematicListCellModel:(MessageModel* )model {
//    self.timeLabel.text = [PoolsTool duibiShiJianWithDataString:model.time];
    self.timeLabel.text = [PoolsTool timeInterval:model.add_time dateFormatter:@"yyyy-MM-dd"];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",skImageUrl,model.image];
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
    if (![NSString cc_isNULLOrEmpty:model.title]) {
        self.titleLabel.text = model.title;
        self.titleLabel.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:0.6];
    }else {
        self.titleLabel.hidden = YES;
    }
    self.nameLabel.text = model.title;
    self.contentLabel.text = model.descriptionStr;
}

- (IBAction)backButtonClick:(UIButton *)sender {
    NSLog(@"-------------%ld",_index);
    
    MessageModel*model = _dataArr[_index];
    ContentViewController *contentVC = [ContentViewController new];
    contentVC.contentModel = model;

    [[self getCurrentViewController].navigationController pushViewController:contentVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
