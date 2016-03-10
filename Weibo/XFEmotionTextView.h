//
//  XFEmotionTextView.h
//  Weibo
//
//  Created by Fay on 15/10/20.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import "XFTextView.h"
@class XFEmotion;
@interface XFEmotionTextView : XFTextView
-(void)insertEmotion:(XFEmotion *)emotion;
- (NSString *)fullText;
@end
