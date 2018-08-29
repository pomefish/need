//
//  LinkageMenuView.m
//  LinkageMenu
//
//  Created by 风间 on 2017/3/8.
//  Copyright © 2017年 EmotionV. All rights reserved.
//  github: https://github.com/EmotionV/LinkageMenu

#import "LinkageMenuView.h"

#define MENU_WIDTH 100  //左侧菜单栏宽度，默认100
#define BOTTOMVIEW_HEIGHT 25  //滑块高度
#define BOTTOMVIEW_WIDTH (MENU_WIDTH - 10)  //滑块宽度
#define LINEVIEW_WIDTH 1.0  //分割线宽度
#define ANIMATION_TIME 0.2  //菜单栏滚动的时间

#define FULLVIEW_FOR6 667  //iPhone6(s)高度

@interface LinkageMenuView()

@property (nonatomic, strong) UIScrollView *menuView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *rightview;

@end

@implementation LinkageMenuView{
    NSArray *menuArray;
    NSArray *viewArray;
    NSInteger titlesCount; //菜单总数
    NSInteger newChoseTag;  //选择的button tag
    NSInteger choseTag;  //上次选择的button tag
    CGFloat btnHeight;  //button高度，适配不同屏幕
    NSInteger DTScrollTag; //滚动tag
    CGFloat blankHeight;
    CGFloat half_blankHeight;
}

#pragma mark - Init Method
- (instancetype)initWithFrame:(CGRect)frame WithMenu:(NSArray *)menu andViews:(NSArray *)views{
    if (self = [super init]) {
        if (kScreenHeight < FULLVIEW_FOR6) {
            btnHeight = 73;
            DTScrollTag = 5;
        }else if (kScreenHeight == FULLVIEW_FOR6){
            btnHeight = 74;
            DTScrollTag = 6;
        }else if (kScreenHeight > FULLVIEW_FOR6){
            btnHeight = 72.7;
            DTScrollTag = 7;
        }
        //Default Menu Style
        _textSize = 14.0;
        _textColor = [UIColor blackColor];
        _selectTextColor = [UIColor whiteColor];
        _selectViewColor = [UIColor blackColor];
        
        if (views.count < menu.count) {
            NSLog(@"Please Add More Views");
        }
        for (int i = 0; i < views.count; i++) {
            UIView *view = [views objectAtIndex:i];
            view.frame = self.rightview.bounds;
        }
        if (views.count <= 0) {
            
        }else {
            [self.rightview addSubview:(UIView *)[views objectAtIndex:0]];
        }
        
        menuArray = menu;
        viewArray = views;
        titlesCount = menuArray.count;
        blankHeight = btnHeight - BOTTOMVIEW_HEIGHT;
        half_blankHeight = (btnHeight - BOTTOMVIEW_HEIGHT) / 2.0;
        choseTag = 1; //默认选中菜单栏第一个
        self.frame = frame;
        [self addSubview:self.menuView];
        [self addSubview:self.lineView];
        [self addSubview:self.rightview];
        self.backgroundColor = kCustomColor(246, 246, 246);
        
    }
    return self;
}

#pragma mark - Setter Method
- (void)setSelectViewColor:(UIColor *)selectViewColor{
    _selectTextColor = selectViewColor;
    _bottomView.backgroundColor = _selectViewColor;
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    for (int i = 2; i <= menuArray.count; i++) {
        UIButton *button = [self viewWithTag:i];
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
}
- (void)setSelectTextColor:(UIColor *)selectTextColor{
    _selectTextColor = selectTextColor;
    UIButton *button = [self viewWithTag:1];
    [button setTitleColor:kCustomViewColor forState:UIControlStateNormal];
}
- (void)setTextSize:(CGFloat)textSize{
    _textSize = textSize;
    for (int i = 1; i <= menuArray.count; i++) {
        UIButton *button = [self viewWithTag:i];
        button.titleLabel.font = [UIFont systemFontOfSize:textSize];
    }
}

#pragma mark - LazyLoad
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(MENU_WIDTH, 0, LINEVIEW_WIDTH, self.frame.size.height)];
        _lineView.backgroundColor = kCustomColor(246, 246, 246);
    }
    return _lineView;
}

- (UIView *)rightview{
    if (!_rightview) {
        _rightview = [[UIView alloc] initWithFrame:CGRectMake(MENU_WIDTH + LINEVIEW_WIDTH, 0, kScreenWidth - MENU_WIDTH + LINEVIEW_WIDTH, kScreenHeight)];
    }
    return _rightview;
}

- (UIScrollView *)menuView{
    if (!_menuView) {
        _menuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MENU_WIDTH, self.frame.size.height)];
        _menuView.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        _menuView.scrollsToTop = NO;
        _menuView.showsVerticalScrollIndicator = NO;
        
        _menuView.contentSize = CGSizeMake(0, titlesCount * btnHeight + blankHeight + 5.0);
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, half_blankHeight + 1.0, MENU_WIDTH, btnHeight)];
//        _bottomView.layer.cornerRadius = BOTTOMVIEW_HEIGHT / 2.0;
        _bottomView.backgroundColor = kCustomColor(248, 248, 248);
        [_menuView addSubview:_bottomView];
        
        
        UIView *shuView = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight, MENU_WIDTH, 2)];
        //        _bottomView.layer.cornerRadius = BOTTOMVIEW_HEIGHT / 2.0;
        shuView.backgroundColor = kCustomViewColor;
        [_bottomView addSubview:shuView];

        for (int i = 1; i <= menuArray.count; i++) {
            UIButton *menuButton = [[UIButton alloc] init];
            menuButton.tag = i;
            menuButton.titleLabel.font = [UIFont systemFontOfSize:_textSize];
            menuButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [menuButton setTitle:[menuArray objectAtIndex:(i - 1)] forState:UIControlStateNormal];
            [menuButton setBackgroundColor:[UIColor clearColor]];
            menuButton.frame = CGRectMake(5, btnHeight * (i - 1) + half_blankHeight + 1.0, MENU_WIDTH - 10, btnHeight);
            menuButton.titleLabel.numberOfLines = 0;
            if (i == 1) {
                [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [menuButton addTarget:self action:@selector(choseMenu:) forControlEvents:UIControlEventTouchUpInside];
            [_menuView addSubview:menuButton];
        }
    }
    return _menuView;
}

#pragma mark - MenuButton Method
- (void)choseMenu:(UIButton *)button{
    NSLog(@"%ld==%@",(long)button.tag,button.titleLabel.text);
    newChoseTag = button.tag;
    
    if (newChoseTag != choseTag) {
        UIButton *lastButton = (UIButton *)[self viewWithTag:choseTag];
        [lastButton setTitleColor:_textColor forState:UIControlStateNormal];
        
        CGFloat scroHeight = _menuView.contentSize.height - kScreenHeight + kTabHeight;
        
        if (menuArray.count > DTScrollTag * 2.0) {
            if (button.tag <= DTScrollTag) {
                [UIView animateWithDuration:ANIMATION_TIME animations:^{
                    [_menuView setContentOffset:CGPointMake(0,- kNavHeight) animated:NO];
                }];
            }else if (button.tag > menuArray.count - DTScrollTag){
                [UIView animateWithDuration:ANIMATION_TIME animations:^{
                    [_menuView setContentOffset:CGPointMake(0, scroHeight) animated:NO];
                }];
            }else if(button.tag == DTScrollTag + 1){
                [UIView animateWithDuration:ANIMATION_TIME animations:^{
                    [_menuView setContentOffset:CGPointMake(0,- kNavHeight + blankHeight + 1.0) animated:NO];
                }];
            }else if (button.tag > DTScrollTag + 1 && button.tag < menuArray.count - DTScrollTag){
                [UIView animateWithDuration:ANIMATION_TIME animations:^{
                    [_menuView setContentOffset:CGPointMake(0,- kNavHeight + blankHeight + 1.0 + button.frame.size.height * (button.tag - DTScrollTag - 1)) animated:NO];
                }];
            }else if (button.tag == menuArray.count - DTScrollTag){
                [UIView animateWithDuration:ANIMATION_TIME animations:^{
                    [_menuView setContentOffset:CGPointMake(0, scroHeight - blankHeight - 5.0) animated:NO];
                }];
            }
        }

        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _bottomView.frame = CGRectMake(0, button.frame.origin.y, MENU_WIDTH, btnHeight);
        } completion:nil];
        [self performSelector:@selector(delayChangeTextColor) withObject:nil afterDelay:0.07];
        
        for (UIView *view in [_rightview subviews]) {
            [view removeFromSuperview];
        }
        NSInteger viewtag;
        if (button.tag >= viewArray.count) {
            viewtag = viewArray.count - 1;
        }else{
            viewtag = button.tag - 1;
        }
        UIView *rigView = [viewArray objectAtIndex:viewtag];
        [_rightview addSubview:rigView];
    }
}

#pragma mark - Delay Method
- (void)delayChangeTextColor{
        UIButton *button = (UIButton *)[self viewWithTag:newChoseTag];
        [button setTitleColor:kCustomViewColor forState:UIControlStateNormal];
        choseTag = newChoseTag;
}

@end
