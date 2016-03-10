//
//  XFComposePhotosView.h
//  Weibo
//
//  Created by Fay on 15/10/16.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFComposePhotosView : UIView
-(void)addPhoto:(UIImage *)photo;
@property (nonatomic, strong,readonly) NSMutableArray *photos;
@end
