//
//  MessageModel.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/11.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)initWithDic:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        
        self.click_count = dic[@"click_count"];
        self.ID = dic[@"id"];
        self.image = dic[@"image"];
        self.title = dic[@"title"];
        self.uid = dic[@"uid"];
        self.add_time = dic[@"add_time"];
        //        NSLog(@"----%@",_title);
        
        self.close = dic[@"close"];
        self.comment = dic[@"comment"];
        self.content = dic[@"content"];
        self.is_recommend = dic[@"is_recommend"];
        self.like_num = dic[@"like_num"];
        self.time = dic[@"time"];
        self.descriptionStr = dic[@"description"];
        self.article_log = dic[@"article_log"];
        self.c_name = dic[@"c_name"];
        self.keywords =  dic[@"keywords"];
         self.id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.type = [NSString stringWithFormat:@"%@",dic[@"type"]];
    }
    return self;
}

@end
