//
//  PlayLiveModel.m
//  mingtao
//
//  Created by Linlin Ge on 2017/11/3.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "PlayLiveModel.h"

@implementation PlayLiveModel

- (instancetype)initWithPlayLiveModelDic:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        
        self.click_count = dic[@"click_count"];
        self.flv = dic[@"flv"];
        self.ID = dic[@"id"];
        self.like_count = dic[@"like_count"];
        self.rtmp = dic[@"rtmp"];
        self.status = dic[@"status"];
        self.zhibo_thumb = dic[@"zhibo_thumb"];
        self.zhibo_title = dic[@"zhibo_title"];
        self.zhibo_teacher = dic[@"zhibo_teacher"];
        self.key = dic[@"key"];
        self.end_time = dic[@"end_time"];
        self.start_time = dic[@"start_time"];
        self.collect_zhibo = dic[@"collect_zhibo"];
        self.group_id = dic[@"group_id"];
        
        self.content = dic[@"content"];
        self.zhibo_number = dic[@"zhibo_number"];
        self.zhibo_desc = dic[@"zhibo_desc"];
        self.zhibo_header = dic[@"zhibo_header"];
        self.is_pay = [NSString stringWithFormat:@"%@",dic[@"is_pay"]];
        self.zhibo_price = [NSString stringWithFormat:@"%@",dic[@"zhibo_price"]];
        self.rank_list = [NSString stringWithFormat:@"%@",dic[@"rank_list"]];
    }
    return self;
}

@end
