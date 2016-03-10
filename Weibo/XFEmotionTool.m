//
//  XFEmotionTool.m
//  
//
//  Created by Fay on 15/10/22.
//
//

// 最近表情的存储路径
#define XFRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]


#import "XFEmotionTool.h"
#import "XFEmotion.h"
@implementation XFEmotionTool

static NSMutableArray *_recentEmotions;

+ (void)initialize
{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:XFRecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}

+ (void)addRecentEmotion:(XFEmotion *)emotion
{
    // 删除重复的表情
    [_recentEmotions removeObject:emotion];
    
    // 将表情放到数组的最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 将所有的表情数据写入沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:XFRecentEmotionsPath];
}

/**
 *  返回装着XFEmotion模型的数组
 */
+ (NSArray *)recentEmotions
{
    return _recentEmotions;
}
@end
