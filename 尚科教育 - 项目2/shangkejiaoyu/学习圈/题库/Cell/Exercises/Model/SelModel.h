//
//  SelModel.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/4/8.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelModel : NSObject
//服务器获取的用户填写的答案
@property (nonatomic,copy)NSString *select;
@property (nonatomic,copy)NSString *id;



- (instancetype)initWithDic:(NSDictionary *)dic;
@end
