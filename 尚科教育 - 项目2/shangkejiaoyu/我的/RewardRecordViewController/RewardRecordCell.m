//
//  RewardRecordCell.m
//  mingtao
//
//  Created by Linlin Ge on 2017/6/8.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "RewardRecordCell.h"

@implementation RewardRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellDataModel:(RewardRecordModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"您成功邀请了%@",model.user_name];
    self.timeLabel.text = [self getTimeString:model.add_time];
    self.moneyLabel.text = [NSString stringWithFormat:@"+%@",model.user_money];
}

- (NSString *)getTimeString:(NSString *)timeStringe {
    NSTimeInterval time=[timeStringe doubleValue];
    NSDate *compareDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"YYYY-MM-dd  HH:mm:ss";
    NSString *timeStr = [formater stringFromDate:compareDate];
    
    return timeStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
