//
//  InteractionCell.h
//  mingtao
//
//  Created by Linlin Ge on 2017/11/13.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayLiveModel.h"

@interface InteractionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)configurePlayLiveCellDataModel:(PlayLiveModel *)model;

+ (CGFloat)cellForHeight:(PlayLiveModel *)model;

@end
