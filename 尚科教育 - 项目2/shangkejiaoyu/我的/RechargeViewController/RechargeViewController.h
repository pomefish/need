//
//  RechargeViewController.h
//  mingtao
//
//  Created by Linlin Ge on 2017/6/6.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (strong, nonatomic) UIButton *moneyNumberBtn;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (strong, nonatomic) UILabel *moneyNumberLabel;

@end
