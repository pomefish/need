//
//  CommentsModel.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/1/13.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "CommentsModel.h"

@implementation CommentsModel
- (instancetype)initWithCommentsModelDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([@"id" isEqualToString:key]) {
        self.modelID = value;
    }
}
@end
