//
//  VideoCell.h
//  mingtao
//
//  Created by Linlin Ge on 2017/3/23.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *shareVideoBtn;
@property (weak, nonatomic) IBOutlet UILabel *click_countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImage;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;

@end
