//
//  RechargeRecordModel.m
//  mingtao
//
//  Created by Linlin Ge on 2017/6/7.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "RechargeRecordModel.h"

@implementation RechargeRecordModel

- (instancetype)initWithRechargeRecordModelDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
