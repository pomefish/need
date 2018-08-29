//
//  OpinionViewController.m
//  mingtao
//
//  Created by Linlin Ge on 16-11-17.
//  Copyright (c) 2016年 Linlin Ge. All rights reserved.
//

#import "OpinionViewController.h"
#import "HttpRequest.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"

@interface OpinionViewController ()<TZImagePickerControllerDelegate ,UICollectionViewDataSource,UICollectionViewDelegate ,UIActionSheetDelegate ,UIImagePickerControllerDelegate ,UIAlertViewDelegate,UINavigationControllerDelegate , UITextViewDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (strong, nonatomic)  UISwitch *showSheetSwitch; ///< 显示一个sheet,把拍照按钮放在外面
@property (strong, nonatomic)  UITextField *maxCountTF; ///< 照片最大可选张数，设置为1即为单选模式
@property (strong, nonatomic)  UILabel *columnNumberTF;

@property (nonatomic, strong)  UIView *backView;
@property (nonatomic, strong)  UITextView *textView;
@property (nonatomic, copy)  NSString *fileName;
@property (nonatomic, copy)  NSString *textStr;

@property (nonatomic, assign) NSInteger i;
@property (nonatomic, strong) UIButton *determineBtn;

@property (nonatomic, copy) NSString *userID;
@end

@implementation OpinionViewController

- (UIButton *)determineBtn {
    if (!_determineBtn) {
        self.determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.determineBtn.frame = CGRectMake(20, kScreenHeight - 60, kScreenWidth - 40, 45);
        self.determineBtn.backgroundColor = kCustomViewColor;
        [self.determineBtn setTitle:@"提交" forState:UIControlStateNormal];
        self.determineBtn.clipsToBounds=YES;
        self.determineBtn.layer.cornerRadius = 2;
        [self.determineBtn addTarget:self action:@selector(determineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.view.backgroundColor = kCustomVCBackgroundColor;
    leftBarButton(@"returnImage");
    
    self.navigationController.navigationBar.barTintColor = kCustomNavColor;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _type = @"1";
    if ([_type isEqualToString:@"1"]) {
        NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
        _userID = user;
    }else {
        self.navigationController.navigationBar.barTintColor = kCustomNavColor;
        self.determineBtn.backgroundColor = kCustomViewColor;
        NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"hrID"];
        _userID = user;
    }
    
    
    [self initWithUI];
    
    [self.view addSubview:self.determineBtn];
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self configCollectionView];

 self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    _i = 0;
}
- (void)initWithUI {
    
    _backView = [UIView new];
    _backView.frame = CGRectMake(5, 74, kScreenWidth - 10, kScreenWidth - 120);
    _backView.backgroundColor = kCustomVCBackgroundColor;
    [self.view addSubview:_backView];

    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(5, 0, kScreenWidth - 20, 20);
    label.text = @"  问题和意见";
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:label];
    
    _textView = [UITextView new];
    _textView.frame = CGRectMake(5, CGRectGetMaxY(label.frame), kScreenWidth - 20, kScreenWidth - 140);
    _textView.text = @"请简要描述你的问题和意见。";
    _textView.delegate = self;
    _textView.textColor = [UIColor grayColor];
    [_backView addSubview:_textView];
    
}

- (void)determineBtnClick:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (_userID != nil) {
        if ([_textView.text isEqualToString:@""] || [_textView.text isEqualToString:@"请简要描述你的问题和意见。"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showMessage:@"请填写问题和意见。" toView:self.view delay:1.0];
            
            return;
        }
        NSString *textUrl = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/feedback"];
        NSDictionary *textDic = @{@"user_id":_userID,//用户的id
                                  @"msg_title":@"iOS问题反馈",//标题
                                  @"msg_content":_textView.text,//内容
                                  @"msg_type":_type,//1--个人\ 2--企业
                              };
        [HttpRequest postWithURLString:textUrl parameters:textDic success:^(id success) {
            NSLog(@"%@",success);
            
            if (_selectedAssets.count >= 1 ) {
                for (NSInteger i = 0; i < _selectedPhotos.count; i ++) {
                    NSString *urlSt = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/Api/Worknew/uploadnew"];
                    NSDictionary *imageDic = @{
                                               @"user_id":_userID,
                                               @"type":@"21"
                                               };
                    [HttpRequest uploadMostImageWithURLString:urlSt parameters:imageDic uploadDatas:_selectedPhotos[i] uploadName:_fileName success:^(id success){
                        if ([success[@"code"] isEqualToNumber:@5]) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        NSLog(@"上传图片请求：%@",success);
                    } failure:^(NSError *error) {
                        NSLog(@"%@",error);
                    }];
                }
            }else {
                if ([success[@"code"] isEqualToNumber:@2]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configCollectionView {
    
    UIView *bgView = [UIView new];
    bgView.frame = CGRectMake(5, CGRectGetMaxY(self.backView.frame) + 10, kScreenWidth - 10, kScreenHeight - _backView.frame.size.height - 180);
    bgView.backgroundColor = kCustomVCBackgroundColor;
    [self.view addSubview:bgView];
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(5, 0, kScreenWidth - 20, 20);
    label.text = @"  图片（选填，提供问题截图）";
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:label];
    
    // 如不需要 长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 5 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 20,kScreenWidth - 20, kScreenHeight - _backView.frame.size.height - 200) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [bgView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView endEditing:NO];
    
    if (indexPath.row == _selectedPhotos.count) {
        BOOL showSheet = self.showSheetSwitch.isOn;
        if (!showSheet) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
#pragma clang diagnostic pop
            [sheet showInView:self.view];
        } else {
            [self pushImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
        }
        
        
        if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = self.maxCountTF.text.integerValue;
            //            imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    //    if (self.maxCountTF.text.integerValue <= 0) {
    //        return;
    //    }
    self.columnNumberTF = [UILabel new];
    self.columnNumberTF.text = @"4";
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCountTF.text.integerValue columnNumber:self.columnNumberTF.text.integerValue delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    if (self.maxCountTF.text.integerValue > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusNotDetermined) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
          [alert show];
    }
    // 无权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
  //  [alert show];
#define push @#clang diagnostic pop
    //    } else { // 调用相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        //    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        //  [alert show];
    }
}
//}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        //        tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) { // 如果保存失败，基本是没有相册权限导致的...
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法保存图片" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                alert.tag = 1;
                [alert show];
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [_selectedAssets addObject:assetModel.asset];
                        [_selectedPhotos addObject:image];
                        [_collectionView reloadData];
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
        
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            if (alertView.tag == 1) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"]];
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
            
          
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}


#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    //    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            _fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            _fileName = alAsset.defaultRepresentation.filename;;
        }
        
        NSLog(@"图片名字:%@",_fileName);
    }
}

- (void)leftButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSLog(@"%ld",(long)_i);
    if (_i == 0) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    _i ++;
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
