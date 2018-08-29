//
//  StudyModel.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudyModel : NSObject

@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *brief;
@property (nonatomic, copy) NSString *fist_img;
@property (nonatomic, copy) NSString *modelID;
@property (nonatomic, copy) NSString *is_hot;
@property (nonatomic, copy) NSString *is_set;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *out_trade_no;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *product_code;
@property (nonatomic, copy) NSString *sold;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *teacher;
@property (nonatomic, copy) NSString *time_long;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *v_h;
@property (nonatomic, copy) NSString *v_m;
@property (nonatomic, copy) NSString *v_s;
@property (nonatomic, copy) NSString *watch_num;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *class_no;

@property (nonatomic, copy) NSString *l_fist_img;
@property (nonatomic, copy) NSString *l_title;
@property (nonatomic, copy) NSString *click_count;
@property (nonatomic, copy) NSString *shop_price;

@property (nonatomic, copy) NSString *cat_id;
@property (nonatomic, copy) NSString *cat_name;
@property (nonatomic, copy) NSString *goods_brief;
@property (nonatomic, copy) NSString *duration;

- (instancetype)initWithDic:(NSDictionary *)dic;


@end
