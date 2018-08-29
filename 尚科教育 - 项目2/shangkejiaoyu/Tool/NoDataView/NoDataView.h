//
//  NoDataView.h
//  mingtao
//
//  Created by Linlin Ge on 2017/1/10.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataView : UIView
@property (nonatomic, strong) UIButton *tryBtn;
@property (nonatomic, strong) UILabel *tryLabel;
@property (nonatomic, strong) UIImageView *tryImage;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)noDataViewTryImage:(NSString *)tryImage tryLabel:(NSString *)tryLabel tryBtn:(NSString *)tryBtn;

@end
