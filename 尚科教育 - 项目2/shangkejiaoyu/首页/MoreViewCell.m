//
//  MoreViewCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2018/3/28.
//  Copyright © 2018年 ShangKe. All rights reserved.
//

#import "MoreViewCell.h"
#import "UILabel+Size.h"
#import "moreModel.h"
@implementation MoreViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];

    }
    return  self;
}

- (void)setUpViews{
    CGFloat picWidth = kScreenWidth *0.38;
    CGFloat picHeight = picWidth *0.7;
    CGFloat titleWidth = kScreenWidth - picWidth - 30;
    
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"社会心理学社会心理学社会心理学社会心理学社会心理学社会心理学社会心理学社会心理学社会心理学社会心理学(1)";
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.backgroundColor = [UIColor redColor];
    CGSize titleSize = [_titleLabel boundingRectWithSize:CGSizeMake(0, 0)];
    _titleLabel.frame = CGRectMake(10, 10,titleWidth, titleSize.height);
    self.titleHeight = titleSize.height;
    [self addSubview:_titleLabel];
    
    self.middleLabel = [[UILabel alloc] init];
//    _middleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _middleLabel.text = @"暂无简介";
    _middleLabel.textColor  = [UIColor lightGrayColor];
    _middleLabel.font = [UIFont systemFontOfSize:15];
      CGSize middleSize = [_middleLabel boundingRectWithSize:CGSizeMake(0, 0)];
    _middleLabel.frame = CGRectMake(10,CGRectGetMaxY(self.titleLabel.frame)+ 10 , titleWidth, middleSize.height);
    self.middleHeight = _middleHeight;
    [self addSubview:_middleLabel];
    
    self.playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_middleLabel.frame)+13, 14, 14)];
    _playImageView.backgroundColor = [UIColor redColor];
    [self addSubview:_playImageView];
    
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playImageView.frame)+5, CGRectGetMaxY(_middleLabel.frame)+ 10, 80, 20)];
//    _numLabel.text = @"14400";
    _numLabel.font = [UIFont systemFontOfSize:13];
    _learnLabel.textColor = [UIColor lightGrayColor];
//    _numLabel.backgroundColor = [UIColor redColor];
    [self addSubview:_numLabel];
    
    self.learnLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numLabel.frame)+ 5, CGRectGetMaxY(_middleLabel.frame) + 10, titleWidth -18 - 10-80 - 5, 20)];
//    _learnLabel.text = @"1330人学习";
//    _learnLabel.backgroundColor = [UIColor orangeColor];
    _learnLabel.textColor = [UIColor lightGrayColor];
    _learnLabel.font = [UIFont systemFontOfSize:13];

    [self addSubview:_learnLabel];
    
    self.picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - picWidth, 10, picWidth, picHeight)];
    _picImageView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_picImageView];
    
}

-  (void)setModel:(moreModel *)model{
    if (model != _model ) {
        self.titleLabel.text = model.title;
        self.middleLabel.text = model.goods_brief;
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)model.click_count];
        
        self.learnLabel.text = [NSString stringWithFormat:@"%ld 人学习",model.click_count];
        self.picImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.fist_img]];
        }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
