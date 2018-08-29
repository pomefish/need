//
//  StudyRecordCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/22.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyModel.h"

@interface StudyRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;

- (void)configureCellDataModel:(StudyModel *)model;

@end
