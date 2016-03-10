//
//  XFEmotionTool.h
//  
//
//  Created by Fay on 15/10/22.
//
//

#import <Foundation/Foundation.h>
@class XFEmotion;
@interface XFEmotionTool : NSObject
+ (void)addRecentEmotion:(XFEmotion *)emotion;
+ (NSArray *)recentEmotions;
@end
