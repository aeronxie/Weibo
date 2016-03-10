//
//  XFStatusFrame.m
//  Weibo
//
//  Created by Fay on 15/9/26.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFStatusFrame.h"
#import "XFStatus.h"
#import "XFUser.h"
#import "XFStatusPhotosView.h"


@implementation XFStatusFrame

////算出文字的最大宽度
//- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW {
//    
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = font;
//    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
//    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//
//}
//
//
//- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
//{
//    return [self sizeWithText:text font:font maxW:MAXFLOAT];
//}



-(void)setStatus:(XFStatus *)status {
    
    _status  = status;
    
    XFUser *user = status.user;
    // cell的宽度
    
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 原创微博 */
    
    /** 头像 */
    CGFloat iconWH = 40;
    CGFloat iconX = XFStatusCellBorderW;
    CGFloat iconY = XFStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + XFStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:XFStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX,nameY},nameSize};
    

    /** 会员图标 */
    if (user.isVip) {
        
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + XFStatusCellBorderH;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 时间 */
    
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + XFStatusCellBorderH;
    CGSize timeSize = [status.created_at sizeWithFont:XFStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + XFStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:XFStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};

    
    /** 正文 */
    
    CGFloat contentX = XFStatusCellBorderW;
    CGFloat contentY = CGRectGetMaxY(self.iconViewF) + XFStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [status.text sizeWithFont:XFStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    
    /** 配图 */
     CGFloat originalH = 0;
    if (status.pic_urls.count) {
        CGFloat photosX = XFStatusCellBorderW;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + XFStatusCellBorderW;
        CGSize photosSize = [XFStatusPhotosView sizeWithCount:(int)status.pic_urls.count];
        self.photosViewF = (CGRect){{photosX, photosY}, photosSize};
        originalH = CGRectGetMaxY(self.photosViewF) + XFStatusCellBorderW;
    }else { // 没配图
        originalH = CGRectGetMaxY(self.contentLabelF) + XFStatusCellBorderW;
    }

    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);

   
    
    CGFloat toolbarY = 0;
    /* 被转发微博 */
    if (status.retweeted_status) {
        XFStatus *retweeted_status = status.retweeted_status;
        XFUser *retweeted_status_user = retweeted_status.user;
        
        /** 被转发微博正文 */
        CGFloat retweetContentX = XFStatusCellBorderW;
        CGFloat retweetContentY = XFStatusCellBorderW;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
        CGSize retweetContentSize = [retweetContent sizeWithFont:XFStatusCellRetweetContentFont maxW:maxW];
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        
        /** 被转发微博配图 */
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count) { // 转发微博有配图
            CGSize retweetPhotosSize = [XFStatusPhotosView sizeWithCount:(int)retweeted_status.pic_urls.count];
            CGFloat retweetPhotosX = retweetContentX;
            CGFloat retweetPhotosY = CGRectGetMaxY(self.retweetContentLabelF) + XFStatusCellBorderW;
           self.retweetPhotosViewF = (CGRect){{retweetPhotosX, retweetPhotosY}, retweetPhotosSize};
            
            retweetH = CGRectGetMaxY(self.retweetPhotosViewF) + XFStatusCellBorderW;
        } else { // 转发微博没有配图
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + XFStatusCellBorderW;
        }
        
        /** 被转发微博整体 */
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW;
        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        
        toolbarY = CGRectGetMaxY(self.retweetViewF);
    } else {
        toolbarY = CGRectGetMaxY(self.originalViewF);
    }
    
    /** 工具条 */
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 35;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarF) + XFStatusMargin;


}



@end
