//
//  XFTextView.m
//  Weibo
//
//  Created by Fay on 15/10/10.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFTextView.h"

@implementation XFTextView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    
        // 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    
    
    return self;
    
}



-(void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
    
    
}


-(void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
    
}

-(void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self setNeedsDisplay];
    
}


- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

//移除通知
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)setAttributedText:(NSAttributedString *)attributedText {
    
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
    
}

/**
 * 监听文字改变
 */
-(void)textDidChange {
    
    //重绘
    [self setNeedsDisplay];
    
}

-(void)drawRect:(CGRect)rect {
    
    if (self.hasText) return;
    
    //文字属性
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = self.font;
    attr[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    // 画文字
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];
    

}

@end
