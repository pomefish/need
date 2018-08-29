//
//  PlayLiveIngViewController.h
//  mingtao
//
//  Created by Linlin Ge on 2017/11/9.
//  Copyright © 2017年 Linlin Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayLiveIngViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>
@property (nonatomic, strong) NSString *to_username;
@property (nonatomic, strong) NSString *to_head_icon;

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

@end
