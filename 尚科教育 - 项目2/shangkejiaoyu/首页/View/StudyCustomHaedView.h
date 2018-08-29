//
//  StudyCustomHaedView.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyCustomHaedView : UICollectionReusableView
@property (nonatomic, strong) UIView  *haedView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleTextLabel;

- (instancetype)initWithFrame:(CGRect)frame;
@end
