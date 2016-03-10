
//  Weibo
//
//  Created by Fay on 15/9/17.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFTabBar;
@protocol XFTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(XFTabBar *)tabBar;
@end

@interface XFTabBar : UITabBar

@property(nonatomic,weak)id <XFTabBarDelegate> delegate;

@end
