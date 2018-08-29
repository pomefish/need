//
//  SqliteTool.h
//  Smsx
//
//  Created by smsx on 15/11/30.
//  Copyright © 2015年 smsx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqliteTool : NSObject
//数据库增，删，改
+ (void)execWithSql:(NSString *)sql AndTable:(NSString *)table;
//判断数据库中是否某张表
+ (NSInteger)execWithSql:(NSString *)sql;
//查询商品信息表
+ (NSArray *)selectGoodsWithSql:(NSString *)sql;
//查询品牌信息表
+ (NSArray *)selectBrandWithSql:(NSString *)sql;
//查询商品分类信息表
+ (NSArray *)selectCategoryWithSql:(NSString *)sql;
//查询店铺信息表
+ (NSArray *)selectSupplierWithSql:(NSString *)sql;
//查询店铺详情
+ (NSArray *)selectSupplierDetailWithSql:(NSString *)sql;
//查询省市县名称
+(NSArray *)selectAreaWithSql:(NSString *)sql;
@end
