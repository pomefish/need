//
//  StudyViewCustomCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "StudyViewCustomCell.h"
#import "TGHeader.h"
#import "UIImageView+WebCache.h"

@implementation StudyViewCustomCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initCustomCellModel:_model];
    }
    return self;
}
- (void)initCustomCellModel:(StudyModel *)model {
    _model = model;
    UIImageView *fistimage = [UIImageView new];
    fistimage.frame = CGRectMake(5, 5, kWidth - 10, kScreenHeight / 5);
    fistimage.image = [UIImage imageNamed:@"bj"];
    NSString *str = [NSString stringWithFormat:@"%@%@",skImageUrl,model.fist_img];
    [fistimage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"skplac.jpg"]];
    [self addSubview:fistimage];
    
    [_titleLabel removeFromSuperview];
    _titleLabel = [UILabel new];
    _titleLabel.frame = CGRectMake(5, CGRectGetMaxY(fistimage.frame) + 8, kWidth - 10, 10);
    _titleLabel.text = [NSString stringWithFormat:@"%@",_model.title];
//    _titleLabel.text = @"营养学";
    _titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_titleLabel];
    
    [_label removeFromSuperview];
    _label = [UILabel new];
    _label.frame = CGRectMake(5, CGRectGetMaxY(_titleLabel.frame) + 8, kWidth - 10, 10);
    _label.text = [NSString stringWithFormat:@"%@人学习",_model.click_count];
//    _label.text = @"264人学习";
    _label.textColor = kCustomColor(211, 211, 211);
    _label.font = [UIFont systemFontOfSize:10];
    [self addSubview:_label];
    
}
@end
