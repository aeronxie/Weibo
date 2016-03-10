//
//  XFAccount.m
//  Weibo
//
//  Created by Fay on 15/9/20.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFAccount.h"

@implementation XFAccount

+(instancetype)accountWithDict:(NSDictionary *)dict {
    
    XFAccount *account = [[self alloc]init];
    
    account.access_token = dict[@"access_token"];
    account.uid = dict[@"uid"];
    account.expires_in = dict[@"expires_in"];
    // 获得账号存储的时间（accessToken的产生时间）
    account.created_time = [NSDate date];
    return account;

}
/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.created_time forKey:@"created_time"];
    [aCoder encodeObject:self.name forKey:@"name"];
   
}


/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.created_time = [aDecoder decodeObjectForKey:@"created_time"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        
    }
    
    return self;
}


@end
