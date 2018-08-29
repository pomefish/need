//
//  CurriculumCollectionCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "CurriculumCollectionCell.h"

@implementation CurriculumCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self addSubview:self.titleImage];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UIView *)titleImage{
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kWidth - 20, kHeight - 50)];
        _titleImage.image = [UIImage imageNamed:@"bj"];
    }
    return _titleImage;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _titleImage.frame.origin.y +  _titleImage.frame.size.height + 15, kWidth - 20, 20)];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.text = @"注册国际营养师";
    }
    return _titleLabel;
}

@end
