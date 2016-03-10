//
//  XFEmotionAttachment.m
//  
//
//  Created by Fay on 15/10/22.
//
//

#import "XFEmotionAttachment.h"
#import "XFEmotion.h"

@implementation XFEmotionAttachment
- (void)setEmotion:(XFEmotion *)emotion
{
   
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}
@end
