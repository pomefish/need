//
//  flashSaleView.m
//  CLFlashSale
//
//  Created by darren on 16/8/26.
//  Copyright © 2016年 shanku. All rights reserved.
//

#define TimerFont [UIFont systemFontOfSize:12]
#define TimerFont11 [UIFont systemFontOfSize:18]

#import "flashSaleView.h"

@interface flashSaleView()
{
    NSUInteger expiresTime;
    NSUInteger nowTime;
    NSDate *date1970;
    NSDateFormatter *dateFormatter;
    NSInteger aDay;
}
@property (nonatomic,strong) UIButton *dayBtn;
/**小时*/
@property (nonatomic,strong) UIButton *hourBtn;
/**分钟*/
@property (nonatomic,strong) UIButton *minuteBtn;
/**秒*/
@property (nonatomic,strong) UIButton *secondBtn;

/**:*/
@property (nonatomic,strong) UIButton *mBtn0;
@property (nonatomic,strong) UIButton *mBtn1;
@property (nonatomic,strong) UIButton *mBtn2;

@end

@implementation flashSaleView

- (UIButton *)dayBtn {
    if (_dayBtn == nil) {
        _dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dayBtn.frame = CGRectMake(0, 0, 20, self.frame.size.height);
        _dayBtn.backgroundColor = [UIColor colorWithRed:18/255.0 green:52/255.0 blue:88/255.0 alpha:1];
        _dayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _dayBtn.titleLabel.font = TimerFont;
        _dayBtn.layer.cornerRadius = 2.0;
        _dayBtn.clipsToBounds=YES;


    }
    return _dayBtn;
}

- (UIButton *)mBtn0 {
    if (_mBtn0 == nil) {
        _mBtn0 = [UIButton buttonWithType:UIButtonTypeCustom];
        _mBtn0.frame = CGRectMake(CGRectGetMaxX(_dayBtn.frame), 0, 10, _dayBtn.frame.size.height);
        _mBtn0.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_mBtn0 setTitle:@":" forState:UIControlStateNormal];
        _mBtn0.titleLabel.font = TimerFont11;
        
        [_mBtn0 setTitleColor:[UIColor colorWithRed:18/255.0 green:52/255.0 blue:88/255.0 alpha:1] forState:UIControlStateNormal];
    }
    return _mBtn0;
}

- (UIButton *)hourBtn {
    if (_hourBtn == nil) {
        _hourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hourBtn.frame = CGRectMake(CGRectGetMaxX(_mBtn0.frame), 0, 20, self.frame.size.height);
        _hourBtn.backgroundColor = [UIColor colorWithRed:18/255.0 green:52/255.0 blue:88/255.0 alpha:1];
        _hourBtn.titleLabel.font = TimerFont;
        _hourBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _hourBtn.layer.cornerRadius = 2.0;
//        _hourBtn.layer.borderWidth = 1;
//        _hourBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _hourBtn.clipsToBounds=YES;

    }
    return _hourBtn;
}

- (UIButton *)mBtn1 {
    if (_mBtn1 == nil) {
        _mBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _mBtn1.frame = CGRectMake(CGRectGetMaxX(_hourBtn.frame), 0, 10, _hourBtn.frame.size.height);
        _mBtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_mBtn1 setTitle:@":" forState:UIControlStateNormal];
        _mBtn1.titleLabel.font = TimerFont11;

        [_mBtn1 setTitleColor:[UIColor colorWithRed:18/255.0 green:52/255.0 blue:88/255.0 alpha:1] forState:UIControlStateNormal];
    }
    return _mBtn1;
}

- (UIButton *)minuteBtn {
    if (_minuteBtn == nil) {
        _minuteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _minuteBtn.frame = CGRectMake(CGRectGetMaxX(_mBtn1.frame),0 , 20, _hourBtn.frame.size.height);
        _minuteBtn.titleLabel.font = TimerFont;
        _minuteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _minuteBtn.layer.cornerRadius = 2.0;
//        _minuteBtn.layer.borderWidth = 1;
//        _minuteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _minuteBtn.clipsToBounds=YES;

        _minuteBtn.backgroundColor = [UIColor colorWithRed:18/255.0 green:52/255.0 blue:88/255.0 alpha:1];
    }
    return _minuteBtn;
}
- (UIButton *)mBtn2
{
    if (_mBtn2 == nil) {
        _mBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _mBtn2.frame = CGRectMake(CGRectGetMaxX(_minuteBtn.frame), 0, 10, _hourBtn.frame.size.height);
        _mBtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_mBtn2 setTitle:@":" forState:UIControlStateNormal];
        _mBtn2.titleLabel.font = TimerFont11;

        [_mBtn2 setTitleColor:[UIColor colorWithRed:18/255.0 green:52/255.0 blue:88/255.0 alpha:1] forState:UIControlStateNormal];
    }
    return _mBtn2;
}

- (UIButton *)secondBtn {
    if (_secondBtn == nil) {
        _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _secondBtn.frame = CGRectMake(CGRectGetMaxX(_mBtn2.frame), 0, 20,_hourBtn.frame.size.height);        _secondBtn.backgroundColor = [UIColor colorWithRed:247/255.0 green:84/255.0 blue:60/255.0 alpha:1];
        _secondBtn.titleLabel.font = TimerFont;
        _secondBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _secondBtn.layer.cornerRadius = 2.0;
//        _secondBtn.layer.borderWidth = 1;
//        _secondBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _secondBtn.clipsToBounds=YES;

    }
    return _secondBtn;
}

- (instancetype)initWithFrame:(CGRect)frame andEndTimer:(NSString *)endTimer
{
    if (self == [super initWithFrame:frame]) {
        
        date1970 = [NSDate dateWithTimeIntervalSince1970:0];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd HH mm ss"];

//        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
        aDay = 86399;
        expiresTime = 0;
        nowTime = 0;
        
        // 从1970年到现在的时间（秒）
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval second =[dat timeIntervalSince1970];
        NSString *starTimer = [NSString stringWithFormat:@"%.0f", second];
        [self addSubview:self.dayBtn];
        [self addSubview:self.mBtn0];
        [self addSubview:self.hourBtn];
        [self addSubview:self.mBtn1];
        [self addSubview:self.minuteBtn];
        [self addSubview:self.mBtn2];
        [self addSubview:self.secondBtn];

        expiresTime = (NSUInteger) (endTimer.longLongValue);
//        expiresTime += [[NSDate date] timeIntervalSince1970];
        nowTime = (NSUInteger) starTimer.longLongValue;
        
        __block NSUInteger timeout= expiresTime; //倒计时时间
        NSString *curStr = [self homeLimitTimeString];
        [self labelValueHandler:curStr];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=starTimer.longLongValue){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }else{
                NSString *curStr1 = [self homeLimitTimeString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self labelValueHandler:curStr1];
                });
                
                timeout--;
            }
        });
        dispatch_resume(_timer);

    }
    return self;
}
-(NSString*)homeLimitTimeString{
    
    NSTimeInterval timeActualValue;
    if (expiresTime<nowTime) {
        return @"00 00 00 00";
    }
    NSTimeInterval diffTime  = expiresTime - nowTime;
//    NSLog(@"111111===%lu",(expiresTime - nowTime)/3600/24);   /// 这里可以设置天数
    timeActualValue = diffTime;
    nowTime++;

    NSDate *curDate = [date1970 dateByAddingTimeInterval:timeActualValue];
    NSTimeZone *zone =  [NSTimeZone timeZoneWithAbbreviation:@"GMT-0800"];
    NSInteger interval = [zone secondsFromGMTForDate: curDate];
    NSDate *localeDate = [curDate  dateByAddingTimeInterval: interval];
    NSString *destDateString = [dateFormatter stringFromDate:localeDate];
    return destDateString;
}
-(void)labelValueHandler:(NSString*)text{
    NSArray *titleArr = [text componentsSeparatedByString:@" "];
    NSString *days = titleArr[0];
    if ([days integerValue] ==0) {
        [self.dayBtn setTitle:titleArr[0] forState:UIControlStateNormal];
        _dayBtn.frame = CGRectMake(0, 0, 20, self.frame.size.height);

    } else {

        CGFloat width = (expiresTime - nowTime)/3600/24 > 99 ? 25 :20;
        _dayBtn.frame = CGRectMake(width > 20 ? -5 : 0, 0, width, self.frame.size.height);

        if (expiresTime < nowTime) {
            [self.dayBtn setTitle: @"00" forState:UIControlStateNormal];
             _dayBtn.frame = CGRectMake(0, 0, 20, self.frame.size.height);
        } else {
            
            if ((expiresTime - nowTime)/3600/24 <= 10) {
                [self.dayBtn setTitle:[NSString stringWithFormat:@"%02lu",(expiresTime - nowTime)/3600/24] forState:UIControlStateNormal];
            } else {
                [self.dayBtn setTitle:[NSString stringWithFormat:@"%lu",(expiresTime - nowTime)/3600/24] forState:UIControlStateNormal];
            }
        }
        
    }
//    [self.dayBtn setTitle:titleArr[0] forState:UIControlStateNormal];
    [self.hourBtn setTitle:titleArr[1] forState:UIControlStateNormal];
    [self.minuteBtn setTitle:titleArr[2] forState:UIControlStateNormal];
    [self.secondBtn setTitle:titleArr[3] forState:UIControlStateNormal];
}
@end
