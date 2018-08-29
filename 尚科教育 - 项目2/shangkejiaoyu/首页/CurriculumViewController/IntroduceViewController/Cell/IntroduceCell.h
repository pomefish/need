//
//  IntroduceCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/19.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyModel.h"

@interface IntroduceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

- (void)customCellModel:(StudyModel *)model;

@end
