//
//  CommentsCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/1/13.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsModel.h"

@interface CommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UILabel *zanNumber;

- (void)customCommentsCellModel:(CommentsModel* )model;

+ (CGFloat)cellForHeight:(CommentsModel *)model;
@end
