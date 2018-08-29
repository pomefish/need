//
//  CommentsModel.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/1/13.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsModel : NSObject
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *modelID;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *avatar;


@property (nonatomic, assign) BOOL isHomeVC;
- (instancetype)initWithCommentsModelDictionary:(NSDictionary *)dic;

@end
