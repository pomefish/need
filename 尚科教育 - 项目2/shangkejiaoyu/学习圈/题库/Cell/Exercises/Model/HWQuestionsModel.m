//
//  HWQuestionsModel.m
//  HWExercises
//
//  Created by sxmaps_w on 2017/6/1.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import "HWQuestionsModel.h"

@implementation HWQuestionsModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return  self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"question_select"]) {
        NSString *valueStr = value;
        self.question_selectArray = [self getSelectDataWithString:valueStr];
    }
}
///question_select字段截取成四个选项
- (NSArray *)getSelectDataWithString:(NSString *)str1{

  
    
    NSString *byStr = @"###";
       NSArray *array = [str1 componentsSeparatedByString:byStr]; //从字符A中分隔成3个元素的数组

    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:array];
    //    NSArray *dataArray = [NSArray array];
    
//    [dataArray addObject:strAsele];
//    [dataArray addObject:strBsele];
//    [dataArray addObject:strCsele];
//    [dataArray addObject:strDsele];
   
    return dataArray;
}
@end
