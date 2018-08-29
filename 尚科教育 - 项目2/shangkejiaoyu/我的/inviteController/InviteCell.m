//
//  InviteCell.m
//  mingtao
//
//  Created by Linlin Ge on 2017/6/8.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//
#import <Photos/Photos.h>
#import "InviteCell.h"
#import "SGQRCode.h"//二维码
#import <AVFoundation/AVCaptureDevice.h>

#import <AVFoundation/AVMediaFormat.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>
#import <Photos/PhotosDefines.h>
@interface InviteCell (){
    UIView *bgview;
    UIImageView *_showIMAgeView;
}

@end

@implementation InviteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];
        [self addSubViews];


        //图片允许交互,别忘记设置,否则手势没有反应
        [self.QRCodeImage setUserInteractionEnabled:YES];
        //    self.QRCodeImage.frame = CGRectMake(0, 0  +30, kScreenWidth/2.46 , kScreenWidth/2.46);
        //    self.QRCodeImage.center = CGPointMake(kScreenWidth/2.0, kScreenWidth/1.73+(kScreenWidth/2.46)/2.0 +30);
        
//        self.QRCodeImage.frame = CGRectMake(0, 0, kScreenWidth/3.4, kScreenWidth/3.4);
//        self.QRCodeImage.center = CGPointMake(kScreenWidth/2.2+17, kScreenWidth/1.45+(kScreenWidth/2.46)/2.0 +8);
        //添加边框
        //    CALayer * layer = [_QRCodeImage layer];
        //    layer.borderColor = [
        //                         [UIColor whiteColor] CGColor];
        //    layer.borderWidth = 7.0f;
        //初始化一个长按手势
        UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
        
        //长按等待时间
        longPressGest.minimumPressDuration = 0.5;
        //长按时候,手指头可以移动的距离
        longPressGest.allowableMovement = 30;
        [self.QRCodeImage addGestureRecognizer:longPressGest];
        
        //轻点放大二维码
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleButon)];
        
        [self.QRCodeImage addGestureRecognizer:tap];

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
   // [self setUpViews];
  //[self addSubViews];

    // Initialization code
//    //图片允许交互,别忘记设置,否则手势没有反应
//    [self.QRCodeImage setUserInteractionEnabled:YES];
////    self.QRCodeImage.frame = CGRectMake(0, 0  +30, kScreenWidth/2.46 , kScreenWidth/2.46);
////    self.QRCodeImage.center = CGPointMake(kScreenWidth/2.0, kScreenWidth/1.73+(kScreenWidth/2.46)/2.0 +30);
//
//    self.QRCodeImage.frame = CGRectMake(0, 0, kScreenWidth/3.4, kScreenWidth/3.4);
//    self.QRCodeImage.center = CGPointMake(kScreenWidth/2.2+17, kScreenWidth/1.45+(kScreenWidth/2.46)/2.0 +8);
//    //添加边框
////    CALayer * layer = [_QRCodeImage layer];
////    layer.borderColor = [
////                         [UIColor whiteColor] CGColor];
////    layer.borderWidth = 7.0f;
//    //初始化一个长按手势
//    UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
//
//    //长按等待时间
//    longPressGest.minimumPressDuration = 0.5;
//    //长按时候,手指头可以移动的距离
//    longPressGest.allowableMovement = 30;
//    [self.QRCodeImage addGestureRecognizer:longPressGest];
//
//     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleButon)];
//
//    [self.QRCodeImage addGestureRecognizer:tap];

}
- (void)setUpViews{
    self.invitationCodeBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.778*kScreenWidth)];
    [self addSubview:_invitationCodeBgImage];
    
    self.invitationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _invitationCodeBtn.frame = CGRectMake((kScreenWidth - 160)/2, CGRectGetMaxY(_invitationCodeBgImage.frame)+12, 160, 52);
//    _invitationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    _invitationCodeBtn.backgroundColor = [UIColor orangeColor];
    [_invitationCodeBtn setBackgroundImage:[UIImage imageNamed:@"shangjin"] forState:UIControlStateNormal];
    [self addSubview:_invitationCodeBtn];
    
    self.explainBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    _explainBtn.frame = CGRectMake(10, CGRectGetMaxY(_invitationCodeBtn.frame)-2, kScreenWidth -20, 25);
    [_explainBtn setTitle:@"App 使用说明书" forState:UIControlStateNormal];
    _explainBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _explainBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [_explainBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _explainBtn.backgroundColor = [UIColor whiteColor];
   // [self addSubview:_explainBtn];
    
    if (IPHONEX) {
        self.QRCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth *0.32,kScreenHeight *0.125 -14,kScreenWidth - kScreenWidth *0.32 *2, kScreenWidth - kScreenWidth *0.32 *2)];
    }else{
    self.QRCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth *0.32,kScreenHeight *0.125 -2,kScreenWidth - kScreenWidth *0.32 *2, kScreenWidth - kScreenWidth *0.32 *2)];
    }

    [self addSubview:_QRCodeImage];
}
- (void)addSubViews{
    bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.4;
   // [[UIApplication sharedApplication].keyWindow addSubview:bgview];
     [self addSubview:bgview];
    

    _showIMAgeView = [[UIImageView alloc] init];
    
    _showIMAgeView.frame =CGRectMake(0, kNavHeight , kScreenWidth/1.3, kScreenWidth/1.3);

    _showIMAgeView.center = CGPointMake(kScreenWidth/2,kScreenHeight *0.125 + kScreenWidth *0.18);
    _showIMAgeView.backgroundColor = [UIColor greenColor];
    //添加边框
//    CALayer * layer = [_showIMAgeView layer];
//    layer.borderColor = [[UIColor whiteColor] CGColor];
//    layer.borderWidth = 7.0f;
   // [[UIApplication sharedApplication].keyWindow addSubview:_showIMAgeView];
    [self addSubview:_showIMAgeView];

    
   
    
    UITapGestureRecognizer *tapbeg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(begHiddenPic)];
    _showIMAgeView.userInteractionEnabled = YES;
    bgview.userInteractionEnabled = YES;
    [bgview addGestureRecognizer:tapbeg];

     UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHiddenPic)];
    [_showIMAgeView addGestureRecognizer:tapGes];
    _showIMAgeView.hidden = YES;
    bgview.hidden = YES;
}

-  (void)begHiddenPic{
    _showIMAgeView.hidden = YES;
    bgview.hidden = YES;
}
-(void)handleButon{
    _showIMAgeView.hidden = NO;
    bgview.hidden = NO;
      }

- (void)viewDidDisappear:(BOOL)animated{
    //[super viewDidDisappear:animated];
    [bgview removeFromSuperview];
    [_showIMAgeView removeFromSuperview];
}


- (void)tapHiddenPic{
    NSLog(@"xxxxx");
 
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否将二维码保存至相册？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        _showIMAgeView.hidden = YES;
         bgview.hidden = YES;
    }];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //保存图片
        [self saveImageToPhotos:_QRCodeImage.image];
    }];
    [alertController addAction:noAction];
    [alertController addAction:yesAction];
    [[self getCurrentViewController] presentViewController:alertController animated:YES completion:nil];
    NSLog(@"长按手势开启");

}
#pragma mark - - - 中间带有图标二维码生成
- (void)setupGenerate_Icon_QRCode:(NSString *)urlStr {
    
    CGFloat scale = 0.2;
    // 获取自己个人设置的头像
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *picStr = [user objectForKey:@"avatar"];
    // 2、将最终合得的图片显示在UIImageView上
    _QRCodeImage.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:urlStr logoImageName:picStr logoScaleToSuperView:scale];
    
    _showIMAgeView.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:urlStr logoImageName:picStr logoScaleToSuperView:scale];
}
//实现该方法
//- (void)saveImageToPhotos:(UIImage*)savedImage {
//    //判断相册权限
//
//    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//
//    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
//
//        //无权限
//
//        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)) {
//
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"照片权限被禁用" message:@"请在'设置-隐私-照片'中允许访问你的照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//
//            [alertView show];
//
//            return;
//
//        }else{
//
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"照片权限被禁用" message:@"请在'设置-隐私-照片'中允许访问你的照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//
//            [alertView show];
//
//            return;
//
//        }
//
//    }else{
//
//        //有相册权限
//        UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//        //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
//
//    }
//
//   // UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
//
////    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
////    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
////    {
////        // 无权限
////        // do something...
////    }
//
//
//}


- (void)saveImageToPhotos:(UIImage*)savedImage {
    //判断相册权限
    
    //    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (( 8.0 <=  [[[UIDevice currentDevice] systemVersion] floatValue] < 11.0 )) {
        if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
            
            //无权限
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"照片权限被禁用" message:@"请在'设置-隐私-照片'中允许访问你的照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alertView show];
            
            return;
            
        }else{
            
            //有相册权限
            UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
        }
    }else{
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
                
                UIImageWriteToSavedPhotosAlbum(savedImage,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);//保存图片到相册
            }else{
                //无权限
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"照片权限被禁用" message:@"请在'设置-隐私-照片'中允许访问你的照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                return;
            }
        }];
    }
}
//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        _showIMAgeView.hidden = YES;
        bgview.hidden = YES;
        msg = @"保存图片失败" ;
    }else{
        _showIMAgeView.hidden = YES;
        bgview.hidden = YES;
        msg = @"保存图片成功" ;
        
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alertController addAction:noAction];
    [[self getCurrentViewController] presentViewController:alertController animated:YES completion:nil];
}

//长按手势
-(void)longPressView:(UILongPressGestureRecognizer *)longPressGest{
    
    if (longPressGest.state==UIGestureRecognizerStateBegan) {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否将二维码保存至相册？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //保存图片
            UIImage *saveImage = [self addImage:_QRCodeImage.image toImage:_invitationCodeBgImage.image];
         
           [self saveImageToPhotos:saveImage];
          
        }];
        [alertController addAction:noAction];
        [alertController addAction:yesAction];
        [[self getCurrentViewController] presentViewController:alertController animated:YES completion:nil];

        NSLog(@"长按手势开启");
    } else {
        NSLog(@"长按手势结束");
    }
    
}


- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image2.size);
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    // Draw image1
    NSLog(@"sss = %f   %f",image2.size.width,image2.size.height);

    [image1 drawInRect:CGRectMake(image2.size.width/2 - image1.size.width *0.4/2,image2.size.height *0.125+20, image2.size.width*0.32 , image2.size.width*0.32)];
//      [image1 drawInRect:CGRectMake(image2.size.width *0.3,image2.size.height* 0.48 + 60 , image1.size.width*0.4 , image1.size.height*0.4)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
