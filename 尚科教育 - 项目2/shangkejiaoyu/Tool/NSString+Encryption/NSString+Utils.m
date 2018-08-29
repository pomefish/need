//
//  NSString+Utils.m
//  AIDemo
//
//  Created by Clyde on 2017/3/21.
//  Copyright © 2017年 Clyde. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

+ (BOOL)cc_isNULLOrEmpty:(NSString *)string {
    NSString *str =  [self stringWithFormat:@"%@", string];
    if ([@"" isEqualToString:str] || [@" " isEqualToString:str] || str == nil || [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"] || [str isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

@end
