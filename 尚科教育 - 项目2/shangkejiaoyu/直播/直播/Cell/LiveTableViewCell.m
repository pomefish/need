//
//  LiveTableViewCell.m
//  mingtao
//
//  Created by Linlin Ge on 2017/8/14.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "LiveTableViewCell.h"
#import "SDImageCache.h"

#import "flashSaleView.h"

@implementation LiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.appointmentBtn.clipsToBounds = YES;
    self.appointmentBtn.layer.cornerRadius = 12;
    
    self.typeLabel.layer.cornerRadius = 9;
    self.typeLabel.clipsToBounds = YES;
    _typeLabel.backgroundColor = kCustomViewColor;;;
    [self.appointmentBtn disable_EventInterval];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _appointmentBtn.frame.size.width, _appointmentBtn.frame.size.height)];
    _countLabel.font = [UIFont systemFontOfSize:12];
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.textColor = [UIColor whiteColor];
//    _countLabel.backgroundColor =[UIColor lightGrayColor];
    _countLabel.textAlignment = NSTextAlignmentRight;
    [_appointmentBtn addSubview:_countLabel];
    

    CGFloat contactWith = 25;

//    CGFloat labelwith = (kScreenWidth - contactWith)/2;
    self.contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _contactBtn.frame = CGRectMake(5, kScreenHeight / 1.9+20 +20 - 39+4.5 +2.5+4 -5, contactWith,17);
   
    [_contactBtn setBackgroundImage:[UIImage imageNamed:@"invFriend"] forState:UIControlStateNormal];
    [self addSubview:_contactBtn];
    
    
    self.contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_contactBtn.frame)+5,kScreenHeight / 1.9+20 +20 - 39+4.5-5 , kScreenWidth- kScreenWidth *0.2 -contactWith - 10-10 -5- 100-5, 30)];
    _contactLabel.textColor = [UIColor blackColor];
    _contactLabel.textAlignment = NSTextAlignmentLeft;
    _contactLabel.font = [UIFont systemFontOfSize:16];
    _contactLabel.text = @"邀请有礼";
    [self addSubview:_contactLabel];
    
   
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_contactLabel.frame),kScreenHeight / 1.9+20 +20 - 39+4.5 -5 , kScreenWidth *0.2, 30)];
    _priceLabel.textColor = [UIColor blackColor];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = [UIFont systemFontOfSize:16];
    _priceLabel.text = @"￥30.00";
    _priceLabel.userInteractionEnabled = NO;
    [self addSubview:_priceLabel];

   
 
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyBtn.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame)+10,  kScreenHeight / 1.9+20+20 - 39 +4.5 -5, 100, 30);
    _buyBtn.backgroundColor = [UIColor colorWithHexString:@"#db1e34" alpha:1.0];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buyBtn.layer.masksToBounds = YES;
    _buyBtn.layer.cornerRadius = 15;
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    _buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_buyBtn];
    
}

- (void)configurePlayLiveCellDataModel:(PlayLiveModel *)model {
    
    self.titleLabel.text = model.zhibo_title;
    NSString *headerUrl = [NSString stringWithFormat:@"%@%@",skBannerUrl,model.zhibo_header];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"loading"]];

    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",skBannerUrl,model.zhibo_thumb];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
    if (model.click_count == nil) {
       // self.clickCountLabel.text = @"0人观看";
         self.countLabel.text =  @"0人观看";
    }else {
       // self.clickCountLabel.text = [NSString stringWithFormat:@"%@人观看",model.click_count];
       self.countLabel.text =  [NSString stringWithFormat:@"%@人观看",model.click_count];
    }

    NSDate *date  = [NSDate dateWithTimeIntervalSince1970: [model.start_time  doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *dateString  = [formatter stringFromDate: date];
    
    NSString *statr = [NSString stringWithFormat:@"%@",model.start_time];
    NSDate *startdate  = [NSDate dateWithTimeIntervalSince1970: [statr doubleValue]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH:mm"];
    NSString *startStr  = [formatter1 stringFromDate: startdate];
    
    
    NSString *end = [NSString stringWithFormat:@"%@",model.end_time];
    NSDate *enddate  = [NSDate dateWithTimeIntervalSince1970: [end  doubleValue]];
    NSString *endStr  = [formatter1 stringFromDate: enddate];
    
    
    self.clickCountLabel.textAlignment = NSTextAlignmentLeft;
    self.clickCountLabel.text = [NSString stringWithFormat:@"%@ %@ 至 %@",dateString,startStr,endStr];
    self.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",model.zhibo_teacher];
    if ([model.start_time isEqualToString:@"0"]) {
        self.countTmenLabel.text = @"时间待定";
    }
    
    if ([model.status isEqualToString:@"0"]) {
        //        self.timeLabel.text = [self timeInterval:model.end_time];
        flashSaleView *flashSale = [[flashSaleView alloc] initWithFrame:_countView.bounds andEndTimer:model.start_time];
        [_countView addSubview:flashSale];
        self.typeLabel.text = @"未直播";
        self.countTmenLabel.hidden = NO;

    }else if ([model.status isEqualToString:@"1"]) {
        self.appointmentBtn.hidden = YES;
        self.typeLabel.text = @"直播中";
        self.countTmenLabel.hidden = YES;
        self.countView.hidden = YES;
    }else if ([model.status isEqualToString:@"2"]) {
        self.appointmentBtn.hidden = YES;
        self.typeLabel.text = @"已结束";
        self.countTmenLabel.hidden = YES;
        self.countView.hidden = YES;



    }
    
//    if ([model.status isEqualToString:@"1"]) {
//        self.countTmenLabel.hidden = YES;
//    }else {
//        self.countTmenLabel.hidden = NO;
////        self.timeLabel.text = [self timeInterval:model.end_time];
//        flashSaleView *flashSale = [[flashSaleView alloc] initWithFrame:_countView.bounds andEndTimer:model.start_time];
//        [_countView addSubview:flashSale];
//    }
    if ([model.collect_zhibo isEqualToString:@"1"]) {
        [self.appointmentBtn setTitle:@"已报名" forState:UIControlStateNormal];
    }
    
    self.priceLabel.text = [NSString  stringWithFormat:@"¥%@",model.zhibo_price];
}

#pragma mark --- 时间戳转换 ---
- (NSString *)timeInterval:(NSString *)getTime {
    NSTimeInterval time=[getTime doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
