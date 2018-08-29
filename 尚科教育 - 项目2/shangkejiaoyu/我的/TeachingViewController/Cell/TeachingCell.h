//
//  TeachingCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/8/28.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface TeachingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *browseLabel;
- (void)customCellModel:(MessageModel *)model;

@end
