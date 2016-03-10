//
//  XFEmotion.h
//  
//
//  Created by Fay on 15/10/18.
//
//

#import <Foundation/Foundation.h>

@interface XFEmotion : NSObject
/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的16进制编码 */
@property (nonatomic, copy) NSString *code;

@end
