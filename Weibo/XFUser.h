//
//  XFUser.h
//  Weibo
//
//  Created by Fay on 15/9/23.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    XFUserVerifiedTypeNone = -1, // 没有任何认证
    
    XFUserVerifiedPersonal = 0,  // 个人认证
    
    XFUserVerifiedOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    XFUserVerifiedOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    XFUserVerifiedOrgWebsite = 5, // 网站官方：猫扑
    
    XFUserVerifiedDaren = 220 // 微博达人
} XFUserVerifiedType;

@interface XFUser : NSObject
/**	string	字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	友好显示名称*/
@property (nonatomic, copy) NSString *name;

/**	string	用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;
/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;
@property (nonatomic, assign, getter = isVip) BOOL vip;

/** 认证类型 */
@property (nonatomic, assign) XFUserVerifiedType verified_type;

+ (instancetype)userWithDict:(NSDictionary *)dict;

@end
