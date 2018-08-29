//
//  PoolsTool.m
//  ParentsChunYa
//
//  Created by JIAN WEI ZHANG on 16/6/28.
//  Copyright © 2016年 JIAN WEI ZHANG. All rights reserved.
//

#import "PoolsTool.h"

@implementation PoolsTool
#pragma mark -----当前时间
+(NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dataTime = [formatter stringFromDate:[NSDate date]];
    return dataTime;
}

+(NSInteger)getCurrtDateAndWeek
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIndian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday ;
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    //int week = [comps weekday];
    NSInteger currentweekIndex = [comps weekday];
    return currentweekIndex;
}
+(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    NSLog(@"有没有？？？%@",dateString);
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}

+(NSString *)duibiShiJianWithDataString:(NSString *)dataString
{
    //把字符串转换为nsdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *str = [self getNowTimestamp:dataString];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    timeInterval = timeInterval -8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if ((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if ((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if ((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if ((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    return result;
}

+ (NSString*)timestamp:(NSString*)time {
    
    NSInteger timestamp = [time integerValue];
    NSDate * date = [NSDate date];
    NSString * currentTimes = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSInteger currentTimestamp = [currentTimes integerValue];
    NSInteger offtime = currentTimestamp - timestamp;
    
    if(offtime >= 2592000){
        //一个月前
        return @"1个月前";
    }else if(offtime >=86400){
        //一天前
        return @"1天前";
    }else if(offtime >=3600){
        //一小时前
        NSInteger ti = offtime/3600;
        return [NSString stringWithFormat:@"%ld小时前",ti];
    }else if(offtime >= 60){
        //分钟
        NSInteger ti = offtime/60;
        return [NSString stringWithFormat:@"%ld分钟前",ti];
    }else{
        return @"1分钟内";
    }
    
    return @"";
    
}

+ (NSString *)getNowTimestamp:(NSString *)getTime{
    
    
    
    NSTimeInterval time=[getTime doubleValue];
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    
    return currentDateStr;
    
}

+ (NSString *)timeInterval:(NSString *)getTime dateFormatter:(NSString *)formatter {
    NSTimeInterval time=[getTime doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatter];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

@end
