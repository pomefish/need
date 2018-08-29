//
//  LiveTableViewCell.h
//  mingtao
//
//  Created by Linlin Ge on 2017/8/14.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayLiveModel.h"
#import "flashSaleView.h"

@interface LiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *clickCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet flashSaleView *countTmen;
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn;
    @property (weak, nonatomic) IBOutlet UILabel *countTmenLabel;

//zji jia
@property (nonatomic,strong)UIButton *contactBtn;
@property (nonatomic,strong)UILabel *contactLabel;

@property (nonatomic,strong)UIButton *buyBtn;
@property (nonatomic,strong)UILabel *countLabel;
@property (nonatomic,strong)UILabel *priceLabel;


- (void)configurePlayLiveCellDataModel:(PlayLiveModel *)model;

@end
