//
//  InformationViewController.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/19.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationCell.h"
#import "AFHTTPSessionManager.h"
@interface InformationViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSData      *imageData;
@property (nonatomic, strong) NSString    *sex;
@end

@implementation InformationViewController
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [UIView new];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"InformationCell" bundle:nil] forCellReuseIdentifier:@"informationCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    self.title = @"个人中心";
    leftBarButton(@"returnImage");
    rightBarButton(@"保存")

    [self.view addSubview:self.tableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"informationCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.titleLabel.text = @"头像";
            cell.headImage.hidden = NO;

            if (_imageData == nil) {
                [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",skBannerUrl,_dataDic[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"tx"]];
            }

            break;
        case 1:
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"昵称";
                cell.sexLabel.hidden = YES;
                cell.nameTF.hidden = NO;
                cell.nameTF.text = _dataDic[@"nickname"];
            }else if (indexPath.row == 1) {
                cell.titleLabel.text = @"性别";
                cell.sexLabel.hidden = NO;
                if ([_dataDic[@"sex"] isEqualToString:@"1"]) {
                    cell.sexLabel.text = @"男";
                    _sex = @"1";
                }else {
                    cell.sexLabel.text = @"女";
                    _sex = @"0";
                }
            }else if (indexPath.row == 2) {
                cell.titleLabel.text = @"手机号";
                cell.sexLabel.hidden = NO;
                cell.sexLabel.text = _dataDic[@"name"];
            }else if (indexPath.row == 3) {
                cell.titleLabel.text = @"开通时间";
                cell.sexLabel.hidden = NO;
                cell.sexLabel.text = [self timeInterval:_dataDic[@"reg_time"]];
            }else if (indexPath.row == 4) {
                cell.titleLabel.text = @"结束时间";
                cell.sexLabel.hidden = NO;
                cell.sexLabel.text = [self timeInterval:_dataDic[@"ends_time"]];
            }else if (indexPath.row == 5) {
                cell.titleLabel.text = @"教务老师";
                cell.sexLabel.hidden = NO;
                if ([_dataDic[@"teacher"] isEqualToString:@""]) {
                    cell.sexLabel.text = @"暂无";
                }else {
                    cell.sexLabel.text = _dataDic[@"teacher"];
                }
            }
            break;
        case 2:
            cell.titleLabel.text = @"个人简介";
            cell.introductionTV.hidden = NO;
            cell.introductionTV.text = _dataDic[@"remark"];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                //头像
                [self cameraAlertController];
            }
            break;
        case 1:
            if (indexPath.row == 1) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *boye = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    //                    _xingbieLb.text = @"男";
                   // [_dataDic setObject:@"1" forKey:@"sex"];
                   // [_tableView reloadData];
                    InformationCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                    
                    cell.sexLabel.text = @"男";
                    _sex = @"1";
                    
                }];
                UIAlertAction *girl = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    //                    _xingbieLb.text = @"女";
                    // [_dataDic setObject:@"0" forKey:@"sex"];
                    // [_tableView reloadData];
                    InformationCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                    
                    cell.sexLabel.text = @"女";
                    _sex = @"0";
                    
                }];
                [alertController addAction:boye];
                [alertController addAction:girl];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            break;
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 6;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60.0f;
    }else if (indexPath.section == 2) {
        return 80.0f;
    }
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, kScreenWidth,0.01);
        return header;
        
    }
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth,10);
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, kScreenWidth,0.01);
    return header;
}
#pragma mark - UIImagePickerControllerDelegate
- (void)cameraAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES; //可编辑
        //判断是否可以打开照相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            

        {
            
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        
        else
            
        {
            NSLog(@"没有摄像头");
            
        }
        
    }];
    UIAlertAction *chosePhotoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        
        // 进入相册
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:^{
                
                NSLog(@"打开相册");
            }];
            
        }
        else
        {
            NSLog(@"不能打开相册");
            
        }
        
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }];
    
    [alert addAction:takePhotoAction];
    [alert addAction:chosePhotoAction];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//拍摄完成后要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"图片%@",image);
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"kChangeIconImage" object:nil userInfo:@{@"iconImage" : image}];
    _imageData = UIImageJPEGRepresentation(image, 0.5);
    //    [_dataDic setObject:image forKey:@"avatar"];
    //图片存入相
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    InformationCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    cell.headImage.image = image;
    
    [self unloadImageRequest];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)unloadImageRequest {
    if (_imageData != nil) {
        NSUserDefaults *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
        NSString *urlSt = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Manage/Up/upload"];
        NSDictionary *imageDic = @{
                                   @"uid":user,
                                   @"type":@"2"
                                   };
        [HttpRequest uploadWithURLString:urlSt parameters:imageDic uploadData:_imageData uploadName:nil success:^(id success) {
            NSLog(@"图片上传成功====%@",success);
            if ([success[@"msg"] isEqualToString:@"上传图片成功"]) {
            }
        } failure:^(NSError *error) {
            NSLog(@"图片上传失败===%@",error);
        }];
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        //这句话加了之后返回的responseObject就是JSONData了，如果不加那就是正常的JSON可以直接转成字典然后操作
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"image/jpeg",@"text/plain", nil];
//
//        NSUserDefaults *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
//        NSString *urlSt = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Manage/Up/upload"];
//        NSDictionary *imageDic = @{
//                                   @"uid":user,
//                                   @"type":@"2"
//                                   };
//        [manager POST:urlSt parameters:imageDic success:^(NSURLSessionDataTask *task, id success) {
//
//            NSLog(@"图片上传成功====%@",success);
//
//            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:(NSData *)success options:NSJSONReadingMutableContainers error:nil];
//
//
//            NSLog(@"ttt = %@",object);
//                        if ([object[@"status"] isEqualToString:@"1"]) {
//                            [MBProgressHUD showMessage:@"上传成功" toView:self.view delay:1.3];
//                        }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                NSLog(@"图片上传失败===%@",error);
//
//        }];
    }
    
}

- (void)rightButton:(UIButton *)sender {
    InformationCell *name = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    InformationCell *introductionText = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
   
    
    if (name.nameTF.text != nil ) {
        NSUserDefaults *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
        
        NSString *str = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/user_info"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *dic = @{
                              @"uid":user,
                              @"nickname":name.nameTF.text,
                              @"sex":_sex,
                        @"remark":introductionText.introductionTV.text,
                              @"birth":@"",
                              @"profession":@"",
                              @"city":@"",
                              };
//NSLog(@"-----%@------",dic);
        [HttpRequest postWithURLString:str parameters:dic success:^(id success) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",success);
            if ([success[@"msg"] isEqualToString:@"成功"]) {
                [MBProgressHUD showMessage:@"保存成功!" toView:self.tableView delay:1.0];

                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            NSLog(@"%@",error);
        }];
        
    }else {
        [MBProgressHUD showMessage:@"请将信息填写完整。" toView:self.tableView delay:1.0];
    }
}

#pragma mark --- 时间戳转换 ---
- (NSString *)timeInterval:(NSString *)getTime {
    NSTimeInterval time=[getTime doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

- (void)leftButton:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
