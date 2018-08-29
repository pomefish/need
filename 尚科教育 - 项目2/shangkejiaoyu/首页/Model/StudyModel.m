//
//  StudyModel.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/15.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "StudyModel.h"

@implementation StudyModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _add_time     = dic[@"add_time"];
        _name         = dic[@"name"];
        _fist_img     = dic[@"fist_img"];
        _path         = dic[@"path"];
        _title        = dic[@"title"];
        _brief        = dic[@"brief"];
        _v_h          = dic[@"v_h"];
        _v_m          = dic[@"v_m"];
        _v_s          = dic[@"v_s"];
        _modelID      = dic[@"id"];
        _teacher      = dic[@"teacher"];
        _watch_num    = dic[@"watch_num"];
        _video_url    = dic[@"video_url"];
        _class_no     = dic[@"class_no"];
        
        _l_fist_img   = dic[@"l_fist_img"];
        _l_title      = dic[@"l_title"];
        _click_count  = dic[@"click_count"];
        _shop_price   = dic[@"shop_price"];
        
        _cat_id       = dic[@"cat_id"];
        _cat_name     = dic[@"cat_name"];
        _goods_brief  = dic[@"goods_brief"];
        _duration     = dic[@"duration"];
    }
    return self;
    
}
@end
