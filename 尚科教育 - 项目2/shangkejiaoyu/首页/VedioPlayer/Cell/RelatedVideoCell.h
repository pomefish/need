//
//  RelatedVideoCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/14.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyModel.h"

@interface RelatedVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;

- (void)configureCellDataModel:(StudyModel *)model;

@end
