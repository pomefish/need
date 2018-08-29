//
//  TeachingModel.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/8/28.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeachingModel : NSObject
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *article_type;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *click_count;
@property (nonatomic, copy) NSString *descriptionStr;
@property (nonatomic, copy) NSString *modelID;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTeachingModelDictionary:(NSDictionary *)dic;

@end
