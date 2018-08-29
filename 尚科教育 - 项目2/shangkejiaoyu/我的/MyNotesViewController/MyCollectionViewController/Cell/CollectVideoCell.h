//
//  CollectVideoCell.h
//  mingtao
//
//  Created by Linlin Ge on 2017/3/22.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyModel.h"

@interface CollectVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIButton *noCollectionBtn;

- (void)configureCellDataModel:(StudyModel *)model;

@end
