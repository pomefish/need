//
//  MessageCell.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/11.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIImageView *picImage;
@property (nonatomic, strong) UIImageView *image;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)customCellModel:(MessageModel *)model;

@end
