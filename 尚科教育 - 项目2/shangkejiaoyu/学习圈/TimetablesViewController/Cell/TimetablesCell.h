//
//  TimetablesCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/10.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface TimetablesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)customCellModel:(MessageModel *)model;

@end
