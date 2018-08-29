//
//  moreModel.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/3/28.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "moreModel.h"

@implementation moreModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return  self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end
