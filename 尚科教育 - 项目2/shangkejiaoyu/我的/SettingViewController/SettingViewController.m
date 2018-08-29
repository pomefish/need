//
//  SettingViewController.m
//  mingtao
//
//  Created by Linlin Ge on 16-11-16.
//  Copyright (c) 2016年 Linlin Ge. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingPasswordViewController.h"
#import "OpinionViewController.h"
#import "TGHeader.h"
#import "AboutUsViewController.h"

#import "ModifyPasswordVC.h"
#import "LogonViewController.h"

#import "OpinionViewController.h"

#import "RootView.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"设置";
    self.tabBarController.tabBar.hidden = YES;
    
    leftBarButton(@"returnImage");
    [self tableViewUI];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

}
#pragma mark - 计算缓存大小
- (NSString *)getCacheSize
{
    //定义变量存储总的缓存大小
    long long sumSize = 0;
    
    //01.获取当前图片缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    //02.创建文件管理对象
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    //获取当前缓存路径下的所有子路径
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    
    //遍历所有子文件
    for (NSString *subPath in subPaths) {
        //1）.拼接完整路径
        NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
        //2）.计算文件的大小
        long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
        //3）.加载到文件的大小
        sumSize += fileSize;
    }
    float size_m = sumSize/(1000*1000);
    NSLog(@"%f",size_m);
    return [NSString stringWithFormat:@"%.2fM",size_m];
    
}

- (void)tableViewUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = kCustomColor(247, 247, 247);
    
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.section) {
        case 0:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSArray *arr = @[@"清理缓存",@"修改密码"];
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(15, 15, 80, 12);
            label.text = arr[indexPath.row];
            label.font = [UIFont systemFontOfSize:14];
            [cell addSubview:label];
            
            if (indexPath.row == 0) {
                _label = [UILabel new];
                _label.frame = CGRectMake(15, kScreenWidth - 25, 50, 12);
                _label.font = [UIFont systemFontOfSize:12];
//                _label.text = [self getCacheSize];;
                [cell addSubview:_label];
                
            }

        }
            break;
            
        case 1:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSArray *arr = @[@"关于我们",@"意见反馈"];
            UILabel *label = [UILabel new];
        label.frame = CGRectMake(15, 15, 80, 12);
            label.text = arr[indexPath.row];
            label.font = [UIFont systemFontOfSize:14];
            [cell addSubview:label];
        
        }
            break;
            
        case 2:{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, 0, kScreenWidth, 40);
            [button setTitle:@"退出登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button addTarget:self action:@selector(exitBut:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
//            NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
//            if ([user isEqualToString:@"1"]) {
//                [button setTitle:@"登录账号" forState:UIControlStateNormal];
//            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
            if ([user isEqualToString:@"1"]) {
                return 1;
            }else{
                return 2;
            }
        }
            break;
            
        case 1:
            return 2;
            break;
            
        default:
            break;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                [AlertView(@"确定清理？", nil, @"确定", @"取消") show];
                
            }
            if (indexPath.row == 1) {
                NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
                if ([user isEqualToString:@"1"]) {
                    [AlertView(@"温馨提示", @"您现在为游客状态，登录后才能修改密码哦！", @"取消", @"去登录") show];
                    
                }else {
                    
                ModifyPasswordVC *passwordVC = [ModifyPasswordVC new];
                [self.navigationController pushViewController:passwordVC animated:YES];
                }
            }
            
        }
            break;
            
        case 1:{
            if (indexPath.row == 0) {
                AboutUsViewController *AboutUsVC = [AboutUsViewController new];
                [self.navigationController pushViewController:AboutUsVC animated:YES];
            }
            if (indexPath.row == 1) {
                OpinionViewController *opinionVC = [OpinionViewController new];
                opinionVC.type = @"1";
                [self.navigationController pushViewController:opinionVC animated:YES];
            }
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark AlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"....");
        LogonViewController *logonVC = [LogonViewController new];
        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:logonVC];
        //模态弹出  这里
        [self presentViewController:loginNav animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 3;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
             //判断点击的是确认键
         if (buttonIndex == 0) {
             NSLog(@"确认清除");
             [self getCacheSize];
            //01......
             NSFileManager *fileManager = [NSFileManager defaultManager];
            //02.....
             NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
            //03......
             [fileManager removeItemAtPath:cacheFilePath error:nil];
//             _label.text = @"0.0M";
            //04刷新第一行单元格
             NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
             [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
             
            //05 ：04和05使用其一即可
             [_tableView reloadData];//刷新表视图
         }
}
#pragma mark - 计算缓存大小

- (void)exitBut:(UIButton *)sender {
    
//    EMError *error = [[EMClient sharedClient] logout:YES];
//    if (!error) {
//        NSLog(@"环信个人退出成功");
//    }
//    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
//    if ([user isEqualToString:@"1"]) {
//        LogonViewController *logonVC = [LogonViewController new];
//        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:logonVC];
//        //模态弹出  这里
//        [self presentViewController:loginNav animated:YES completion:nil];
//        
//    }else {
    
    NSString *string = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/logout"];
    NSDictionary *userDic = @{
                              @"uid":USERID,
                               
                              };
    [HttpRequest postWithURLString:string parameters:userDic success:^(id result) {
        NSLog(@"----退出登录----%@",result);
   
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        // EPLog(@"----分享----%@",error);
    }];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPsw"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhone"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    
    NSUserDefaults *userID = [NSUserDefaults standardUserDefaults];
    
    [userID setObject:@"" forKey:@"remark"];
    [userID setObject:@"" forKey:@"avatar"];
    [userID setObject:@"" forKey:@"nickname"];

    
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    LogonViewController *logonVC = [[LogonViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:logonVC];
    window.rootViewController = nav;

}


#pragma -mark -放置于.m文件首段较为合适，本DEMO仅做功能性展示，实时监测缓存大小，从其他界面跳转到本页面，也需要刷新下表视图
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [_tableView reloadData];
}

- (void)leftButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
