//
//  OneView.h
//  LinkageMenu
//
//  Created by 风间 on 2017/3/10.
//  Copyright © 2017年 EmotionV. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CurriculumVCDelegate <NSObject>
- (void)CurriculumVC:(NSDictionary *)dic;
@end

@interface OneView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<CurriculumVCDelegate> delegate;

@property (nonatomic, copy)  NSArray *dataArray;
@property (nonatomic, copy)  NSArray  *catIdArr;

@property (nonatomic, copy)  NSString *titleStr;
@property (nonatomic, copy)  NSString *titleImageName;

@end
