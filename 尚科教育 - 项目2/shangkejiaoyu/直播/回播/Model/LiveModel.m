//
//  LiveModel.m
//  mingtao
//
//  Created by Linlin Ge on 2017/8/14.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import "LiveModel.h"

@implementation LiveModel

- (instancetype)initWithDic:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        
        self.click_count  = dic[@"click_count"];
        self.article_type = dic[@"article_type"];
        self.author       = dic[@"author"];
        self.click_count  = dic[@"click_count"];
        self.descriptionStr = dic[@"description"];
        self.modelID = dic[@"id"];
        self.image = dic[@"image"];
        self.title = dic[@"title"];
        self.link_url = dic[@"link_url"];
    }
    return self;
}

@end
