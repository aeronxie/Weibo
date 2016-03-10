
//  Weibo
//
//  Created by Fay on 15/9/14.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "TestViewController.h"
#import "XFMessageViewController.h"


@implementation TestViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"测试控制器";
    

    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    XFMessageViewController *mess = [[XFMessageViewController alloc]init];
    
    [self.navigationController pushViewController:mess animated:YES];
    
    
}


@end
