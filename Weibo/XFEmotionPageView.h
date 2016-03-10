//
//  XFEmotionPageView.h
//  
//
//  Created by Fay on 15/10/18.
//
//

#import <UIKit/UIKit.h>
// 一页中最多3行
#define XFEmotionMaxRows 3
// 一行中最多7列
#define XFEmotionMaxCols 7
// 每一页的表情个数
#define XFEmotionPageSize ((XFEmotionMaxRows * XFEmotionMaxCols) - 1)

@interface XFEmotionPageView : UIView
/** 这一页显示的表情（里面都是XFEmotion模型） */
@property (nonatomic, strong) NSArray *emotions;

@end
