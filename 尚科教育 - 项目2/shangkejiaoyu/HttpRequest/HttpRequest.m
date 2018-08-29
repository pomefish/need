//
//  HttpRequest.m
//  mingtao
//
//  Created by Linlin Ge on 2016/11/24.
//  Copyright © 2016年 Linlin Ge. All rights reserved.
//

#import "HttpRequest.h"
#import "AFHTTPSessionManager.h"

@implementation HttpRequest

#pragma mark -- GET请求 --
+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(NSDictionary * dictionary))success
                 failure:(void (^)(NSError * error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error) {
            failure(error);
        }

    }];
    
}

#pragma mark -- POST请求 --
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id success))success
                  failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
  

    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (![USERID isEqualToString:@"1"]) {
        
        if (TOKEN) {
            [dataDic setObject:TOKEN forKey:@"Token"];
        }else {
            [dataDic setObject:@"" forKey:@"Token"];
        }
        if (USERID) {
            [dataDic setObject:USERID forKey:@"uid"];
        }
    }
    NSLog(@"post = %@%@",URLString,dataDic);
    [manager POST:URLString parameters:dataDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
            if (![USERID isEqualToString:@"1"]) {
                NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if ([str isEqualToString:@"10086"]) {
                    
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"您的账号在其他设备登录。如非本人操作，建议修改密码！" preferredStyle:UIAlertControllerStyleAlert];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
                    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"重新登录" style:0 handler:^(UIAlertAction * _Nonnull action) {
                        UIWindow *winder = [[[UIApplication sharedApplication]delegate]window];
                        LogonViewController *logonVC = [[LogonViewController alloc]init];
                      
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:logonVC];
                        
                        winder.rootViewController = nav;
                    }];
                   
                    [alertVC addAction:rightAction];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
                    
                    return;
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }

    }];
}
// 上传多张图片
+ (void)uploadMostImageWithURLString:(NSString *)URLString
                          parameters:(id)parameters
                         uploadDatas:(NSArray *)uploadDatas
                          uploadName:(NSString *)uploadName
                             success:(void (^)())success
                             failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (int i = 0; i < uploadDatas.count; i++) {
            UIImage *image = uploadDatas;
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            dateString = [NSString stringWithFormat:@"%@", dateString];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            NSLog(@"图片名字========%@",fileName);
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png/jpg/jpeg"]; //

//        }
    }success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success) {
                success(responseObject);
            }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }

    }];
    
    
}

+ (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                 uploadData:(NSData *)uploadData
                 uploadName:(NSString *)uploadName
                    success:(void (^)())success
                    failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        dateString = [NSString stringWithFormat:@"yyyyMMddHHmmss"];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        [formData appendPartWithFileData:uploadData name:@"file" fileName:fileName mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}



@end
