//
//  RechargeRecordCell.h
//  mingtao
//
//  Created by Linlin Ge on 2017/6/7.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeRecordModel.h"
@interface RechargeRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

- (void)configureCellDataModel:(RechargeRecordModel *)model;

@end
