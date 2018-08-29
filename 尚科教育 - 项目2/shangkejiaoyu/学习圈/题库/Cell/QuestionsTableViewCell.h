//
//  QuestionsTableViewCell.h
//  mingtao
//
//  Created by Linlin Ge on 2017/7/8.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface QuestionsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

- (void)customCellModel:(MessageModel *)model;

@end
