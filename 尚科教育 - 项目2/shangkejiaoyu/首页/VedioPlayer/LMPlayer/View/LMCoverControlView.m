//
//  LMCoverView.m
//  拉面视频Demo
//
//  Created by 李小南 on 16/9/26.
//  Copyright © 2016年 lamiantv. All rights reserved.
//  未播放状态下的封面

#import "LMCoverControlView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface LMCoverControlView ()
/** 背景图片 */
@property (nonatomic, strong) UIImageView *backgroundImageView;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 分享按钮 */
@property (nonatomic, strong) UIButton *shareBtn; 
/** 播放Icon */
@property (nonatomic, strong) UIImageView *playerImageView;
@end

@implementation LMCoverControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.backBtn];
        [self addSubview:self.titleLabel];
        [self addSubview:self.shareBtn];
        [self addSubview:self.playerImageView];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        self.backgroundColor = [UIColor blackColor];
        [self makeSubViewsAction];
    }
    return self;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundImageViewTapAction)];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self.backgroundImageView addGestureRecognizer:tapGes];
}

#pragma mark - Action
- (void)backBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(coverControlViewBackButtonClick)]) {
        [self.delegate coverControlViewBackButtonClick];
    }
}

- (void)shareBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(coverControlViewShareButtonClick)]) {
        [self.delegate coverControlViewShareButtonClick];
    }
}

- (void)backgroundImageViewTapAction {
    if ([self.delegate respondsToSelector:@selector(coverControlViewBackgroundImageViewTapAction)]) {
        [self.delegate coverControlViewBackgroundImageViewTapAction];
    }
}

#pragma mark - Public method
/** 更新封面图片 */
- (void)syncCoverImageViewWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    // 设置网络占位图片
    if (urlString.length) {
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"banner_default"]];;
    } else {
        self.backgroundImageView.image = placeholderImage;
    }
}

- (void)syncCoverImageViewWithTitleString:(NSString *)titleString {
    self.titleLabel.text = titleString;
}

#pragma mark - 添加子控件约束
- (void)makeSubViewsConstraints {

    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(52);
        make.height.offset(42);
        make.top.equalTo(self.mas_top).offset(2);
        make.left.equalTo(self.mas_left).offset(5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenWidth - 120);
        make.height.offset(20);
        make.top.equalTo(self.mas_top).offset(12);
        make.left.equalTo(self.mas_left).offset(55);
    }];

    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(52);
        make.height.offset(42);
        make.top.equalTo(self.mas_top).offset(2);
        make.trailing.equalTo(self.mas_trailing).offset(-5);
    }];
    
    [self.playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(75);
    }];
    
}


#pragma mark - getter
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"btn_播放页_返回"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        
//        _titleLabel.text = @"从零开始的异世界生活 -- 狗粮已送到";
    }
    return _titleLabel;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_shareBtn setImage:[UIImage imageNamed:@"btn_播放页_分享"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

- (UIImageView *)playerImageView {
    if (!_playerImageView) {
        _playerImageView = [[UIImageView alloc] init];
        _playerImageView.image = [UIImage imageNamed:@"btn_playplus"];
        _playerImageView.contentMode = UIViewContentModeCenter;
    }
    return _playerImageView;
}

@end
