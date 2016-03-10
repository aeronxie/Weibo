
//  Weibo
//
//  Created by Fay on 15/10/3.
//  Copyright © 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFStatusPhotosView : UIView
@property(nonatomic,strong) NSArray *photos;
/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(int)count;

@end
