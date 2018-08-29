//
//  RewardRecordModel.m
//  mingtao
//
//  Created by Linlin Ge on 2017/6/9.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "RewardRecordModel.h"

@implementation RewardRecordModel

- (instancetype)initWithRewardRecordModelDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
