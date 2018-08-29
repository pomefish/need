//
//  newsCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/3/27.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newsCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *newsImage;
@property(nonatomic,strong) UILabel *newsLabela;
@property (nonatomic,strong) UILabel *newsLabelb;


@property (strong, nonatomic) NSArray *images;

@property (weak, nonatomic)  UIScrollView *scrollView;

@property (weak, nonatomic, readonly) UIPageControl *pageControl;


@property (assign, nonatomic, getter=isScrollDirectionPortrait) BOOL scrollDirectionPortrait;

@end
