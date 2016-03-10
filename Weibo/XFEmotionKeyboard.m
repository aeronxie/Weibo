//
//  XFEmotionKeyboard.m
//  Weibo
//
//  Created by Fay on 15/10/16.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFEmotionKeyboard.h"
#import "XFEmotionTabBar.h"
#import "XFEmotionListView.h"
#import "XFEmotion.h"
#import "MJExtension.h"
#import "XFEmotionTool.h"

@interface XFEmotionKeyboard()<XFEmotionTabBarDelegate>

/** 保存正在显示listView */
@property (nonatomic, weak) XFEmotionListView *showingListView;
/** 表情内容 */
@property (nonatomic, strong) XFEmotionListView *recentListView;
@property (nonatomic, strong) XFEmotionListView *defaultListView;
@property (nonatomic, strong) XFEmotionListView *emojiListView;
@property (nonatomic, strong) XFEmotionListView *lxhListView;

/** tabbar */
@property (nonatomic, weak) XFEmotionTabBar *tabBar;

@end

@implementation XFEmotionKeyboard

#pragma mark - 懒加载

-(XFEmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[XFEmotionListView alloc] init];
        //加载沙盒中的数据
        self.recentListView.emotions = [XFEmotionTool recentEmotions];
        
    }
    return _recentListView;
}

-(XFEmotionListView *)defaultListView {
    
    if (!_defaultListView) {
        self.defaultListView = [[XFEmotionListView alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];

        self.defaultListView.emotions = [XFEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        
        
    }
    return _defaultListView;
 
}

- (XFEmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[XFEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiListView.emotions = [XFEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        
    }
    return _emojiListView;
}

- (XFEmotionListView *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[XFEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        self.lxhListView.emotions = [XFEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        
    }
    return _lxhListView;
}



-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
         // tabbar
        XFEmotionTabBar *tabbar = [[XFEmotionTabBar alloc]init];
        tabbar.delegate = self;
        [self addSubview:tabbar];
        self.tabBar = tabbar;
        // 表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:@"EmotionDidSelectNotification" object:nil];
    }
    

    return self;
}


-(void)emotionDidSelect {
    
    self.recentListView.emotions = [XFEmotionTool recentEmotions];
    
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 1.tabbar
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
    
    // 2.表情内容
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
    
}

#pragma mark - XFEmotionTabBarDelegate
- (void)emotionTabBar:(XFEmotionTabBar *)tabBar didSelectButton:(XFEmotionTabBarButtonType)buttonType {
    
     // 移除正在显示的listView控件
    [self.showingListView removeFromSuperview];
    
    // 根据按钮类型，切换contentView上面的listview
    switch (buttonType) {
        case XFEmotionTabBarButtonTypeDefault:{//默认
           
            [self addSubview:self.defaultListView];
            
            break;
        }
        case XFEmotionTabBarButtonTypeLxh:{//浪小花
           [self addSubview:self.lxhListView];
            
            break;
        }
        case XFEmotionTabBarButtonTypeEmoji:{ //Emoji
             [self addSubview:self.emojiListView];
            
            break;
        }
            
        case XFEmotionTabBarButtonTypeRecent:{ //最近
            
            [self addSubview:self.recentListView];
            break;
        }
        
    }
    
    // 设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    // 重新计算子控件的frame(setNeedsLayout内部会在恰当的时刻，重新调用layoutSubviews，重新布局子控件)
    [self setNeedsLayout];
}
@end
