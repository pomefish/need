//
//  totalCollectionViewCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/4/4.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "totalCollectionViewCell.h"

@implementation totalCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _titleLabel.layer.borderColor = (__bridge CGColorRef _Nullable)[UIColor lightGrayColor];
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.cornerRadius = 40 /2;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        
        [self.contentView  addSubview:_titleLabel];
    }
    return self;
}

@end
