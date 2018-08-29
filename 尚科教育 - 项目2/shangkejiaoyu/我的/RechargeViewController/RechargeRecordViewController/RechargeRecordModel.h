//
//  RechargeRecordModel.h
//  mingtao
//
//  Created by Linlin Ge on 2017/6/7.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeRecordModel : NSObject
@property (nonatomic, copy) NSString *change_desc;
@property (nonatomic, copy) NSString *change_time;
@property (nonatomic, copy) NSString *change_type;
@property (nonatomic, copy) NSString *frozen_money;
@property (nonatomic, copy) NSString *log_id;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *pay_points;
@property (nonatomic, copy) NSString *rank_points;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_money;


- (instancetype)initWithRechargeRecordModelDictionary:(NSDictionary *)dic;

@end
