//
//  PoolsTool.h
//  ParentsChunYa
//
//  Created by JIAN WEI ZHANG on 16/6/28.
//  Copyright © 2016年 JIAN WEI ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoolsTool : NSObject
+(NSString *)getCurrentTime;
+(NSInteger)getCurrtDateAndWeek;
+(NSString *)compareDate:(NSDate *)date;
+(NSString *)duibiShiJianWithDataString:(NSString *)dataString;
+ (NSString *)getNowTimestamp:(NSString *)getTime;

+ (NSString*)timestamp:(NSString*)time;

+ (NSString *)timeInterval:(NSString *)getTime dateFormatter:(NSString *)formatter;

@end
