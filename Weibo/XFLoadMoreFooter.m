//
//  XFLoadMoreFooter.m
//  Weibo
//
//  Created by Fay on 15/9/25.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFLoadMoreFooter.h"

@implementation XFLoadMoreFooter

//+(instancetype)footer{
//    
//    
//    return [[[NSBundle mainBundle] loadNibNamed:@"XFLoadMoreFooter" owner:nil options:nil] lastObject];
//    
//}

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UILabel *label = [[UILabel alloc]init];
        label.width = [UIScreen mainScreen].bounds.size.width;
        label.height = 44;
        label.text = @"加载更多内容";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:18 weight:2.0];
    
        [self addSubview:label];
    }
    
    return self;
}

@end
