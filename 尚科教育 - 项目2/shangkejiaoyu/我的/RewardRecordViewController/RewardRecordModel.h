//
//  RewardRecordModel.h
//  mingtao
//
//  Created by Linlin Ge on 2017/6/9.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardRecordModel : NSObject
@property (nonatomic, copy) NSString *change_desc;
@property (nonatomic, copy) NSString *change_time;
@property (nonatomic, copy) NSString *change_type;
@property (nonatomic, copy) NSString *user_money;

@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *user_name;
- (instancetype)initWithRewardRecordModelDictionary:(NSDictionary *)dic;

@end
