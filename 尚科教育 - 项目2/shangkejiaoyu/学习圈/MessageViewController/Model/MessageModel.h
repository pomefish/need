//
//  MessageModel.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/11.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic, copy) NSString *click_count;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSString *close;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *is_recommend;
@property (nonatomic, copy) NSString *like_num;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *article_type;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *descriptionStr;

@property (nonatomic, copy) NSString *article_log;

//题库model

@property (nonatomic, copy) NSString *c_name;

@property (nonatomic, copy) NSString  *keywords;
@property (nonatomic, copy) NSString   *id;
@property (nonatomic, copy) NSString   *type;



- (instancetype)initWithDic:(NSDictionary*)dic;


@end
