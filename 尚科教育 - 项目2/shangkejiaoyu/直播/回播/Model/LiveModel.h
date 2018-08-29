//
//  LiveModel.h
//  mingtao
//
//  Created by Linlin Ge on 2017/8/14.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveModel : NSObject
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *article_type;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *click_count;
@property (nonatomic, copy) NSString *descriptionStr;
@property (nonatomic, copy) NSString *modelID;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link_url;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
