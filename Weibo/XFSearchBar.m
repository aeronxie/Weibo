//
//  XFSearchBar.m
//  Weibo
//
//  Created by Fay on 15/9/16.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFSearchBar.h"

@implementation XFSearchBar

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        self.placeholder = @"请输入要搜索的内容";
        self.font = [UIFont systemFontOfSize:13];
        UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
        
        searchIcon.width = 30;
        
        searchIcon.height = 30;
        
        self.leftView = searchIcon;
        
        searchIcon.contentMode = UIViewContentModeCenter;
        
        self.leftViewMode = UITextFieldViewModeAlways;
     
    }

    return self;    
}





+(instancetype)searchBar {
 
    return [[self alloc]init];
    
}
@end
