//
//  OneView.m
//  LinkageMenu
//
//  Created by 风间 on 2017/3/10.
//  Copyright © 2017年 EmotionV. All rights reserved.
//

#import "OneView.h"
#import "OneCollectionViewCell.h"
#import "CurriculumCollectionCell.h"
#import "HYCollectViewAlignedLayout.h"

@interface OneView()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation OneView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self.collectionView registerClass:[OneCollectionViewCell class] forCellWithReuseIdentifier:@"customCell"];
        [self.collectionView registerClass:[CurriculumCollectionCell class] forCellWithReuseIdentifier:@"curriculumCollectionCell"];
        [self addSubview:self.collectionView];
        self.collectionView.backgroundColor = kCustomColor(246, 246, 246);
        
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
//        HYCollectViewAlignedLayout *layout = [[HYCollectViewAlignedLayout alloc] initWithType:HYCollectViewAlignLeft];

        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 15, self.frame.size.height) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth - 101, 120);
    }else {
//        CGFloat cellWidth = (self.frame.size.width - 5.0) / 3.0;
//        CGFloat cellHeight = cellWidth + 20;
//        CGSize  retSize = [_dataArray[indexPath.row] boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
//        CGFloat cellWidth = retSize.width;
        
        return CGSizeMake(self.frame.size.width / 2.2, 40);
    }
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 5;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        NSLog(@"%ld    %ld",indexPath.row,indexPath.section);
        if (self.delegate && [self.delegate respondsToSelector:@selector(CurriculumVC:)]) {
            NSDictionary *dic = @{@"name":_dataArray[indexPath.row],
                                  @"catId":_catIdArr[indexPath.row]
                                  };
            [self.delegate CurriculumVC:dic];
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CurriculumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"curriculumCollectionCell" forIndexPath:indexPath];
        cell.titleLabel.text = _titleStr;
        cell.titleImage.image = [UIImage imageNamed:_titleImageName];
        return cell;
    }else {
        OneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"customCell" forIndexPath:indexPath];
        cell.titleLabel.text = [_dataArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    return nil;
    
}

@end
