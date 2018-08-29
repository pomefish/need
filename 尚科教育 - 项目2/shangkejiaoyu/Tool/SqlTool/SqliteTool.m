//
//  SqliteTool.m
//  Smsx
//
//  Created by smsx on 15/11/30.
//  Copyright © 2015年 smsx. All rights reserved.
//

#import "SqliteTool.h"
#import <sqlite3.h>
@implementation SqliteTool
static sqlite3 *_db;

#pragma mark 初始化数据库
//初始化数据库
+ (void)initialize
{
    //获取cache文件路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    //拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"smsxApp.sqlite"];
    NSLog(@"%@",filePath);
    //打开数据库
    if (sqlite3_open(filePath.UTF8String, &_db)==SQLITE_OK)
    {//打开数据库
        NSLog(@"数据库打开成功");
    }
    else
    {
        NSLog(@"数据库打开失败");
    }
    
}
#pragma mark 数据库增，删，改
//数据库增，删，改
+ (void)execWithSql:(NSString *)sql AndTable:(NSString *)table
{
    char *errmsg;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg)
    {
        NSLog(@"%@--操作数据库失败——%s",table,errmsg);
    }
}
#pragma mark 判断数据库中是否某张表
//判断数据库中是否某张表
+ (NSInteger)execWithSql:(NSString *)sql
{
    sqlite3_stmt *stmt;
    NSInteger count = 0;
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK)
    {
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
             count = sqlite3_column_int(stmt, 0);
        }
    }
    return count;
}
//商品查询
#pragma mark 商品查询
+ (NSArray *)selectGoodsWithSql:(NSString *)sql
{
    // 数据库语句的字节数 -1 表示自动计算字节数
    // ppStmt句柄：用来操作查询的数据
    sqlite3_stmt *stmt;
    NSMutableArray *arrM = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK)
    {
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
           //定义字典
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            //接口字段
            int goods_id = sqlite3_column_int(stmt, 0);
            //将int型转化成NSNumber型
            NSNumber *num = [NSNumber numberWithInt:goods_id];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"goods_id"];
            NSString *goods_name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 3)];
            //将键值对添加到字典中
            [dic setValue:goods_name forKey:@"goods_name"];
            NSString *goods_desc = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 19)];
            //将键值对添加到字典中
            [dic setValue:goods_desc forKey:@"goods_desc"];
            NSString *goods_img = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 21)];
            //将键值对添加到字典中
            [dic setValue:goods_img forKey:@"goods_img"];
            double  market_price = sqlite3_column_int(stmt, 10);
            //将int型转化成NSNumber型
            num = [NSNumber numberWithInt:market_price];
            //将键值对添加到字典中
             [dic setValue:num forKey:@"market_price"];
            double  shop_price = sqlite3_column_int(stmt, 11);
            //将int型转化成NSNumber型
            num = [NSNumber numberWithInt:shop_price];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"shop_price"];
            double  promote_price  = sqlite3_column_int(stmt, 13);
            //将int型转化成NSNumber型
            num = [NSNumber numberWithInt:promote_price];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"promote_price"];
            
            
            double add_time = sqlite3_column_int(stmt, 29);
            num = [NSNumber numberWithInt:add_time];
            [dic setValue:num forKey:@"add_time"];
            //将字典添加到数组中
            [arrM addObject:dic];
        }
    }
    return arrM;
}
//品牌查询
#pragma mark品牌查询
+ (NSArray *)selectBrandWithSql:(NSString *)sql
{
    // 数据库语句的字节数 -1 表示自动计算字节数
    // ppStmt句柄：用来操作查询的数据
    sqlite3_stmt *stmt;
    NSMutableArray *arrM = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK)
    {
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //定义字典
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            //接口字段
            int brand_id = sqlite3_column_int(stmt, 0);
            //将int型转化成NSNumber型
            NSNumber *num = [NSNumber numberWithInt:brand_id];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"brand_id"];
            NSString *brand_name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 1)];
            //将键值对添加到字典中
            [dic setValue:brand_name forKey:@"brand_name"];
            NSString *brand_logo = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 2)];
            //将键值对添加到字典中
            [dic setValue:brand_logo forKey:@"brand_logo"];
            NSString *brand_desc = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 3)];
            //将键值对添加到字典中
            [dic setValue:brand_desc forKey:@"brand_desc"];
            NSString *site_url = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 4)];
            //将键值对添加到字典中
            [dic setValue:site_url forKey:@"site_url"];
            //将字典添加到数组中
            [arrM addObject:dic];
        }
    }
    return arrM;
}
//商品分类查询
#pragma mark商品分类查询
+ (NSArray *)selectCategoryWithSql:(NSString *)sql
{
    // 数据库语句的字节数 -1 表示自动计算字节数
    // ppStmt句柄：用来操作查询的数据
    sqlite3_stmt *stmt;
    NSMutableArray *arrM = [NSMutableArray array];
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK)
    {
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            int cat_id = sqlite3_column_int(stmt,0);
            NSNumber *num = [NSNumber numberWithInt:cat_id];
            [dic setValue:num forKey:@"cat_id"];
            NSString *cat_name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt,1)];
            [dic setValue:cat_name forKey:@"cat_name"];
            NSString *cat_nameimg = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt,2)];
            [dic setValue:cat_nameimg forKey:@"cat_nameimg"];
            [arrM addObject:dic];
        }
    }
    return arrM;
    
}
//店铺查询
#pragma mark店铺查询
//查询店铺的名字和id
+ (NSArray *)selectSupplierWithSql:(NSString *)sql
{
    // 数据库语句的字节数 -1 表示自动计算字节数
    // ppStmt句柄：用来操作查询的数据
    sqlite3_stmt *stmt;
    NSMutableArray *arrM = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK)
    {
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //定义字典
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            //接口字段
            int supplier_id = sqlite3_column_int(stmt, 0);
            //将int型转化成NSNumber型
            NSNumber *num = [NSNumber numberWithInt:supplier_id];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"supplier_id"];
            int type_id = sqlite3_column_int(stmt, 1);
            //将int型转化成NSNumber型
            num = [NSNumber numberWithInt:type_id];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"type_id"];
            
            NSString *supplier_name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 2)];
            //将键值对添加到字典中
            [dic setValue:supplier_name forKey:@"supplier_name"];
            
            int shop_type = sqlite3_column_int(stmt, 3);
            //将int型转化成NSNumber型
            num = [NSNumber numberWithInt:shop_type];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"shop_type"];

            //将字典添加到数组中
            [arrM addObject:dic];
        }
    }
    return arrM;
}

//查询店铺的详情
+ (NSArray *)selectSupplierDetailWithSql:(NSString *)sql
{
    // 数据库语句的字节数 -1 表示自动计算字节数
    // ppStmt句柄：用来操作查询的数据
    sqlite3_stmt *stmt;
    NSMutableArray *arrM = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK)
    {
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //定义字典
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            //接口字段
            int supplier_id = sqlite3_column_int(stmt, 0);
            //将int型转化成NSNumber型
            NSNumber *num = [NSNumber numberWithInt:supplier_id];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"supplier_id"];
            int type_id = sqlite3_column_int(stmt, 1);
            //将int型转化成NSNumber型
            num = [NSNumber numberWithInt:type_id];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"type_id"];
            
            NSString *supplier_name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 2)];
            //将键值对添加到字典中
            [dic setValue:supplier_name forKey:@"supplier_name"];
            
            int cat_id = sqlite3_column_int(stmt, 3);
            //将int型转化成NSNumber型
            num = [NSNumber numberWithInt:cat_id];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"cat_id"];
            
             NSString *cat_name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 4)];
            //将键值对添加到字典中
            [dic setValue:cat_name forKey:@"cat_name"];
            
            int shop_type = sqlite3_column_int(stmt, 5);
            //将int型转化成NSNumber型
            num = [NSNumber numberWithInt:shop_type];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"shop_type"];
            
            //将字典添加到数组中
            [arrM addObject:dic];
        }
    }
    return arrM;
}



//查询省市县名称
+(NSArray *)selectAreaWithSql:(NSString *)sql
{
    // 数据库语句的字节数 -1 表示自动计算字节数
    // ppStmt句柄：用来操作查询的数据
    sqlite3_stmt *stmt;
    NSMutableArray *arrM = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK)
    {
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //定义字典
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            //接口字段
            int region_id = sqlite3_column_int(stmt, 0);
            //将int型转化成NSNumber型
            NSNumber *num = [NSNumber numberWithInt:region_id];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"region_id"];
            int parent_id = sqlite3_column_int(stmt, 1);
            //将int型转化成NSNumber型
            num = [NSNumber numberWithInt:parent_id];
            //将键值对添加到字典中
            [dic setValue:num forKey:@"parent_id"];
            
            NSString *region_name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 2)];
            //将键值对添加到字典中
            [dic setValue:region_name forKey:@"region_name"];
            
            //将字典添加到数组中
            [arrM addObject:dic];
        }
    }
    return arrM;

}
@end
