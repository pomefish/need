//
//  ModifyPasswordVC.h
//  mingtao
//
//  Created by Linlin Ge on 2017/4/13.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *originalPswImage;
@property (weak, nonatomic) IBOutlet UITextField *originalPswTF;
@property (weak, nonatomic) IBOutlet UIImageView *pswNewImage;
@property (weak, nonatomic) IBOutlet UITextField *pswNewTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIImageView *pswImage;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@end
