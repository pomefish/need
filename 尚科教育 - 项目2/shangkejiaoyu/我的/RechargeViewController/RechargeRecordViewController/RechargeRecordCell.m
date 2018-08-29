//
//  RechargeRecordCell.m
//  mingtao
//
//  Created by Linlin Ge on 2017/6/7.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "RechargeRecordCell.h"

@implementation RechargeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellDataModel:(RechargeRecordModel *)model {
    NSLog(@"%@",model.pay_points);
    self.titleLabel.text = model.change_desc;
    self.moneyLabel.text = model.user_money;
    self.timeLabel.text = [self getTimeString:model.change_time];
    if ([model.change_type isEqualToString:@"0"]) {
        self.typeLabel.text = @"充值";
    }else if ([model.change_type isEqualToString:@"1"]) {
        self.typeLabel.text = @"提现";
    }else if ([model.change_type isEqualToString:@"2"]) {
        self.typeLabel.text = @"管理员调节";
    }else if ([model.change_type isEqualToString:@"99"]) {
        self.typeLabel.text = @"消费";
    }
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
