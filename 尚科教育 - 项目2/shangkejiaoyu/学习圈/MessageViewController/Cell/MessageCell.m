//
//  MessageCell.m
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/7/11.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubViews];
    }
    return self;
}

- (void)configureSubViews {
    
    //    [_picImage removeFromSuperview];
    _picImage = [UIImageView new];
    _picImage.frame = CGRectMake(10, 12, kWidth / 3.8, kHeight + 10);
    [self addSubview:_picImage];
    
    _titleLabel = [UILabel new];
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_picImage.frame) + 5, 12, self.frame.size.width - 100, 40);
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
    
    _numberLabel = [UILabel new];
    _numberLabel.frame = CGRectMake(CGRectGetMaxX(_picImage.frame) + 5, CGRectGetMaxY(_titleLabel.frame) + 5, 60, 10);
    _numberLabel.font = [UIFont systemFontOfSize:10];
    _numberLabel.textColor = kCustomViewColor;
    [self addSubview:_numberLabel];
    
    _nameLabel = [UILabel new];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_numberLabel.frame) + 5, CGRectGetMaxY(_titleLabel.frame) + 5, 80, 10);
    _nameLabel.font = [UIFont systemFontOfSize:10];
    _nameLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_nameLabel];
    
    _image = [UIImageView new];
    _image.backgroundColor = [UIColor redColor];
    _image.frame = CGRectMake(CGRectGetMaxX(_picImage.frame) - 5, 6, 12, 12);
    _image.layer.cornerRadius = 6;
    _image.clipsToBounds = YES;
    [self addSubview:_image];
    
    UIView *shu = [UIView new];
    shu.frame = CGRectMake(CGRectGetMaxX(_numberLabel.frame) - 5, CGRectGetMaxY(_titleLabel.frame) + 5, 1, 10);
    shu.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:shu];
}

- (void)customCellModel:(MessageModel *)model {
    //    NSLog(@"---+--%@",_model.title);
    _titleLabel.text = model.title;
    _nameLabel.text = [self timeInterval:model.add_time];
    if ([model.click_count isKindOfClass:[NSNull class]]) {
        _numberLabel.text = @"2人阅读";
        
    }else {
        _numberLabel.text = [NSString stringWithFormat:@"%@人阅读",model.click_count];
    }
    if ([model.article_log isEqualToString:@"1"]) {
        _image.hidden = YES;
    }else {
        _image.hidden = NO;
    }
    
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",skImageUrl,model.image];
    [_picImage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"load"]];
}

#pragma mark --- 时间戳转换 ---
- (NSString *)timeInterval:(NSString *)getTime {
    NSTimeInterval time=[getTime doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
