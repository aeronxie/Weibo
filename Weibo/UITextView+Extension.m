//
//  UITextView+Extension.m
//  Weibo
//
//  Created by Fay on 15/10/20.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)
-(void)insertAttributeText:(NSAttributedString *)text {
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
    //拼接之前的文件
    [attributedText appendAttributedString:self.attributedText];
   
    //拼接图片
    NSUInteger loc = self.selectedRange.location;
    //[attributedText insertAttributedString:text atIndex:loc];
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];

    self.attributedText = attributedText;
    
    //移除光标到表情的后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
   
}


@end
