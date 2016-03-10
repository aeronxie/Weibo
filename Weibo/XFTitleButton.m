//
//  XFTitleButton.m
//  Weibo
//
//  Created by Fay on 15/9/22.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "XFTitleButton.h"

@implementation XFTitleButton

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //[self setTitle:@"首页" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        
    }
    
    return self;
}

-(void)layoutSubviews {

    [super layoutSubviews];
        // 1.计算titleLabel的frame
    self.titleLabel.x = 0;
    // 2.计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 10;
    //self.titleLabel.x = self.imageView.x;
      
}




-(void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    [super setTitle:title forState:state];
    
    // 只要修改了文字，就让按钮重新计算自己的尺寸

    [self sizeToFit];
    
}


-(void)setImage:(UIImage *)image forState:(UIControlState)state {
    
    [super setImage:image forState:state];
    
    [self sizeToFit];
    
}

@end
