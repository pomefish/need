//
//  StudyCustomView.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "StudyCustomView.h"
#import "TGHeader.h"

#define kWidth   self.frame.size.width
#define kHeight  self.frame.size.height

@implementation StudyCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self congfigureSubViews];
    }
    return self;
}

- (void)congfigureSubViews {
    CGFloat   imgaeX =  (kWidth / 2) - ((kWidth/2.2)/2);
    CGFloat   imgaeY =  (kHeight / 2) - (kWidth/2.2 / 1.25);
    
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(imgaeX, imgaeY, kWidth/2.2, kWidth/2.2)];
    [self addSubview:_image];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_image.frame) + 5, kWidth, 20)];
    _titleLabel.textColor = kCustomNavColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_titleLabel];
    
    _clickButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _clickButton.frame = CGRectMake(0, 0, kWidth, kHeight);
    [self addSubview:_clickButton];
    
}

@end
