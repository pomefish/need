//
//  EnterpriseCentreCell.h
//  mingtao
//
//  Created by Linlin Ge on 2017/4/22.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterpriseCentreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hadeImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftConstraint;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusWidthConstraint;

@property (nonatomic,strong)UILabel *redLabel;

@end
