//
//  XFEmotionListView.m
//  Weibo
//
//  Created by Fay on 15/10/16.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFEmotionListView.h"
#import "XFEmotionPageView.h"
// 每一页的表情个数
#define XFEmotionPageSize 20

@interface XFEmotionListView ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;

@end

@implementation XFEmotionListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        // 1.UIScollView
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
         // 2.pageControl
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        //私有属性，使用KVC赋值
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
  
    }
    return self;
}


// 根据emotions，创建对应个数的表情
-(void)setEmotions:(NSArray *)emotions {
    
    _emotions = emotions;

    // 删除之前的控件
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //计算页码
    NSUInteger count = (emotions.count + XFEmotionPageSize - 1) /XFEmotionPageSize;
     // 1.设置页数
    self.pageControl.numberOfPages = count;
    // 2.创建用来显示每一页表情的控件
    for (int i = 0; i<self.pageControl.numberOfPages; i++) {
        XFEmotionPageView *pageView = [[XFEmotionPageView alloc]init];
        // 计算这一页的表情范围
        NSRange range;
        range.location  = i *XFEmotionPageSize;
        // left：剩余的表情个数（可以截取的）
        NSUInteger left = emotions.count - range.location;
        if (left >= XFEmotionPageSize) {
            range.length = XFEmotionPageSize;
        }else {
            
            range.length = left;
        }
        
        //设置这一页表情
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    
    [self setNeedsLayout];
    
}


-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    //1.pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    //2.scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = self.scrollView.y = 0;

    
    //3.设置scrollerView内部每一页的尺寸
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i<count; i++) {
        XFEmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.height = self.scrollView.height;
        pageView.width = self.scrollView.width;
        pageView.x = i * pageView.width;
        pageView.y = 0;
    }
    //4.设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
    
}

#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    double pageNum = scrollView.contentOffset.x / scrollView.width;
    
    self.pageControl.currentPage = (int)(pageNum + 0.5);
    
    
}


@end
