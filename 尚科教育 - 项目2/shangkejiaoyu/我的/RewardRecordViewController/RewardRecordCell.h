//
//  RewardRecordCell.h
//  mingtao
//
//  Created by Linlin Ge on 2017/6/8.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardRecordModel.h"

@interface RewardRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

- (void)configureCellDataModel:(RewardRecordModel *)model;

@end
