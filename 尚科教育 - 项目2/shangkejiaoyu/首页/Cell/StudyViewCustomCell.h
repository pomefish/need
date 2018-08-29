//
//  StudyViewCustomCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyModel.h"
@interface StudyViewCustomCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) StudyModel *model;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)initCustomCellModel:(StudyModel *)model;

@end
