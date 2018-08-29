//
//  MoreViewCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/3/28.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "moreModel.h"
@interface MoreViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *middleLabel;
@property (nonatomic,strong)UIImageView *playImageView;
@property (nonatomic,strong)UILabel *numLabel;
@property (nonatomic,strong)UILabel *learnLabel;
@property (nonatomic,strong)UIImageView *picImageView;
@property (nonatomic,assign)CGFloat titleHeight;
@property (nonatomic,assign)CGFloat middleHeight;
@property (nonatomic,strong)moreModel *model;
- (void)setModel:(moreModel *)model;

@end
