//
//  TeachingModel.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/8/28.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "TeachingModel.h"

@implementation TeachingModel
- (instancetype)initWithTeachingModelDictionary:(NSDictionary *)dic {
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
    if ([@"description" isEqualToString:key]) {
        self.descriptionStr = value;
        
    }
}

@end
