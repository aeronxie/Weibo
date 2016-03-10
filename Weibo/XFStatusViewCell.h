
//  Weibo
//
//  Created by Fay on 15/9/26.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFStatusFrame;

@interface XFStatusViewCell : UITableViewCell

@property (nonatomic,strong) XFStatusFrame *statusFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
