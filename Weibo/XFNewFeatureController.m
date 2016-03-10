//
//  XFNewFeatureController.m
//  Weibo
//
//  Created by Fay on 15/9/19.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "XFNewFeatureController.h"
#import "XFTabBarViewController.h"
#define KCount 4
@interface XFNewFeatureController ()<UIScrollViewDelegate>
@property(nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic,weak) UIButton *shareBtn;

@end

@implementation XFNewFeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.frame = self.view.bounds;
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    scrollView.contentSize = CGSizeMake(scrollW * KCount, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
   
    for (int i = 0; i < KCount; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.x = i * scrollW;
        imageView.y = 0;
        imageView.width = scrollW;
        imageView.height = scrollH;
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d",i+1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        if (i == KCount -1) {
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
            [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
            [shareBtn setTitle:@"分享至微博" forState:UIControlStateNormal];
            [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
            shareBtn.centerX = imageView.width *0.24;
            shareBtn.centerY = imageView.height * 0.70;
            shareBtn.height = 30;
            shareBtn.width = 200;
            [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
            self.shareBtn = shareBtn;
            [imageView addSubview:shareBtn];
            
            
            UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
            [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
            [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
            [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            startBtn.centerX = imageView.width *0.25;
            startBtn.centerY = imageView.height * 0.80;
            startBtn.height = 40;
            startBtn.width = 180;
            [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:startBtn];

        }
      
        
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = KCount;
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH - 40;
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
    


}

//开始按钮
-(void)startClick {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[XFTabBarViewController alloc]init];
    
    
}


//分享按钮
-(void)shareClick {
    
    self.shareBtn.selected = !self.shareBtn.isSelected;
    
}





//监听pageControl
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    double page = scrollView.contentOffset.x / scrollView.width;
    
    self.pageControl.currentPage = (int)(page + 0.5);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
