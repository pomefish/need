//
//  InviteCell.h
//  mingtao
//
//  Created by Linlin Ge on 2017/6/8.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *invitationCodeBgImage;
@property (strong, nonatomic)  UILabel *invitationCodeLabel;
@property (strong, nonatomic)  UIButton *invitationCodeBtn;
@property (strong, nonatomic)  UIImageView *QRCodeImage;
@property (strong, nonatomic)  UIButton *explainBtn;

- (void)setupGenerate_Icon_QRCode:(NSString *)urlStr;

@end
