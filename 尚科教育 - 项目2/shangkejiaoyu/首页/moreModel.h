//
//  moreModel.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/3/28.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface moreModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *goods_brief;
@property (nonatomic,assign)NSInteger click_count;
@property (nonatomic,assign)NSInteger cat_id;
@property (nonatomic,copy)NSString *fist_img;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
