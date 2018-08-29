//
//  SelModel.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/4/8.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "SelModel.h"

@implementation SelModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return  self;
}

@end
