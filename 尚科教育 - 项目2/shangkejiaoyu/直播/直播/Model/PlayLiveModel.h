//
//  PlayLiveModel.h
//  mingtao
//
//  Created by Linlin Ge on 2017/11/3.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayLiveModel : NSObject
@property (nonatomic, copy) NSString *click_count;
@property (nonatomic, copy) NSString *flv;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *rtmp;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *zhibo_thumb;
@property (nonatomic, copy) NSString *zhibo_title;
@property (nonatomic, copy) NSString *zhibo_teacher;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *collect_zhibo;
@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *zhibo_number;
@property (nonatomic, copy) NSString *zhibo_desc;
@property (nonatomic, copy) NSString *zhibo_header;
@property (nonatomic, copy) NSString *is_pay;
@property (nonatomic, copy) NSString *zhibo_price;
@property (nonatomic, copy) NSString *rank_list;




- (instancetype)initWithPlayLiveModelDic:(NSDictionary*)dic;
@end
