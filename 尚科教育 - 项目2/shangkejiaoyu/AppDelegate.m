//
//  AppDelegate.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/14.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "AppDelegate.h"
#import "LogonViewController.h"
#import "RootView.h"

#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>

#import "ContentViewController.h"

//版本更新
#import "CheckVersionManager.h"
#import "UIWindow+PazLabs.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件

#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

//人人SDK头文件
#import <RennSDK/RennSDK.h>


#import "YDPopViewController.h"
#import "UIViewController+PopView.h"
//友盟统计
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>



@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
//    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"userID"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (userID != nil) {
        [RootView logonRootView];
    }else {
        LogonViewController *logonVC = [[LogonViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:logonVC];
        self.window.rootViewController = nav;
    }
    [self.window makeKeyAndVisible];
    
    
    
    [UMessage startWithAppkey:@"59a4ff758f4a9d73a90017b4" launchOptions:launchOptions httpsEnable:YES];
    
    [UMessage startWithAppkey:@"59a4ff758f4a9d73a90017b4" launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    //友盟统计
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager] ;
    [UMConfigure setLogEnabled:YES];//设置打开日志
    [UMConfigure initWithAppkey:@"59a4ff758f4a9d73a90017b4" channel:@"App Store"];
    NSString *deviceID =  [UMConfigure deviceIDForIntegration];
//    NSLog(@"集成测试的deviceID:%@",deviceID);
 
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
            NSLog(@"点击允许");
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
            NSLog(@"点击不允许");
        }
    }];
    
        
    [UMessage setLogEnabled:YES];
    
    
#pragma mark-- 环信
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *optind = [EMOptions optionsWithAppkey:@"1120170504115008#shangke"];
    optind.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:optind];
    
    //添加自定义小表情
#pragma mark smallpngface
    [[EaseEmotionEscape sharedInstance] setEaseEmotionEscapePattern:@"\\[[^\\[\\]]{1,6}\\]"];
    [[EaseEmotionEscape sharedInstance] setEaseEmotionEscapeDictionary:[EaseConvertToCommonEmoticonsHelper emotionsDictionary]];
    
//    [self getArticleNumberRequest];
    
    // 自己加 注册微信app id（微信支付）
       [WXApi registerApp:@"wx39db09650e3fb9d5"];
    //初始化
    [self registerActivePlatforms];
    return YES;
}



- (void)registerActivePlatforms {
    /**初始化ShareSDK应用
     
     @param activePlatforms
     
     使用的分享平台集合
     
     @param importHandler (onImport)
     
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     
     @param configurationHandler (onConfiguration)
     
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     
     */
    
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
//                                        @(SSDKPlatformTypeMail),
//                                        @(SSDKPlatformTypeSMS),
//                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
//                                        @(SSDKPlatformTypeRenren),
//                                        @(SSDKPlatformTypeFacebook),
//                                        @(SSDKPlatformTypeTwitter),
//                                        @(SSDKPlatformTypeGooglePlus)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             case SSDKPlatformTypeRenren:
                 [ShareSDKConnector connectRenren:[RennClient class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx39db09650e3fb9d5"
                                       appSecret:@"2e8d2c1d59182c4448cc66c4277878de"];
                 break;
             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:@"1106225881"
//                                      appKey:@"eFEOv7mMnqOT8jXG"
//                                    authType:SSDKAuthTypeBoth];
//                 break;
            
                 [appInfo SSDKSetupQQByAppId:@"1106816451"
                                      appKey:@"Za1xdyxBy2IsqT36"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeFacebook:
                 [appInfo SSDKSetupFacebookByApiKey:@"107704292745179"
                                          appSecret:@"38053202e1a5fe26c80c753071f0b573"
                                        displayName:@"shareSDK"
                                           authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeTwitter:
                 [appInfo SSDKSetupTwitterByConsumerKey:@"LRBM0H75rWrU9gNHvlEAA2aOy"
                                         consumerSecret:@"gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G"
                                            redirectUri:@"http://mob.com"];
                 break;
             case SSDKPlatformTypeGooglePlus:
                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                            redirectUri:@"http://localhost"];
                 break;
             default:
                 break;
         }
     }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
//    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"手动注册devicetoken");
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
}

- (void)getArticleNumberRequest {
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/article"];
    NSDictionary *dic = @{@"page":@(1),
                          @"pagesize":@"10",
                          @"uid":userID
                          
                          };
    [HttpRequest postWithURLString:urlStr parameters:dic success:^(id success) {
        NSLog(@"%@",success);
        
        [[NSUserDefaults standardUserDefaults] setObject:success[@"count"] forKey:@"countNumber"];
        
    } failure:^(NSError *error) {
        
        
    }];
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"DidReceiveRemoteNotification:%@",userInfo);
    
    
    //把icon上的标记数字设置为0,
    application.applicationIconBadgeNumber = 0;
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
 
    
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        NSLog(@"-------------------%@",userInfo);
    }else{
        //应用处于前台时的本地推送接受
        NSLog(@"-------------------%@",userInfo);

    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        NSLog(@"-------------------%@",userInfo);
        MessageModel *model = [[MessageModel alloc] init];
        model.ID = userInfo[@"id"];
        model.title = userInfo[@"aps"][@"alert"];
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        if (userID != nil) {
            ContentViewController *contenVC = [[ContentViewController alloc] init];
            contenVC.contentModel = model;
            
            UINavigationController *pushNav = [[UINavigationController alloc]initWithRootViewController:contenVC];
            [self.window.rootViewController presentViewController:pushNav animated:YES completion:nil];
        }
        
        
    }else if ([userInfo[@"type"] isEqualToString:@"3"]) {
        //                [self.tabBarController setSelectedIndex:2];
        YDPopViewController * vc1 = [[YDPopViewController alloc] initWithNibName:@"YDPopViewController" bundle:nil];
        vc1.mainButtonBlock = ^{
            NSLog(@"点击进入主会场=====");
        };
        vc1.closeButtonBlock = ^{
            NSLog(@"点击关闭按钮=====");
        };
        [[UIApplication sharedApplication].delegate.window.rootViewController presentpopupViewController:vc1 animationType:(CCPopupViewAnimationFade)];
    }
    
    else{
        //应用处于后台时的本地推送接受
        NSLog(@"-------------------%@",userInfo);

    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"\n ===> 程序重新激活 !");
    [CheckVersionManager  checkNewEditionWithAppID:@"1262955383" ctrl:[self.window visibleViewController]];
    
    [CheckVersionManager checkNewEditionWithAppID:@"1262955383" CustomAlert:^(AppleStoreModel *appInfo) {
        NSLog(@"----------------%@",appInfo);
    }];//2种用法,自定义Alert
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self getArticleNumberRequest];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"从哪个app跳转而来 Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    
    // 提示并展示query
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打开URL Scheme成功"
                                                        message:[url query]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL*)url
{
    // 接受传过来的参数
    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打开啦"
                                                        message:text
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    return YES;
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
