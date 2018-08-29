//
//  CustomAlertView.h
//  mingtao
//
//  Created by Linlin Ge on 2017/6/6.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^cancelBlock)();
typedef void(^sureBlock)(NSString*name,NSString*idnumber);

@interface CustomAlertView : UIView

@property(nonatomic, strong)cancelBlock cancel_block;
@property(nonatomic, strong)sureBlock sure_block;
+(instancetype)alertViewWithCancelbtnClicked:(cancelBlock) cancelBlock andSureBtnClicked:(sureBlock) sureBlock withName:(NSString *)name withidcard:(NSString *)idnumber;

@end
