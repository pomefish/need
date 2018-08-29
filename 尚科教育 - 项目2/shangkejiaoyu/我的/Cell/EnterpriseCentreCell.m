//
//  EnterpriseCentreCell.m
//  mingtao
//
//  Created by Linlin Ge on 2017/4/22.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "EnterpriseCentreCell.h"

@implementation EnterpriseCentreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statusLabel.hidden = YES;
    self.redLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, 10, 10)];
    _redLabel.backgroundColor = [UIColor redColor];
    _redLabel.layer.masksToBounds = YES;
    _redLabel.layer.cornerRadius = 5;
    [self addSubview:_redLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
